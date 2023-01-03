<template>
  <j-modal
    :title="title"
    :width="600"
    :visible="visible"
    switchFullscreen
    @cancel="handleCancel"
    cancelText="关闭"
    :footer="null"
    wrapClassName="full-modal"
  >
    <div class="diyDiv">
      <div class="main">
        <div class="content-font-below">订单编号：{{ data.no }}</div>
        <div class="content-font-below">商品名称：{{ data.title }}</div>
        <div class="content-font-below">商品规格：{{ data.skuTitle }}</div>
        <div class="content-font-below">商品价格（元）：{{ data.goodsPrice }}</div>
        <div class="content-font-below">附加金额（元）：{{ data.additionalPrice }}</div>
        <div class="content-font-below">优惠金额（元）：{{ data.couponPrice }}</div>
        <div class="content-font-below">配送费（元）：{{ data.courierPrice }}</div>
        <div class="content-font-below">实付金额（元）：{{ data.actualPrice }}</div>
        <div class="content-font-below">
          退款金额：
          <a-input-number v-model="refundPrice" :min="0.01" />
        </div>
      </div>
      <div class="foot">
        <a-button type="primary"  @click="onRefund"> 退款 </a-button>
        <a-button @click="handleCancel">取消</a-button>
      </div>
    </div>

    <!-- 弹窗们 -->

    <a-modal :visible="previewVisible" :footer="null" @cancel="handleModelCancel()">
      <img alt="example" style="width: 100%" :src="previewImage" />
    </a-modal>

    <a-modal
      title="实物照片"
      :width="1000"
      :visible="showShoeImagesModel"
      :footer="null"
      @cancel="handleShowShoeImagesModelCancel()"
    >
      <img
        alt="example"
        style="width: 20%; margin: 20px"
        v-for="item in orderImagesList"
        :src="item"
        @click="showShoeImage(item)"
      />
    </a-modal>

    <a-modal
      :zIndex="2000"
      :width="1000"
      :visible="showShoeImageModel"
      :footer="null"
      @cancel="handleShowShoeImageModelCancel()"
    >
      <img alt="example" style="width: 100%" :src="selectedShoeImage" />
    </a-modal>
  </j-modal>
</template>

<script>
import JImageUploadByOneForShoeOrder from '../components/JImageUploadByOneForShoeOrder'
import { getAction, httpAction } from '../../../../api/manage'
import axios from 'axios'

