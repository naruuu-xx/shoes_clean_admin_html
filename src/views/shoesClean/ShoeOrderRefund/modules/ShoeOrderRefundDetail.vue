<template>
  <j-modal
    :title="title"
    :width="1200"
    :visible="visible"
    switchFullscreen
    @cancel="handleCancel"
    cancelText="关闭"
    :footer="null"
    wrapClassName="full-modal">
    <div class="diyDiv">
      <!-- 上面一大块 -->
      <a-row style="border-bottom: 1px solid #dedede">
        <!-- 标题 -->
        <div style="margin-bottom: 20px">
          <a-row>
            <a-col :span="24">
              <p class="shoe-order-detail-title" style="margin-left: 44px">商品信息</p>
            </a-col>
          </a-row>

          <!-- 商品信息部分 -->
          <a-row>
            <!-- 左边部分 -->
            <a-col :span="1"></a-col>
            <a-col :span="11">
              <!-- 商品名 -->
              <a-row>
                <a-col :span="24">
                  <div class="content-font-above">商品名：{{data.title}}</div>
                </a-col>
              </a-row>
              <!-- 商品图片 -->
              <a-row>
                <a-col :span="24">
                  <div class="content-font-above">商品图片：
                    <img alt="example" style="width: 20%;height: 20%;margin: 10px" :src="data.image" @click="previewModel()"/>
                  </div>
                </a-col>
              </a-row>
            </a-col>

            <!-- 右边部分 -->
            <a-col :span="12">
              <!-- 商品规格 -->
              <a-row>
                <a-col :span="24">
                  <div class="content-font-above">商品规格：{{data.skuTitle}}</div>
                </a-col>
              </a-row>
<!--          附加服务    -->
              <a-row>
                <a-col :span="24" v-if="data.additionalName != ''  ">
                  <div class="content-font-above">附加服务：{{data.additionalName}}</div>
                </a-col>
                <a-col :span="24" v-if="data.additionalName == ''  ">
                  <div class="content-font-above">附加服务：无</div>
                </a-col>

              </a-row>
              <!-- 商品金额 -->
              <a-row>
                <a-col :span="24" >
                  <div class="content-font-above">商品金额（元）：{{data.goodsPrice}}</div>
                </a-col>
              </a-row>
              <!-- 购买数量 -->
              <a-row>
                <a-col :span="24">
                  <div class="content-font-above">购买数量：1</div>
                </a-col>
              </a-row>
            </a-col>
          </a-row>
        </div>
      </a-row >
      <!-- 下面一大块 -->
      <a-row>
        <!-- 订单信息 -->
        <a-col :span="1"></a-col>
<!--        <a-col :span="7" style="border-right: 1px solid #dedede">-->
        <a-col :span="7">
          <a-row>
            <a-col :span="24">
              <p class="shoe-order-detail-title" style="margin-top: 20px">订单信息</p>
            </a-col>
          </a-row>
          <a-row>
            <a-col :span="24">
              <div class="content-font-below">订单编号：{{data.no}}</div>
            </a-col>
          </a-row>
          <a-row>
            <a-col :span="24">
              <div class="content-font-below">订单金额（元）：{{data.totalPrice}}</div>
            </a-col>
          </a-row>
<!--          <a-row v-if="'待付款' === this.data.status || '已取消' === this.data.status || '已完成' === this.data.status">-->
          <a-row>
            <a-col :span="24">
              <div class="content-font-below">附加金额（元）：{{data.additionalPrice}}</div>
            </a-col>
          </a-row>
          <a-row>
            <a-col :span="24">
              <div class="content-font-below">应付金额（元）：{{data.price}}</div>
            </a-col>
          </a-row>
          <a-row v-if="logisticsInfo.exceptionTime !== null && logisticsInfo.exceptionTime !== '' && logisticsInfo.exceptionTime !== undefined">
            <a-col :span="24">
              <div class="content-font-below">追加金额（元）：{{orderExceptionInfo.price}}</div>
            </a-col>
          </a-row>
          <a-row>
            <a-col :span="24">
              <div class="content-font-below">实付金额（元）：{{data.actualPrice}}</div>
            </a-col>
          </a-row>
