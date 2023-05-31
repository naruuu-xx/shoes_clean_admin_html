<template>
  <j-modal
    :title="title"
    :width="1200"
    :visible="visible"
    switchFullscreen
    @cancel="handleCancel"
    cancelText="关闭"
    :footer="null"
    wrapClassName="full-modal"
  >
    <div class="diyDiv">
      <a-descriptions title="商品信息" layout="vertical" bordered :column="5" size="small" style="margin-bottom: 20px">
        <a-descriptions-item label="商品">
          <img alt="example" style="width: 120px" :src="data.image" @click="previewModel" />
          {{ data.title }}
        </a-descriptions-item>
        <a-descriptions-item label="规格">
          {{ data.skuTitle }}
        </a-descriptions-item>
        <a-descriptions-item label="附加服务">{{ data.additionalName || '无' }}</a-descriptions-item>
        <a-descriptions-item label="数量"> 1 </a-descriptions-item>
        <a-descriptions-item label="商品金额(元)">{{ data.goodsPrice }}</a-descriptions-item>
      </a-descriptions>

      <a-descriptions title="订单信息" layout="vertical" bordered :column="6" size="small" style="margin-bottom: 20px">
        <a-descriptions-item label="订单编号"> {{ data.no }}</a-descriptions-item>
        <a-descriptions-item label="支付交易号"> {{ data.outTradeNo }}</a-descriptions-item>
        <a-descriptions-item label="订单金额(元)">
          {{(data.goodsPrice + data.additionalPrice + data.originalCourierPrice).toFixed(2)}}
        </a-descriptions-item>
        <a-descriptions-item label="附加金额(元)"> {{ data.additionalPrice }} </a-descriptions-item>
        <a-descriptions-item :label="('机柜配送' === data.type || '站点配送' === data.type) ? '配送费(元)' : '运费(元)'">
          {{ data.originalCourierPrice }}
        </a-descriptions-item>
        <a-descriptions-item label="应付金额(元)"> {{ data.price }} </a-descriptions-item>
        <a-descriptions-item label="实付金额(元)"> {{ data.actualPrice }} </a-descriptions-item>
        <a-descriptions-item label="优惠金额(元)"> {{ OrderDetail.discount }} </a-descriptions-item>
        <!-- <a-descriptions-item v-if="('机柜配送' === data.type || '站点配送' === data.type && data.courierReduce) || ('快递上门' === data.type && data.expressageReduce) " :label="'快递上门' === data.type ? '快递费减免' : '配送费减免'"> {{'快递上门' === data.type ? data.expressageReduce : data.courierReduce }} </a-descriptions-item> -->
        <a-descriptions-item label="优惠券名称">{{ OrderDetail.couponName }} </a-descriptions-item>
        <a-descriptions-item label="次卡名称">{{ OrderDetail.timecardName }} </a-descriptions-item>
        <a-descriptions-item label="订单状态"> {{ data.status }} </a-descriptions-item>
        <a-descriptions-item label="下单时间"> {{ data.createTime }} </a-descriptions-item>
        <a-descriptions-item label="机柜名称-格子数" v-if=" ( '快递上门' !== data.type && '站点自提' !== data.type && '站点配送' !== data.type ) && statusInt > 0 && statusInt < 5">
          {{ data.lockerName }}-{{ data.beforeGridNo }}
        </a-descriptions-item>
        <a-descriptions-item label="服务点名称" v-if=" ( '站点自提' === data.type || '站点配送' === data.type ) && statusInt > 0 && statusInt < 5">
          {{ data.lockerName }}
        </a-descriptions-item>
        <a-descriptions-item label="机柜名称-格子数" v-if=" ( '快递上门' !== data.type && '站点自提' !== data.type && '站点配送' !== data.type ) && statusInt >= 9 && statusInt <= 13">
          {{ data.lockerName }}-{{ data.afterGridNo }}
        </a-descriptions-item>
        <a-descriptions-item label="服务点名称" v-if=" ( '站点自提' === data.type || '站点配送' === data.type ) && statusInt >= 9 && statusInt <= 13">
          {{ data.lockerName }}
        </a-descriptions-item>
        <template v-if="'机柜配送' === data.type || '站点配送' === data.type">
          <a-descriptions-item label="配送员(取鞋)">
            <template v-if="courierNameByBefore !== '无'">
              {{ courierNameByBefore }}({{ courierPhoneByBefore }})
            </template>
            <template v-else>——</template>
          </a-descriptions-item>
          <a-descriptions-item label="配送员(送鞋)">
            <template v-if="courierNameByAfter !== '无'">
              {{ courierNameByAfter }}({{ courierPhoneByAfter }})
            </template>
            <template v-else>——</template>
          </a-descriptions-item>
        </template>
        <a-descriptions-item label="袋子码"> {{ data.bagCode || "——" }} </a-descriptions-item>
        <a-descriptions-item label="物流人员(工厂存鞋)">
          <template v-if="logisticsNameByBefore !== '无' || logisticsNameByBefore !== ' ' ">
            {{ logisticsNameByBefore }}({{ logisticsPhoneByBefore }})
          </template>
          <template v-else>——</template>
        </a-descriptions-item>
        <a-descriptions-item label="物流人员(工厂取鞋)">
          <template v-if="logisticsNameByAfter !== '无' || logisticsNameByAfter !== ' ' ">
            {{ logisticsNameByAfter }}({{ logisticsPhoneByAfter }})
          </template>
          <template v-else>——</template>
        </a-descriptions-item>
      </a-descriptions>

      <a-descriptions v-if="orderRefund" title="退款信息" layout="vertical" bordered :column="6" size="small" style="margin-bottom: 20px">
        <a-descriptions-item label="退款原因"> {{ orderRefund.reason }}</a-descriptions-item>
        <a-descriptions-item label="退款说明"> {{ orderRefund.description || '空' }} </a-descriptions-item>
        <a-descriptions-item label="退款金额(元)"> {{ (orderRefund.refundPrice/100).toFixed(2) }} </a-descriptions-item>
        <a-descriptions-item label="退款时间"> {{ orderRefund.updateTime }} </a-descriptions-item>
      </a-descriptions>

      <a-descriptions title="用户信息" layout="vertical" bordered :column="6" size="small" style="margin-bottom: 20px">
        <a-descriptions-item label="昵称"> {{ data.nickname }} </a-descriptions-item>
        <a-descriptions-item label="绑定手机"> {{ data.wxPhone }} </a-descriptions-item>
        <a-descriptions-item label="订单类型"> {{ data.type }} </a-descriptions-item>
        <template v-if="'机柜自提' === data.type || '机柜配送' === data.type">
          <a-descriptions-item label="用户姓名"> {{ data.name }} </a-descriptions-item>
          <a-descriptions-item label="手机号码"> {{ data.phone }} </a-descriptions-item>
        </template>
        <template v-if="'机柜配送' === data.type">
          <a-descriptions-item label="预定时间"> {{ data.expect }} </a-descriptions-item>
          <a-descriptions-item label="用户地址"> {{ userAddress }} </a-descriptions-item>
          <a-descriptions-item label="门牌号"> {{ door }} </a-descriptions-item>
        </template>
        <template v-if="'快递上门' === data.type">
          <a-descriptions-item label="预定时间"> {{ data.expect }} </a-descriptions-item>
          <a-descriptions-item label="用户姓名(取鞋)"> {{ sendManName }}({{ sendManMobile }}) </a-descriptions-item>
          <a-descriptions-item label="取鞋地址"> {{ sendManPrintAddr }} </a-descriptions-item>
          <a-descriptions-item label="用户姓名(寄回)"> {{ recManName }}({{ recManMobile }}) </a-descriptions-item>
          <a-descriptions-item label="寄回地址"> {{ recManPrintAddr }} </a-descriptions-item>
        </template>
      </a-descriptions>

      <a-descriptions v-if="'快递上门' === data.type" title="快递信息" layout="vertical" bordered :column="5" size="small" style="margin-bottom: 20px">
        <a-descriptions-item label="快递单号(取鞋)">
          {{ OrderDetail.sendKuaidinum || '——'}}
        </a-descriptions-item>
        <a-descriptions-item label="快递员(取鞋)">
          <template v-if="OrderDetail.sendCourierName">
            {{OrderDetail.sendCourierName}}{{ OrderDetail.sendCourierMobile }}
          </template>
          <template v-else>——</template>
        </a-descriptions-item>
        <a-descriptions-item label="快递单号(寄回)">
          {{ OrderDetail.backKuaidinum || '——'}}
        </a-descriptions-item>
        <a-descriptions-item label="快递员(寄回)">
          <template v-if="OrderDetail.backCourierName">
            {{ OrderDetail.backCourierName }}{{ OrderDetail.backCourierMobile }}
          </template>
          <template v-else>——</template>
        </a-descriptions-item>
      </a-descriptions>

      <a-descriptions title="订单照片" layout="vertical" bordered :column="5" size="small" style="margin-bottom: 20px">
        <a-descriptions-item label="鞋子照片">
          <img alt="example" style="width: 120px;margin-right: 20px;background: #F6F6F6;" v-for="item in orderImagesList" :src="item" @click="showShoeImage(item)"/>
        </a-descriptions-item>
      </a-descriptions>

      <a-descriptions title="异常信息" layout="vertical" bordered :column="5" size="small" style="margin-bottom: 20px" v-if="data.exceptionTime">
        <a-descriptions-item label="异常原因">
          <a style="text-decoration: underline" @click="showShoeExceptionInfoModel = true">查看原因</a>
        </a-descriptions-item>
        <a-descriptions-item label="处理方式">
          {{orderExceptionInfo.dealTypeText}}
        </a-descriptions-item>
        <template v-if="orderExceptionInfo.dealType == 1">
          <a-descriptions-item label="服务内容">
            {{orderExceptionInfo.title}}
          </a-descriptions-item>
          <a-descriptions-item label="补缴金额(元)">
            {{orderExceptionInfo.supplementPrice}}
          </a-descriptions-item>
          <a-descriptions-item label="补缴状态">
            {{orderExceptionInfo.payStatusText}}
          </a-descriptions-item>
        </template>
        <template v-if="orderExceptionInfo.dealType == 2">
          <a-descriptions-item label="退款金额(元)">
            {{orderExceptionInfo.refundPrice}}
          </a-descriptions-item>
          <a-descriptions-item label="退款状态">
            {{orderExceptionInfo.refundTypeText}}
          </a-descriptions-item>
        </template>
      </a-descriptions>

      <div class="table">
        <div class="table-title">物流信息</div>
        <div class="table-main">
          <div class="table-main-cell" v-for="(item, index) in logisticsDetails" :key="index">
            <div class="table-main-cell-dot"></div>
            <div class="table-main-cell-time">{{ item.time }}</div>
            <div class="table-main-cell-status">{{ item.title }}</div>
            <div class="table-main-cell-des">
              {{ item.msg }}
              <a v-if="item.status == 0" @click="showShoeImages(orderImagesList)" style="margin-left: 10px; text-decoration: underline">查看鞋子照片</a>
              <a v-if="item.status == 6" @click="showShoeImages(factoryInImages)" style="margin-left: 10px; text-decoration: underline">查看入库照片</a>
              <a v-if="item.status == 9" @click="showShoeImages(factoryOutImages)" style="margin-left: 10px; text-decoration: underline">查看出库照片</a>
            </div>
          </div>
        </div>
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
        v-for="(item,idx) in imagesList"
        :src="item"
        @click="showShoeImage(item)"
        :key="idx"
      />
      <a-empty v-if="!imagesList.length" />
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

    <a-modal
      title="异常信息"
      :width="800"
      :visible="showShoeExceptionInfoModel"
      :footer="null"
      @cancel="handleShoeExceptionInfoCancel"
    >
    <a-descriptions title="" layout="vertical" bordered :column="1" size="small" style="margin-bottom: 20px">
      <a-descriptions-item label="异常原因">
        {{orderExceptionInfo.note}}
      </a-descriptions-item>
      <a-descriptions-item label="异常照片">
        <img alt="example" style="width: 120px;margin-right: 20px;background: #F6F6F6;" v-for="item in orderExceptionInfo.images" :src="item" @click="showShoeImage(item)"/>
      </a-descriptions-item>
    </a-descriptions>
    </a-modal>
  </j-modal>
