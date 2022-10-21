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
<!--                    <j-image-upload-by-one-for-shoe-order v-model="orderImagesList"></j-image-upload-by-one-for-shoe-order>-->
<!--                    <img v-for="item in orderImagesList" alt="example" style="width: 20%;height: 20%;margin: 10px" :src="item" @click="previewModel(item)"/>-->
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
              <!-- 商品金额 -->
              <a-row>
                <a-col :span="24">
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
          <a-row v-if="'待付款' === this.data.status || '已取消' === this.data.status || '已完成' === this.data.status">
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
          <a-row>
            <a-col :span="24">
              <div class="content-font-below">优惠抵扣金额：{{data.couponPrice}}</div>
            </a-col>
          </a-row>
          <a-row>
            <a-col :span="24">
              <div class="content-font-below">备注：{{data.note}}</div>
            </a-col>
          </a-row>
          <a-row>
            <a-col :span="24">
              <div class="content-font-below">订单状态：{{data.status}}</div>
            </a-col>
          </a-row>
          <a-row v-if="'洗护中' === this.data.status">
            <a-col :span="24">
              <div class="content-font-below">下单时间：{{data.payTime}}</div>
            </a-col>
          </a-row>
          <a-row v-if="'洗护中' === this.data.status">
            <a-col :span="24">
              <div class="content-font-below">机柜编码-格子数：{{data.beforeLockerId}}-{{data.beforeGridNo}}</div>
            </a-col>
          </a-row>
          <a-row v-if="'待取件' === this.data.status">
            <a-col :span="24">
              <div class="content-font-below">机柜编码-格子数：{{data.afterLockerId}}-{{data.afterGridNo}}</div>
            </a-col>
          </a-row>
<!--          <a-row v-if="'已取消' === this.data.status">-->
<!--            <a-col :span="24">-->
<!--              <div class="content-font-below">取消原因：</div>-->
<!--            </a-col>-->
<!--          </a-row>-->
          <a-row v-if="'已取消' === this.data.status">
            <a-col :span="24">
              <div class="content-font-below">取消时间：{{data.cancelTime}}</div>
            </a-col>
          </a-row>