<!--          <a-row>-->
<!--            <a-col :span="24">-->
<!--              <div class="content-font-below">优惠抵扣金额：{{data.couponPrice}}</div>-->
<!--            </a-col>-->
<!--          </a-row>-->
          <a-row>
            <a-col :span="24">
              <div class="content-font-below">优惠卷：{{data.coupon}}</div>
            </a-col>
          </a-row>
          <a-row>
            <a-col :span="24">
              <div class="content-font-below">备注：{{data.note}}</div>
            </a-col>
          </a-row>
          <a-row>
            <a-col :span="24">
              <div class="content-font-below">订单状态：{{data.refundStatus}}</div>
            </a-col>
          </a-row>
          <a-row v-if="statusInt > 0">
            <a-col :span="24">
              <div class="content-font-below">下单时间：{{data.orderTime}}</div>
            </a-col>
          </a-row>
<!--          <a-row v-if="statusInt > 0 && statusInt < 5">-->
<!--            <a-col :span="24">-->
<!--              <div class="content-font-below">机柜名称-格子数：{{data.lockerName}}-{{data.beforeGridNo}}</div>-->
<!--            </a-col>-->
<!--          </a-row>-->
<!--          <a-row v-if="statusInt >= 9 && statusInt <= 13 &&  '上门取件' === data.type">-->
<!--            <a-col :span="24">-->
<!--              <div class="content-font-below">机柜名称-格子数：{{data.lockerName}}-{{data.afterGridNo}}</div>-->
<!--            </a-col>-->
<!--          </a-row>-->
<!--          <a-row v-if="statusInt >= 9 && statusInt <= 13 &&  '站点自寄' === data.type">-->
<!--            <a-col :span="24">-->
<!--              <div class="content-font-below">机柜名称-格子数：{{data.lockerName}}-{{data.afterGridNo}}</div>-->
<!--            </a-col>-->
<!--          </a-row>-->
<!--          <a-row v-if="'已取消' === this.data.status">-->
<!--            <a-col :span="24">-->
<!--              <div class="content-font-below">取消原因：</div>-->
<!--            </a-col>-->
<!--          </a-row>-->
<!--          <a-row v-if="'已取消' === this.data.status">-->
<!--            <a-col :span="24">-->
<!--              <div class="content-font-below">取消时间：{{data.cancelTime}}</div>-->
<!--            </a-col>-->
<!--          </a-row>-->
<!--          <a-row v-if="'退款中' === this.data.status || '已退款' === this.data.status">-->
<!--            <a-col :span="24">-->
<!--              <div class="content-font-below">退款原因：{{refundComment}}</div>-->
<!--            </a-col>-->
<!--          </a-row>-->
<!--          <a-row v-if="'上门取件' === data.type">-->
<!--            <a-col :span="24">-->
<!--              <div class="content-font-below">配送员（取鞋）：{{courierNameByBefore}}</div>-->
<!--            </a-col>-->
<!--          </a-row>-->
<!--          <a-row v-if="'上门取件' === data.type">-->
<!--            <a-col :span="24">-->
<!--              <div class="content-font-below">配送员电话：{{courierPhoneByBefore}}</div>-->
<!--            </a-col>-->
<!--          </a-row>-->
<!--          <a-row v-if="'上门取件' === data.type">-->
<!--            <a-col :span="24">-->
<!--              <div class="content-font-below">配送员（送鞋）：{{courierNameByAfter}}</div>-->
<!--            </a-col>-->
<!--          </a-row>-->
<!--          <a-row v-if="'上门取件' === data.type">-->
<!--            <a-col :span="24">-->
<!--              <div class="content-font-below">配送员电话：{{courierPhoneByAfter}}</div>-->
<!--            </a-col>-->
<!--          </a-row>-->
<!--          <a-row v-if="statusInt >= 10">-->
<!--            <a-col :span="24">-->
<!--              <div class="content-font-below">取件码：{{data.code}}</div>-->
<!--            </a-col>-->
<!--          </a-row>-->
        </a-col>
        <!-- 用户信息 -->
        <a-col :span="1"></a-col>
