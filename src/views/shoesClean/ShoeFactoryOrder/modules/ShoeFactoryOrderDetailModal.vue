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
              <a-col :span="24"><p class="label-content">附加服务：{{ data.additionalName || "无" }}</p></a-col>
            </a-row>
          </a-row>
          <a-row>
            <a-row>
              <a-col :span="24"><p class="label-title">用户信息</p></a-col>
            </a-row>
            <a-row>
              <a-col :span="24"><p class="label-content">用户姓名：{{ data.name }}</p></a-col>
            </a-row>
            <a-row>
              <a-col :span="24"><p class="label-content">手机号：{{ data.phone }}</p></a-col>
            </a-row>
          </a-row>
          <a-row>
            <a-row>
              <a-col :span="24"><p class="label-title">订单信息</p></a-col>
            </a-row>
            <a-row>
              <a-col :span="24"><p class="label-content">订单编号：{{ data.no }}</p></a-col>
            </a-row>
            <a-row>
              <a-col :span="24"><p class="label-content">备注：{{ data.note }}</p></a-col>
            </a-row>
            <a-row>
              <a-col :span="24"><p class="label-content">订单状态：{{ factoryStatus }}</p></a-col>
            </a-row>
            <a-row>
              <a-col :span="24"><p class="label-content">入库时间：{{data.factoryInTime}}</p></a-col>
            </a-row>
            <a-row>
              <a-col :span="24"><p class="label-content">出库时间：{{data.factoryOutTime}}</p></a-col>
            </a-row>
          </a-row>
          <a-row v-if="'expressage' === data.type && 2 === data.status">
            <a-row>
              <a-col :span="24"><p class="label-title">快递信息</p></a-col>
            </a-row>
            <a-row>
              <a-col :span="24"><p class="label-content">快递单号：{{expressagesInfo.kuaidinum}}</p></a-col>
            </a-row>
            <a-row>
              <a-col :span="24"><p class="label-content">快递员：{{expressagesInfo.courierName}}</p></a-col>
            </a-row>
            <a-row>
              <a-col :span="24"><p class="label-content">手机号：{{expressagesInfo.courierMobile}}</p></a-col>
            </a-row>
          </a-row>
        </a-col>
        <!-- 右半部分 -->
        <a-col :span="12">
          <a-row>
            <a-col :span="24"><p class="label-title">订单照片</p></a-col>
            <a-col :span="24">
              <img alt="example" style="width: 25%;height:25%;margin: 10px" v-for="item in imageList"
                   :src="item" @click="showImage(item)">
            </a-col>
          </a-row>
        </a-col>
        <!-- 异常信息部分 -->
        <a-col :span="12" v-if="orderException != null">
          <a-row>
            <a-row>
              <a-col :span="24"><p class="label-title">异常信息</p></a-col>
            </a-row>
            <a-row>
              <a-col :span="24"><p class="label-content">异常原因：{{ orderException.note }}</p></a-col>
            </a-row>
            <a-row>
            <a-col :span="24"><p class="label-content">异常照片</p></a-col>
            <a-col :span="24">
              <img alt="example" style="width: 25%;height:25%;margin: 10px" v-for="item in exceptionImageList"
                   :src="item" @click="showImage(item)">
            </a-col>
            </a-row>
            <a-row>
              <a-col :span="24"><p class="label-content">处理方式：{{ dealTypeText }}</p></a-col>
            </a-row>
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
import {filterDictTextByCache} from "../../../../components/dict/JDictSelectUtil";

export default {
  name: "ShoeFactoryOrderDetailModal",
  components: {},
  data() {
    return {
      visible: false,
      title: '订单详情',
      data: {},
      imageList: [],
      showImageModal: false,
      clickedImage: "",
      factoryStatus: "",
      factoryInTime: "",
      factoryOutTime: "",
      expressagesInfo: {},
      exceptionImageList: [],
      orderException: {},
      dealTypeText: ""
    }
  },
  created() {
  },
  methods: {
    show(record) {
      this.visible = true;
      this.data = Object.assign({}, record);

      //请求接口，获取订单图片
      httpAction("/ShoeOrder/shoeOrder/getOrderImages?orderId=" + record.orderId, null, "get").then((res) => {
        let result = res.result;
        if (result === null) {
          this.imageList = [];
        } else {
          this.imageList = JSON.parse(res.result.orderImages);
        }


        let factoryStatus = this.data.status;
        if (factoryStatus === 1) {
          this.factoryStatus = "已入库";
        } else if (factoryStatus === 2) {
          this.factoryStatus = "已出库";
        }
      })

      //请求接口，获取快递信息
      if ('expressage' === this.data.type && 2 === this.data.status) {
        this.getExpressagesInfo(this.data.orderId);
      }

      //请求接口，获取异常信息
      httpAction("/ShoeOrder/shoeOrder/queryExceptionOrderInfo?orderId=" + record.orderId, null, "get").then((res) => {
        this.orderException = res.result;
        let dealType = res.result.dealType;
        this.exceptionImageList = JSON.parse(res.result.images);
        this.dealTypeText = filterDictTextByCache('shoe_order_exception_deal_type', dealType);
        console.log(dealType, 1212121212121);
        console.log(this.dealTypeText, 4545454545454);
      })

    },
    handleCancel() {
      this.visible = false;
      this.data = {};
      this.imageList = [];
      this.factoryStatus = "";
    },
    showImage(item) {
      this.showImageModal = true;
      this.clickedImage = item;
    },
    handleShoeImageModalCancel() {
      this.showImageModal = false;
      this.clickedImage = "";
    },
    getExpressagesInfo(orderId){
      httpAction("/ShoeOrder/shoeOrder/getExpressageInfo?orderId=" + orderId, null, "get").then((res) => {
        if (res.success) {
          this.expressagesInfo = res.result;
        }
      })
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