<!--          <a-row v-if="'退款中' === this.data.status || '已退款' === this.data.status">-->
<!--            <a-col :span="24">-->
<!--              <div class="content-font-below">退款原因：{{refundComment}}</div>-->
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
              <div class="content-font-below">用户姓名：{{data.name}}</div>
            </a-col>
          </a-row>
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
        <!-- 物流信息 -->
        <a-col :span="1"></a-col>
        <a-col :span="7">
          <a-row>
            <a-col :span="24">
              <p class="shoe-order-detail-title" style="margin-top: 20px">物流信息</p>
            </a-col>
            <a-col :span="24" v-if="'待付款' !== this.data.status && '已取消' !== this.data.status">
              <a-timeline :reverse="true">
                <!-- 已下单 -->
                <a-timeline-item>
                  <a-row>
                    <a-col :span="24"><span><b>已下单</b></span><span style="font-size: 10px;color: #989898;margin-left: 10px">{{logisticsInfo.payTime}}</span></a-col>
                  </a-row>
                  <a-row>
                    <a-col :span="24" style="font-size: 8px">商品已下单<a @click="showShoeImages" style="margin-left: 10px">查看鞋子照片</a></a-col>
                  </a-row>
                </a-timeline-item>
                <!-- 已接单 -->
                <a-timeline-item v-if="logisticsInfo.receiveTime !== '' && logisticsInfo.receiveTime !== null && logisticsInfo.receiveTime !== undefined">
                  <a-row>
                    <a-col :span="24"><span><b>已接单</b></span><span style="font-size: 10px;color: #989898;margin-left: 10px">{{logisticsInfo.receiveTime}}</span></a-col>
                  </a-row>
                  <a-row>
                    <a-col :span="24" style="font-size: 8px">配送员已接单</a-col>
                  </a-row>
                </a-timeline-item>
                <!-- 已收件 -->
                <a-timeline-item v-if="logisticsInfo.takeTime !== '' && logisticsInfo.takeTime !== null && logisticsInfo.takeTime !== undefined">
                  <a-row>
                    <a-col :span="24"><span><b>已收件</b></span><span style="font-size: 10px;color: #989898;margin-left: 10px">{{logisticsInfo.takeTime}}</span></a-col>
                  </a-row>
                  <a-row>
                    <a-col :span="24" style="font-size: 8px">配送员已收件</a-col>
                  </a-row>
                </a-timeline-item>
                <!-- 正在退款 -->
                <a-timeline-item v-if="refundCreateTime !== '' && refundCreateTime !== null && refundCreateTime !== undefined">
                  <a-row>
                    <a-col :span="24"><span><b>正在退款</b></span><span style="font-size: 10px;color: #989898;margin-left: 10px">{{refundCreateTime}}</span></a-col>
                  </a-row>
                  <a-row>
                    <a-col :span="24" style="font-size: 8px">订单已发起退款</a-col>
                  </a-row>
                </a-timeline-item>
                <!-- 已退款 -->
                <a-timeline-item v-if="refundSuccessTime !== '' && refundSuccessTime !== null && refundSuccessTime !== undefined">
                  <a-row>
                    <a-col :span="24"><span><b>已退款</b></span><span style="font-size: 10px;color: #989898;margin-left: 10px">{{refundSuccessTime}}</span></a-col>
                  </a-row>
                  <a-row>
                    <a-col :span="24" style="font-size: 8px">订单已退款</a-col>
                  </a-row>
                </a-timeline-item>
                <!-- 已入柜 -->
                <a-timeline-item v-if="logisticsInfo.inTime !== '' && logisticsInfo.inTime !== null && logisticsInfo.inTime !== undefined">
                  <a-row>
                    <a-col :span="24"><span><b>已入柜</b></span><span style="font-size: 10px;color: #989898;margin-left: 10px">{{logisticsInfo.inTime}}</span></a-col>
                  </a-row>
                  <a-row>
                    <a-col :span="24" style="font-size: 8px">鞋子已放入快递柜中，等待物流人员取件</a-col>
                  </a-row>
                </a-timeline-item>
                <!-- 送工厂 -->
                <a-timeline-item v-if="logisticsInfo.logisticsOutTime !== '' && logisticsInfo.logisticsOutTime !== null && logisticsInfo.logisticsOutTime !== undefined">
                  <a-row>
                    <a-col :span="24"><span><b>送工厂</b></span><span style="font-size: 10px;color: #989898;margin-left: 10px">{{logisticsInfo.logisticsOutTime}}</span></a-col>
                  </a-row>
                  <a-row>
                    <a-col :span="24" style="font-size: 8px">物流人员已取出鞋子，送往工厂</a-col>
                  </a-row>
                </a-timeline-item>
                <!-- 洗护中 -->
                <a-timeline-item v-if="logisticsInfo.factoryInTime !== '' && logisticsInfo.factoryInTime !== null && logisticsInfo.factoryInTime !== undefined">
                  <a-row>
                    <a-col :span="24"><span><b>洗护中</b></span><span style="font-size: 10px;color: #989898;margin-left: 10px">{{logisticsInfo.factoryInTime}}</span></a-col>
                  </a-row>
                  <a-row>
                    <a-col :span="24" style="font-size: 8px">工厂已入库，鞋子洗护中</a-col>
                  </a-row>
                </a-timeline-item>
                <!-- 异常 -->
                <a-timeline-item v-if="logisticsInfo.exceptionTime !== '' && logisticsInfo.exceptionTime !== null && logisticsInfo.exceptionTime !== undefined">
                  <a-row>
                    <a-col :span="24"><span><b>异常</b></span><span style="font-size: 10px;color: #989898;margin-left: 10px">{{logisticsInfo.exceptionTime}}</span></a-col>
                  </a-row>
                  <a-row>
                    <a-col :span="24" style="font-size: 8px">鞋子需要其他服务，请查看<a @click="showShoeExceptionInfo" style="margin-left: 10px">查看原因</a></a-col>
                  </a-row>
                </a-timeline-item>
                <!-- 异常单在追加服务费之后，再次进入正常的洗护流程 -->
                <a-timeline-item v-if="logisticsInfo.exceptionTime !== '' && logisticsInfo.exceptionTime !== null && logisticsInfo.exceptionTime !== undefined && orderExceptionInfo.dealType === 1 && orderExceptionInfo.payTime !== null">
                  <a-row>
                    <a-col :span="24"><span><b>洗护中</b></span><span style="font-size: 10px;color: #989898;margin-left: 10px">{{orderExceptionInfo.payTime}}</span></a-col>
                  </a-row>
                  <a-row>
                    <a-col :span="24" style="font-size: 8px">工厂已入库，鞋子洗护中</a-col>
                  </a-row>
                </a-timeline-item>
                <!-- 异常单在选择退回之后，进入已退回流程 -->
                <a-timeline-item v-if="logisticsInfo.exceptionTime !== '' && logisticsInfo.exceptionTime !== null && logisticsInfo.exceptionTime !== undefined && orderExceptionInfo.dealType === 2 && orderExceptionInfo.dealTime !== null">
                  <a-row>
                    <a-col :span="24"><span><b>已退回</b></span><span style="font-size: 10px;color: #989898;margin-left: 10px">{{orderExceptionInfo.dealTime}}</span></a-col>
                  </a-row>
                  <a-row>
                    <a-col :span="24" style="font-size: 8px">鞋子已退回，等待出库</a-col>
                  </a-row>
                </a-timeline-item>
                <!-- 送站点 -->
                <a-timeline-item v-if="logisticsInfo.factoryOutTime !== '' && logisticsInfo.factoryOutTime !== null && logisticsInfo.factoryOutTime !== undefined">
                  <a-row>
                    <a-col :span="24"><span><b>送站点</b></span><span style="font-size: 10px;color: #989898;margin-left: 10px">{{logisticsInfo.factoryOutTime}}</span></a-col>
                  </a-row>
                  <a-row>
                    <a-col :span="24" style="font-size: 8px">鞋子已出库，物流人员送往站点中</a-col>
                  </a-row>
                </a-timeline-item>
                <!-- 待取件 -->
                <a-timeline-item v-if="logisticsInfo.logisticsInTime !== '' && logisticsInfo.logisticsInTime !== null && logisticsInfo.logisticsInTime !== undefined">
                  <a-row>
                    <a-col :span="24"><span><b>待取件</b></span><span style="font-size: 10px;color: #989898;margin-left: 10px">{{logisticsInfo.logisticsInTime}}</span></a-col>
                  </a-row>
                  <a-row>
                    <a-col :span="24" style="font-size: 8px">鞋子已暂存至快递柜，请及时领取</a-col>
                  </a-row>
                </a-timeline-item>
                <!-- 已接单，配送员送件上门，需要查询另外的表来判断是否有该步骤 -->
                <a-timeline-item v-if="afterDeliveryInfo.createTime !== '' && afterDeliveryInfo.createTime !== null && afterDeliveryInfo.createTime !== undefined">
                  <a-row>
                    <a-col :span="24"><span><b>已接单</b></span><span style="font-size: 10px;color: #989898;margin-left: 10px">{{afterDeliveryInfo.createTime}}</span></a-col>
                  </a-row>
                  <a-row>
                    <a-col :span="24" style="font-size: 8px">配送员已接单</a-col>
                  </a-row>
                </a-timeline-item>
                <!-- 已取出 -->
                <a-timeline-item v-if="logisticsInfo.outTime !== '' && logisticsInfo.outTime !== null && logisticsInfo.outTime !== undefined">
                  <a-row>
                    <a-col :span="24"><span><b>已取出</b></span><span style="font-size: 10px;color: #989898;margin-left: 10px">{{logisticsInfo.outTime}}</span></a-col>
                  </a-row>
                  <a-row>
                    <a-col :span="24" style="font-size: 8px">鞋子已从快递柜取出</a-col>
                  </a-row>
                </a-timeline-item>
                <!-- 已完成 -->
                <a-timeline-item v-if="logisticsInfo.finishTime !== '' && logisticsInfo.finishTime !== null && logisticsInfo.finishTime !== undefined">
                  <a-row>
                    <a-col :span="24"><span><b>已完成</b></span><span style="font-size: 10px;color: #989898;margin-left: 10px">{{logisticsInfo.finishTime}}</span></a-col>
                  </a-row>
                  <a-row>
                    <a-col :span="24" style="font-size: 8px">订单已完成</a-col>
                  </a-row>
                </a-timeline-item>
              </a-timeline>
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

    <a-modal title="异常信息" :width="800" :visible="showShoeExceptionInfoModel" :footer="null" @cancel="handleShoeExceptionInfoCancel">
      <!-- 异常照片展示 -->
      <div style="width: 100%;height: 400px;overflow-y: scroll">
        <!-- 异常图片展示区 -->
        <a-row>
          <a-col :span="24">
            <p class="shoe-order-exception-detail-title">异常照片</p>
          </a-col>
          <a-col :span="24">
            <img alt="example" style="width: 20%;margin: 20px" v-for="item in orderExceptionImagesList" :src="item" @click="showShoeImage(item)">
          </a-col>
        </a-row>

        <!-- 异常信息展示区 -->
        <a-row>
          <a-col :span="24">
            <p class="shoe-order-exception-detail-title">异常备注</p>
          </a-col>
          <a-col :span="24">
            <p style="font-size: 16px;color: #000000"><b>{{orderExceptionInfo.note}}</b></p>
          </a-col>
        </a-row>
      </div>
    </a-modal>

  </j-modal>