<!--        <a-col :span="7" style="border-right: 1px solid #dedede">-->
        <a-col :span="7">
          <a-row>
            <a-col :span="24">
              <p class="shoe-order-detail-title" style="margin-top: 20px">用户信息</p>
            </a-col>
          </a-row>
          <a-row>
            <a-col :span="24">
              <div class="content-font-below">用户姓名：{{data.nickname}}</div>
            </a-col>
          </a-row>
<!--          <a-row v-if="this.data.type === '上门取件'">-->
<!--            <a-col :span="24">-->
<!--              <div class="content-font-below">用户地址：{{userAddress}}</div>-->
<!--            </a-col>-->
<!--          </a-row>-->
<!--          <a-row v-if="this.data.type === '上门取件'">-->
<!--            <a-col :span="24">-->
<!--              <div class="content-font-below">门牌号：{{door}}</div>-->
<!--            </a-col>-->
<!--          </a-row>-->
<!--          <a-row v-if="this.data.type === '上门取件'">-->
<!--            <a-col :span="24">-->
<!--              <div class="content-font-below">预定时间：{{data.expect}}</div>-->
<!--            </a-col>-->
<!--          </a-row>-->
          <a-row>
            <a-col :span="24">
              <div class="content-font-below">手机号码：{{data.phone}}</div>
            </a-col>
          </a-row>
          <a-row>
            <a-col :span="24">
              <div class="content-font-below">存柜方式：{{data.type}}</div>
            </a-col>
          </a-row>
          <a-row>
            <a-col :span="24">
              <div class="content-font-below">取鞋方式：{{data.type === "站点自寄" ? "站点自提" : "送件上门"}}</div>
            </a-col>
          </a-row>
        </a-col>
        <!-- 退款信息 -->
        <a-col :span="1"></a-col>
        <a-col :span="7">
          <a-row>
            <a-col :span="24">
              <p class="shoe-order-detail-title" style="margin-top: 20px">退款信息</p>
            </a-col>
          </a-row>
          <a-row>
            <a-col :span="24">
              <div class="content-font-below">退款原因：{{data.reason}}</div>
            </a-col>
          </a-row>
          <a-row>
            <a-col :span="24">
              <div class="content-font-below">退款说明：{{data.description}}</div>
            </a-col>
          </a-row>
          <a-row>
            <a-col :span="24">
              <div class="content-font-below">退款金额：{{data.refundPrice}}</div>
            </a-col>
          </a-row>
          <a-row>
            <a-col :span="24">
              <div class="content-font-below">申请时间：{{data.refundTime}}</div>
            </a-col>
          </a-row>

        </a-col>
      </a-row>
    </div>

    <!-- 弹窗们 -->

    <a-modal :visible="previewVisible" :footer="null" @cancel="handleModelCancel()">
      <img alt="example" style="width: 100%" :src="previewImage"/>
    </a-modal>

    <a-modal title="实物照片" :width="1000" :visible="showShoeImagesModel" :footer="null" @cancel="handleShowShoeImagesModelCancel()">
      <img alt="example" style="width: 20%;margin: 20px" v-for="item in orderImagesList" :src="item" @click="showShoeImage(item)">
    </a-modal>

    <a-modal :zIndex="2000" :width="1000" :visible="showShoeImageModel" :footer="null" @cancel="handleShowShoeImageModelCancel()">
      <img alt="example" style="width: 100%" :src="selectedShoeImage">
    </a-modal>


  </j-modal>
</template>

<script>
import JImageUploadByOneForShoeOrder from "../../ShoeOrder/components/JImageUploadByOneForShoeOrder";
import {getAction, httpAction} from "../../../../api/manage";

