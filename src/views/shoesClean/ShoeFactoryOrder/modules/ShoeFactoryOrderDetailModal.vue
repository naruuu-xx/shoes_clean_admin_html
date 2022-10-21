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
      </a-row>
    </div>

    <a-modal :zIndex="2000" :width="1000" :visible="showImageModal" :footer="null"
             @cancel="handleShoeImageModalCancel()">
      <img alt="example" style="width: 100%" :src="clickedImage">
    </a-modal>

  </j-modal>
</template>

<script>

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
    }
  },
  created() {
  },
  methods: {
    show(record) {
      this.visible = true;
      this.data = Object.assign({}, record);

      this.imageList = JSON.parse(record.orderImages);

      let factoryStatus = this.data.factoryStatus;
      if (factoryStatus === 1) {
        this.factoryStatus = "已入库";
      } else if (factoryStatus === 2) {
        this.factoryStatus = "已出库";
      }

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