</template>

<script>
import {filterDictTextByCache} from "../../../../components/dict/JDictSelectUtil";
import JImageUploadByOneForShoeOrder from "../components/JImageUploadByOneForShoeOrder";
import {httpAction} from "../../../../api/manage";

export default{
  name: "ShoeOrderDetail",
  components: {
    JImageUploadByOneForShoeOrder
  },
  data(){
    return {
      visible: false,
      title: '订单详情',
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
      let status = orderInfo.status;
      if (status === '0') {
        orderInfo.status = "待付款";
      } else if (status === '1') {
        orderInfo.status = "洗护中";
      } else if (status === '2') {
        orderInfo.status = "待取件";
      } else if (status === '3') {
        orderInfo.status = "已完成";
      } else if (status === '4') {
        orderInfo.status = "已取消";
      } else if (status === '5') {
        orderInfo.status = "退款中";
      } else if (status === '6') {
        orderInfo.status = "已退款";
      } else if (status === '7') {
        orderInfo.status = "异常";
      } else if (status === '8') {
        orderInfo.status = "退回中";
      }

      let type = orderInfo.type;
      if (type === "self") {
        orderInfo.type = "站点自寄";
      } else if (type === "service") {
        orderInfo.type = "上门取件";
      }

      let orderImagesString = "";
      let orderImagesArray = JSON.parse(orderInfo.orderImages);
      for (let i = 0 ; i < orderImagesArray.length ; i ++ ) {
        orderImagesString += orderImagesArray[i];
        if (i < orderImagesArray.length - 1) {
          orderImagesString += ",";
        }
      }

      this.orderImagesList = orderImagesArray;

      this.visible = true;
      this.data = orderInfo;

      //查询物流状态
      let data = {
        "orderId": this.data.orderId
      }
      httpAction("/ShoeOrder/shoeOrder/getShoeOrderLogisticsInfo", data, "post").then((res) => {
        let result = res.result;
        let resultData = {};
        if (result === null || result === "" || result === undefined) {
          resultData = {
            "payTime": "",
            "receiveTime": "",
            "takeTime": "",
            "inTime": "",
            "logisticsOutTime": "",
            "factoryInTime": "",
            "exceptionTime": "",
            "factoryOutTime": "",
            "logisticsInTime": "",
            "outTime": "",
            "finishTime": ""
          }
        } else {
          resultData = result;
        }
        this.logisticsInfo = resultData;

        //如果此订单是异常的状态，要查询此订单的异常情况，如果此订单要”增加服务费“，将再此查询补款记录
        if (this.logisticsInfo.exceptionTime !== null && this.logisticsInfo.exceptionTime !== "" && this.logisticsInfo.exceptionTime !== undefined) {
          let ShoeOrderExceptionData = {
            "orderId": this.data.orderId
          }
          httpAction("/ShoeOrder/shoeOrder/getShoeOrderException", ShoeOrderExceptionData, "post").then((res) => {
            this.orderExceptionInfo = res.result;
            if (this.orderExceptionInfo.title === null || this.orderExceptionInfo.title === "" || this.orderExceptionInfo.title === undefined) {
              this.orderExceptionInfo.title = "无";
            }
            if (this.orderExceptionInfo.price === null || this.orderExceptionInfo.price === "" || this.orderExceptionInfo.price === undefined) {
              this.orderExceptionInfo.price = "0";
            } else {
              let price = this.orderExceptionInfo.price;
              this.orderExceptionInfo.price = (price / 100).toFixed(2);
            }
            if (this.orderExceptionInfo.payStatus === null || this.orderExceptionInfo.payStatus === "" || this.orderExceptionInfo.payStatus === undefined) {
              this.orderExceptionInfo.price = "无";
            }

            //处理图片数组
            let imagesArray = JSON.parse(this.orderExceptionInfo.images);
            this.orderExceptionImagesList = imagesArray;

          })
        } else {
          this.orderExceptionInfo = {
            "createTime": "",
            "dealNote": "",
            "dealTime": "",
            "dealType": "",
            "dealUserId": "",
            "dealUsername": "",
            "images": "",
            "note": "",
            "orderExceptionId": "",
            "orderId": "",
            "payStatus": "",
            "payTime": "",
            "price": "",
            "reportUserId": "",
            "reportUsername": "",
            "status": "",
            "title": "",
          }
        }
      })

      //如果此订单是退款中或已退款的状态，再查询其退款原因
      if ('退款中' === this.data.status || '已退款' === this.data.status) {
        let data = {
          "orderPId": this.data.orderPId,
          "orderIds": this.data.orderId
        }
        httpAction("/ShoeOrder/shoeOrder/getShoePayRefundInfo", data, "post").then((res) => {
          this.refundComment = res.result.note;
          this.refundCreateTime = res.result.createTime;
          this.refundSuccessTime = res.result.successTime;
        })
      } else {
        this.refundComment = "";
        this.refundCreateTime = "";
        this.refundSuccessTime = "";
      }

      //在物流人员把鞋子放进格子后，查询配送员的接单时间
      if (("待取件" === this.data.status || "已完成" === this.data.status) && "上门取件" === this.data.type) {
        let data = {
          "orderPId": this.data.orderPId,
          "orderId": this.data.orderId
        }
        httpAction("/ShoeOrder/shoeOrder/getShoeCourierOrderDetail", data, "post").then((res) => {
          this.afterDeliveryInfo = res.result;
        })
      }

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
      this.afterDeliveryInfo = {};
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