</template>

  <script>
import JImageUploadByOneForShoeOrder from '../components/JImageUploadByOneForShoeOrder'
import { getAction, httpAction } from '../../../../api/manage'

export default {
  name: 'ShoeOrderDetail',
  components: {
    JImageUploadByOneForShoeOrder,
  },
  data() {
    return {
      visible: false,
      title: '订单详情',
      data: {},
      imagesList: [],
      orderImagesList: [],
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
      afterDeliveryInfo: {},
      statusInt: 0,
      userAddress: '',
      door: '',
      courierNameByBefore: '',
      courierPhoneByBefore: '',
      courierNameByAfter: '',
      courierPhoneByAfter: '',
      logisticsNameByBefore:'',
      logisticsPhoneByBefore:'',
      logisticsNameByAfter:'',
      logisticsPhoneByAfter:'',
      recManName: '',
      recManMobile: '',
      recManPrintAddr: '',
      sendManName: '',
      sendManMobile: '',
      sendManPrintAddr: '',
      logisticsDetails: '',
      orderRefund: null,
      OrderDetail:{},
      factoryInImages: [],
      factoryOutImages: [],
    }
  },
  created() {},
  methods: {
    show(record, orderStatus) {
      //处理数据
      // let orderInfo = record;
      let orderInfo = Object.assign({}, record)
      orderInfo.goodsPrice = +(orderInfo.goodsPrice / 100).toFixed(2)
      orderInfo.originalCourierPrice = +(orderInfo.originalCourierPrice / 100).toFixed(2)
      orderInfo.totalPrice = +(orderInfo.totalPrice / 100).toFixed(2)
      orderInfo.price = +(orderInfo.price / 100).toFixed(2)
      orderInfo.couponPrice = +(orderInfo.couponPrice / 100).toFixed(2)
      orderInfo.actualPrice = +(orderInfo.actualPrice / 100).toFixed(2)
      orderInfo.additionalPrice = +(orderInfo.additionalPrice / 100).toFixed(2)
      //提前拿出订单状态，并转换成数字
      this.statusInt = parseInt(orderInfo.status)
      orderInfo.status = orderStatus

      let type = orderInfo.type
      let requestData = {
        orderId: orderInfo.orderId,
      }
      getAction('/ShoeOrder/shoeOrder/getShoeOrderDetail', requestData).then(({result:res}) => {
        this.OrderDetail = res || {}
        orderInfo.couponName = res.couponName
        orderInfo.timecardName = res.timecardName
        this.logisticsDetails = res.logisticsDetailList
        this.orderRefund = res.orderRefund
        this.factoryInImages = res.factoryInImages;
        this.factoryOutImages = res.factoryOutImages || [];
      })
      getAction("/ShoeOrder/shoeOrder/getLogisticsInfo", requestData).then((res) => {
        this.logisticsNameByBefore = res.result.logisticsNameByBefore
        this.logisticsPhoneByBefore = res.result.logisticsPhoneByBefore
        this.logisticsNameByAfter = res.result.logisticsNameByAfter
        this.logisticsPhoneByAfter = res.result.logisticsPhoneByAfter
      })
      if (type === 'self') {
        orderInfo.type = '机柜自提'
      }else if (type === 'site_self'){
        orderInfo.type = '站点自提'
      } else if (type === 'service' ) {
        orderInfo.type = '机柜配送'
        //获取配送信息
        getAction('/ShoeOrder/shoeOrder/getCourierInfo', requestData).then((res) => {
          this.userAddress = res.result.address
          this.door = res.result.door
          this.courierNameByBefore = res.result.courierNameByBefore
          this.courierPhoneByBefore = res.result.courierPhoneByBefore
          this.courierNameByAfter = res.result.courierNameByAfter
          this.courierPhoneByAfter = res.result.courierPhoneByAfter
          this.logisticsNameByBefore = res.result.logisticsNameByBefore
        })
      }  else if (type === 'site') {
        orderInfo.type = '站点配送'
        //获取配送信息
        getAction('/ShoeOrder/shoeOrder/getCourierInfo', requestData).then((res) => {
          this.userAddress = res.result.address
          this.door = res.result.door
          this.courierNameByBefore = res.result.courierNameByBefore
          this.courierPhoneByBefore = res.result.courierPhoneByBefore
          this.courierNameByAfter = res.result.courierNameByAfter
          this.courierPhoneByAfter = res.result.courierPhoneByAfter
        })
      }else if (type === 'expressage') {
        orderInfo.type = '快递上门'
        //获取配送信息

        getAction('/ShoeOrder/shoeOrder/getCourierInfoByExpressage', requestData).then((res) => {
          this.recManName = res.recManName
          this.recManMobile = res.recManMobile
          this.recManPrintAddr = res.recManPrintAddr
          this.sendManName = res.sendManName
          this.sendManMobile = res.sendManMobile
          this.sendManPrintAddr = res.sendManPrintAddr
        })
      }

      let orderImagesString = ''
      let orderImagesArray = JSON.parse(orderInfo.orderImages)
      for (let i = 0; i < orderImagesArray.length; i++) {
        orderImagesString += orderImagesArray[i]
        if (i < orderImagesArray.length - 1) {
          orderImagesString += ','
        }
      }

      this.orderImagesList = orderImagesArray

      this.visible = true
      this.data = orderInfo

      //如果此订单是异常的状态，要查询此订单的异常情况，如果此订单要”增加服务费“，将再此查询补款记录
      if (this.data.exceptionTime) {
        let ShoeOrderExceptionData = {
          orderId: this.data.orderId,
        }
        getAction('/ShoeOrder/shoeOrder/getShoeOrderException', ShoeOrderExceptionData).then((res) => {
          this.orderExceptionInfo = res.result
          this.orderExceptionInfo.title = res.result.title || '无'
          this.orderExceptionInfo.dealTypeText = res.result.status == 0 ? '未处理' : res.result.dealTypeText
        })
      } else {
        this.orderExceptionInfo = {
          createTime: '',
          dealNote: '',
          dealTime: '',
          dealType: '',
          dealUserId: '',
          dealUsername: '',
          images: [],
          note: '',
          orderExceptionId: '',
          orderId: '',
          payStatus: '',
          payTime: '',
          price: '',
          reportUserId: '',
          reportUsername: '',
          status: '',
          title: '',
        }
      }
    },
    handleCancel() {
      this.visible = false
      this.imagesList = []
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
      this.logisticsNameByBefore = ''
      this.logisticsPhoneByBefore = ''
      this.logisticsNameByAfter = ''
      this.logisticsPhoneByAfter = ''
      this.recManName = ''
      this.recManMobile = ''
      this.recManPrintAddr = ''
      this.sendManName = ''
      this.sendManMobile = ''
      this.sendManPrintAddr = ''
      this.logisticsDetails = ''
      this.OrderDetail = {}
    },
    previewModel() {
      this.previewVisible = true
      this.previewImage = this.data.image
    },
    handleModelCancel() {
      this.previewVisible = false
      this.previewImage = ''
    },
    showShoeImages(imagesList) {
      this.imagesList = imagesList;
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
  },
}
</script>

  <style scoped lang="less">
.table {
  &-title {
    margin-bottom: 20px;
    color: rgba(0, 0, 0, 0.85);
    font-weight: bold;
    font-size: 16px;
    line-height: 1.5;
  }
  &-main {
    font-family: PingFangSC-Medium, PingFang SC;
    font-size: 16px;
    &-cell {
      &:first-child {
        .table-main-cell-dot {
          background-color: #0090ff;
        }
      }
      &:last-child {
        .table-main-cell-dot::after {
          height: 0;
        }
      }
      display: flex;
      align-items: center;

      margin-bottom: 16px;
      &-dot {
        position: relative;
        width: 10px;
        height: 10px;
        background-color: #ddd;
        border-radius: 50%;
        position: relative;
        &::after {
          content: '';
          display: block;
          position: absolute;
          height: 26px;
          width: 2px;
          background-color: #dddddd;
          left: 50%;
          top: 120%;
          transform: translate(-50%, 0);
        }
      }
      &-time {
        margin-left: 14px;
        margin-right: 60px;
        color: #999999;
      }
      &-status {
        font-weight: 500;
        color: #333333;
        margin-right: 32px;
      }
      &-des {
      }
    }
  }
}
/deep/ .ant-descriptions-bordered .ant-descriptions-item-label {
  background-color: #f5f5f5;
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
}

.diyDiv {
  width: 100%;
  height: 680px;
  overflow-y: scroll;
}
</style>