export default{
  name: "ShoeOrderRefundDetail",
  components: {
    JImageUploadByOneForShoeOrder
  },
  data(){
    return {
      visible: false,
      title: '订单退款详情',
      data: {},
      orderImagesList: "",
      previewVisible: false,
      previewImage: "",
      logisticsInfo: {},
      showShoeImagesModel: false,
      showShoeImageModel: false,
      selectedShoeImage: "",
      refundComment: "",
      refundCreateTime: "",
      refundSuccessTime: "",
      orderExceptionInfo: {},
      showShoeExceptionInfoModel: false,
      orderExceptionImagesList: [],
      afterDeliveryInfo: {},
      statusInt: 0,
      userAddress: "",
      door: "",
      courierNameByBefore: "",
      courierPhoneByBefore: "",
      courierNameByAfter: "",
      courierPhoneByAfter: "",
    }
  },
  created() {
  },
  methods: {
    show(record){
      //处理数据
      // let orderInfo = record;
      let orderInfo = Object.assign({}, record);
      orderInfo.goodsPrice = (orderInfo.goodsPrice / 100).toFixed(2);
      orderInfo.totalPrice = (orderInfo.totalPrice / 100).toFixed(2);
      orderInfo.price = (orderInfo.price / 100).toFixed(2);
      orderInfo.couponPrice = (orderInfo.couponPrice / 100).toFixed(2);
      orderInfo.actualPrice = (orderInfo.actualPrice / 100).toFixed(2);
      orderInfo.additionalPrice = (orderInfo.additionalPrice / 100).toFixed(2);
      orderInfo.refundPrice = (orderInfo.refundPrice / 100).toFixed(2);

      orderInfo.refundStatus = this.getRefundStatus(orderInfo.refundStatus);
      //提前拿出订单状态，并转换成数字
      // this.statusInt = parseInt(orderInfo.status);
      // orderInfo.status = orderStatus;

      let type = orderInfo.type;
      if (type === "self") {
        orderInfo.type = "站点自寄";
      } else if (type === "service") {
        orderInfo.type = "上门取件";
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

      this.visible = true;
      this.data = orderInfo;

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
      this.visible = false;
      this.orderImagesList = [];
      this.data = {};
      this.afterDeliveryInfo = {};
      this.logisticsInfo = {};
      this.orderExceptionInfo = {};
      this.refundComment = "";
      this.refundCreateTime = "";
      this.refundSuccessTime = "";
      this.userAddress = "";
      this.courierNameByBefore = "";
      this.courierPhoneByBefore = "";
      this.courierNameByAfter = "";
      this.courierPhoneByAfter = "";
    },
    previewModel(){
      this.previewVisible = true;
      this.previewImage = this.data.image;
    },
    handleModelCancel(){
      this.previewVisible = false;
      this.previewImage = "";
    },
    showShoeImages(){
      this.showShoeImagesModel = true;
    },
    handleShowShoeImagesModelCancel(){
      this.showShoeImagesModel = false;
    },
    showShoeImage(item){
      this.showShoeImageModel = true;
      this.selectedShoeImage = item;
    },
    handleShowShoeImageModelCancel(){
      this.showShoeImageModel = false;
      this.selectedShoeImage = "";
    },
    showShoeExceptionInfo(){
      this.showShoeExceptionInfoModel = true;
    },
    handleShoeExceptionInfoCancel(){
      this.showShoeExceptionInfoModel = false;
    },
    getRefundStatus(refundStatus) {
      if(refundStatus === '0'){
        return '退款中';
      }
      else if(refundStatus === '1'){
        return '退款成功';
      }
      else if(refundStatus === '2'){
        return '退款失败';
      }
    }
  }
}
</script>

<style scoped lang="less">
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
.content-font-above{
  color: #000000;
  font-size: 18px;
  margin-top: 20px;
  margin-bottom: 20px;
}
.content-font-below{
  color: #000000;
  font-size: 18px;
  margin-top: 6px;
  margin-bottom: 6px;
}
.diyDiv{
  width: 100%;
  height: 680px;
  overflow-y: scroll;
}
</style>