<template>
  <j-modal
    :title="title"
    :width="900"
    :visible="visible"
    switchFullscreen
    @cancel="handleCancel"
    cancelText="关闭"
    :footer="null"
    wrapClassName="full-modal">
    <div style="margin-left: 20px">
      <a-row>
        <a-col :span="1"></a-col>
        <!-- 左半部分 -->
        <a-col :span="11">
          <a-row>
            <a-col :span="24"><p class="label-title">商品信息</p></a-col>
          </a-row>
          <a-row>
            <a-col :span="24"><p class="label-content">商品名：{{ data.title }}</p></a-col>
          </a-row>
          <a-row>
            <a-col :span="24"><p class="label-content">商品规格：{{ data.skuTitle }}</p></a-col>
          </a-row>
          <a-row>
            <a-col :span="24"><p class="label-title">用户信息</p></a-col>
          </a-row>
          <a-row>
            <a-col :span="24"><p class="label-content">用户姓名：{{ data.name }}</p></a-col>
          </a-row>
          <a-row>
            <a-col :span="24"><p class="label-content">手机号：{{ data.phone }}</p></a-col>
          </a-row>
          <a-row>
            <a-col :span="24"><p class="label-title">订单信息</p></a-col>
          </a-row>
          <a-row>
            <a-col :span="24"><p class="label-content">订单编号：{{ data.no }}</p></a-col>
          </a-row>
          <a-row>
            <a-col :span="24"><p class="label-content">备注：{{ data.orderNote }}</p></a-col>
          </a-row>
          <a-row>
            <a-col :span="24"><p class="label-content">处理方式：{{ data.dealType }}</p></a-col>
          </a-row>
          <a-row>
            <a-col :span="24"><p class="label-content">订单状态：{{ data.status }}</p></a-col>
          </a-row>
          <a-row>
            <a-col :span="24"><p class="label-content">入库时间：{{factoryInTime}}</p></a-col>
          </a-row>
          <a-row>
            <a-col :span="24"><p class="label-content">出库时间：{{factoryOutTime}}</p></a-col>
          </a-row>
        </a-col>
        <!-- 右半部分 -->
        <a-col :span="12">
          <a-row>
            <a-col :span="24"><p class="label-title">异常照片</p></a-col>
            <a-col :span="24">
              <img alt="example" style="width: 25%;height:25%;margin: 10px" v-for="item in exceptionImageList"
                   :src="item" @click="showImage(item)">
            </a-col>
          </a-row>
          <a-row>
            <a-col :span="24"><p class="label-title">异常备注</p></a-col>
            <a-col :span="24"><p class="label-content">{{ data.exceptionNote }}</p></a-col>
          </a-row>
        </a-col>
      </a-row>
    </div>

    <a-modal :zIndex="2000" :width="1000" :visible="showImageModal" :footer="null"
             @cancel="handleShoeImageModalCancel()">
      <img alt="example" style="width: 100%" :src="clickedImage">
    </a-modal>

  </j-modal>
</template>

<script>
import {httpAction} from "../../../../api/manage";

export default {
  name: "ShoeOrderExceptionDetailModal",
  components: {},
  data() {
    return {
      visible: false,
      title: '异常订单详情',
      data: {},
      exceptionImageList: [],
      showImageModal: false,
      clickedImage: "",
      factoryInTime: "",
      factoryOutTime: "",
    }
  },
  created() {
  },
  methods: {
    show(record) {
      this.visible = true;
      this.data = Object.assign({}, record);

      let status = this.data.status;
      if (0 === status) {
        this.data.status = "未处理";
      } else if (1 === status) {
        this.data.status = "处理中";
      } else if (2 === status) {
        this.data.status = "已处理";
      }

      let dealType = this.data.dealType;
      if (0 === dealType) {
        this.data.dealType = "未处理";
      } else if (1 === dealType) {
        this.data.dealType = "增加服务费";
      } else if (2 === dealType) {
        this.data.dealType = "退回";
      }

      this.exceptionImageList = JSON.parse(record.images);

      //查询出入库时间
      let queryData = {
        "orderId": this.data.orderId
      }
      httpAction("/ShoeOrder/shoeOrder/getShoeOrderLogisticsInfo", queryData, "post").then((res) => {
        this.factoryInTime = res.result.factoryInTime;
        if (res.result.factoryOutTime === null) {
          this.factoryOutTime = "";
        } else {
          this.factoryOutTime = res.result.factoryOutTime;
        }
      })

    },
    handleCancel() {
      this.visible = false;
      this.data = {};
      this.exceptionImageList = [];
      this.factoryInTime = {};
      this.factoryOutTime = {};
    },
    showImage(item) {
      this.showImageModal = true;
      this.clickedImage = item;
    },
    handleShoeImageModalCancel() {
      this.showImageModal = false;
      this.clickedImage = "";
    }
  }
}
</script>

<style scoped>
.label-title {
  color: #f77810;
  font-size: 22px;
}
.label-content {
  font-size: 20px;
  color: #000000;
}
</style>