export default {
  name: 'ShoeRefundDetail',
  components: {
    JImageUploadByOneForShoeOrder,
  },
  data() {
    return {
      visible: false,
      title: '订单退款详情',
      data: {},
      orderImagesList: '',
      previewVisible: false,
      previewImage: '',
      logisticsInfo: {},
      showShoeImagesModel: false,
      showShoeImageModel: false,
      selectedShoeImage: '',
      refundComment: '',
      refundCreateTime: '',
      refundSuccessTime: '',
      orderExceptionInfo: {},
      showShoeExceptionInfoModel: false,
      orderExceptionImagesList: [],
      afterDeliveryInfo: {},
      statusInt: 0,
      userAddress: '',
      door: '',
      courierNameByBefore: '',
      courierPhoneByBefore: '',
      courierNameByAfter: '',
      courierPhoneByAfter: '',
      refundPrice: 0, // 退款金额
    }
  },
  created() {},
  methods: {
    // 点击了退款
    onRefund() {
      httpAction('/ShoeOrder/shoeOrder/orderRefund',
        {
          orderId:this.data.orderId,
          orderPId:this.data.orderPId,
          refundPrice:this.refundPrice*100,},'post')
        .then(res => {
        if (res.success) {
          this.$message.success('退款成功')
          this.handleCancel();
          this.$emit('ok');

        } else {
          this.$message.error(res.message)
        }
      })
    },
    show(record) {
      //处理数据
      let orderInfo = Object.assign({}, record)
      orderInfo.goodsPrice = (orderInfo.goodsPrice / 100).toFixed(2)
      orderInfo.totalPrice = (orderInfo.totalPrice / 100).toFixed(2)
      orderInfo.price = (orderInfo.price / 100).toFixed(2)
      orderInfo.couponPrice = (orderInfo.couponPrice / 100).toFixed(2)
      orderInfo.actualPrice = (orderInfo.actualPrice / 100).toFixed(2)
      orderInfo.additionalPrice = (orderInfo.additionalPrice / 100).toFixed(2)
      orderInfo.refundPrice = (orderInfo.refundPrice / 100).toFixed(2)

      orderInfo.refundStatus = this.getRefundStatus(orderInfo.refundStatus)
      //提前拿出订单状态，并转换成数字
      // this.statusInt = parseInt(orderInfo.status);
      // orderInfo.status = orderStatus;

      let type = orderInfo.type
      if (type === 'self') {
        orderInfo.type = '站点自寄'
      } else if (type === 'service') {
        orderInfo.type = '上门取件'
        //获取配送信息
        // let requestData = {
        //   "orderId": orderInfo.orderId
        // };
        // getAction("/ShoeOrder/shoeOrder/getCourierInfo", requestData).then((res) => {
        //   this.userAddress = res.result.address;
        //   this.door = res.result.door;
        //   this.courierNameByBefore = res.result.courierNameByBefore;
        //   this.courierPhoneByBefore = res.result.courierPhoneByBefore;
        //   this.courierNameByAfter = res.result.courierNameByAfter === "无" ? "——" : res.result.courierNameByAfter;
        //   this.courierPhoneByAfter = res.result.courierPhoneByAfter === "无" ? "——" : res.result.courierPhoneByAfter;
        // })
      }

      // let orderImagesString = "";
      // let orderImagesArray = JSON.parse(orderInfo.orderImages);
      // for (let i = 0 ; i < orderImagesArray.length ; i ++ ) {
      //   orderImagesString += orderImagesArray[i];
      //   if (i < orderImagesArray.length - 1) {
      //     orderImagesString += ",";
      //   }
      // }

      // this.orderImagesList = orderImagesArray;

      this.visible = true
      this.data = orderInfo

      //如果此订单是异常的状态，要查询此订单的异常情况，如果此订单要”增加服务费“，将再此查询补款记录
      // if (this.data.exceptionTime !== null && this.data.exceptionTime !== "" && this.data.exceptionTime !== undefined) {
      //   let ShoeOrderExceptionData = {
      //     "orderId": this.data.orderId
      //   }
      //   httpAction("/ShoeOrder/shoeOrder/getShoeOrderException", ShoeOrderExceptionData, "post").then((res) => {
      //     this.orderExceptionInfo = res.result;
      //     if (this.orderExceptionInfo.title === null || this.orderExceptionInfo.title === "" || this.orderExceptionInfo.title === undefined) {
      //       this.orderExceptionInfo.title = "无";
      //     }
      //     if (this.orderExceptionInfo.price === null || this.orderExceptionInfo.price === "" || this.orderExceptionInfo.price === undefined) {
      //       this.orderExceptionInfo.price = "0";
      //     } else {
      //       let price = this.orderExceptionInfo.price;
      //       this.orderExceptionInfo.price = (price / 100).toFixed(2);
      //     }
      //     if (this.orderExceptionInfo.payStatus === null || this.orderExceptionInfo.payStatus === "" || this.orderExceptionInfo.payStatus === undefined) {
      //       this.orderExceptionInfo.price = "无";
      //     }
      //
      //     //处理图片数组
      //     let imagesArray = JSON.parse(this.orderExceptionInfo.images);
      //     this.orderExceptionImagesList = imagesArray;
      //
      //   })
      // } else {
      //   this.orderExceptionInfo = {
      //     "createTime": "",
      //     "dealNote": "",
      //     "dealTime": "",
      //     "dealType": "",
      //     "dealUserId": "",
      //     "dealUsername": "",
      //     "images": "",
      //     "note": "",
      //     "orderExceptionId": "",
      //     "orderId": "",
      //     "payStatus": "",
      //     "payTime": "",
      //     "price": "",
      //     "reportUserId": "",
      //     "reportUsername": "",
      //     "status": "",
      //     "title": "",
      //   }
      // }

      //如果此订单是退款中或已退款的状态，再查询其退款原因
      // if ('退款中' === this.data.status || '已退款' === this.data.status) {
      //   let data = {
      //     "orderPId": this.data.orderPId,
      //     "orderIds": this.data.orderId
      //   }
      //   httpAction("/ShoeOrder/shoeOrder/getShoePayRefundInfo", data, "post").then((res) => {
      //     this.refundComment = res.result.note;
      //     this.refundCreateTime = res.result.createTime;
      //     this.refundSuccessTime = res.result.successTime;
      //   })
      // } else {
      //   this.refundComment = "";
      //   this.refundCreateTime = "";
      //   this.refundSuccessTime = "";
      // }
    },
    handleCancel() {
      this.visible = false
      this.orderImagesList = []
      this.data = {}
      this.afterDeliveryInfo = {}
      this.logisticsInfo = {}
      this.orderExceptionInfo = {}
      this.refundComment = ''
      this.refundCreateTime = ''
      this.refundSuccessTime = ''
      this.userAddress = ''
      this.courierNameByBefore = ''
      this.courierPhoneByBefore = ''
      this.courierNameByAfter = ''
      this.courierPhoneByAfter = ''
      this.refundPrice = 0
    },
    previewModel() {
      this.previewVisible = true
      this.previewImage = this.data.image
    },
    handleModelCancel() {
      this.previewVisible = false
      this.previewImage = ''
    },
    showShoeImages() {
      this.showShoeImagesModel = true
    },
    handleShowShoeImagesModelCancel() {
      this.showShoeImagesModel = false
    },
    showShoeImage(item) {
      this.showShoeImageModel = true
      this.selectedShoeImage = item
    },
    handleShowShoeImageModelCancel() {
      this.showShoeImageModel = false
      this.selectedShoeImage = ''
    },
    showShoeExceptionInfo() {
      this.showShoeExceptionInfoModel = true
    },
    handleShoeExceptionInfoCancel() {
      this.showShoeExceptionInfoModel = false
    },
    getRefundStatus(refundStatus) {
      if (refundStatus === '0') {
        return '退款中'
      } else if (refundStatus === '1') {
        return '退款成功'
      } else if (refundStatus === '2') {
        return '退款失败'
      }
    },
  },
}
</script>

<style scoped lang="less">
.main {
  flex: 1;
}
.foot {
  width: 100%;
  display: flex;
  justify-content: space-around;
}
.full-modal {
  .ant-modal {
    max-width: 100%;
    top: 0;
    padding-bottom: 0;
    margin: 0;
  }
  .ant-modal-content {
    display: flex;
    flex-direction: column;
    height: calc(100vh);
  }
  .ant-modal-body {
    flex: 1;
  }
}

.shoe-order-detail-title {
  color: #f77810;
  font-size: 26px;
}
.shoe-order-exception-detail-title {
  color: #f77810;
  font-size: 18px;
}
.content-font-above {
  color: #000000;
  font-size: 18px;
  margin-top: 20px;
  margin-bottom: 20px;
}
.content-font-below {
  color: #000000;
  font-size: 18px;
  margin-top: 6px;
  margin-bottom: 6px;
  display: flex;
}
.diyDiv {
  width: 100%;
  height: 430px;
  overflow-y: scroll;
  display: flex;
  flex-direction: column;
}
</style>