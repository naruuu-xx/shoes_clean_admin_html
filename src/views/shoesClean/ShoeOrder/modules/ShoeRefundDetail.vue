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
          <a-form-model :model="form" :rules="rules" ref="ruleForm" layout="horizontal" :labelCol="{ span: 10 }"
      :wrapperCol="{ span: 14 }">
            <a-form-model-item label="退款金额：" prop="refundPrice">
              <a-input v-model="form.refundPrice" type="number"/>
            </a-form-model-item>
          </a-form-model>
        </div>
      </div>
      <div class="foot">
        <a-button type="primary"  @click="onRefund" :loading="buttonLoading"> 退款 </a-button>
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
import throttle from '@/utils/throttle'

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
      refundPrice: '', // 退款金额
      buttonLoading: false,
      rules: {
        refundPrice: [
          { required: true, message: '请输入退款金额' },
          { validator: this.validateRefundPrice}
        ],
      },
      form:{
        refundPrice: ''
      }
    }
  },
  created() {},
  methods: {
    // 验证规则
    validateRefundPrice(rule, value, callback){
      if(new RegExp(/[0-9]+([.]{1}[0-9]+){0,1}/).test(value)){
            if(parseFloat(value) < 0) {
              callback("退款金额必须大于0!");
            } else {
              if(parseFloat(value) <= parseFloat(this.data.actualPrice)) {
                callback();
              } else {
                callback("退款金额大于实付金额!");
              }
            }
          }else{
            callback("请输入正确格式的金额!");
          }
      },
    // 点击了退款
    onRefund() {
      this.$refs.ruleForm.validate(valid => {
        if (valid) {
          this.buttonLoading = true
          // 节流一秒触发一次
          throttle(()=>{
            httpAction('/ShoeOrder/shoeOrder/orderRefund',
            {
              orderId:this.data.orderId,
              orderPId:this.data.orderPId,
              refundPrice:this.form.refundPrice*100,},'post')
            .then(res => {
            if (res.success) {
              this.buttonLoading = false
              this.$message.success('退款成功')
              this.handleCancel();
              this.$emit('ok');

            } else {
              this.buttonLoading = false
              this.$message.error(res.message)
            }
          })
          },1500)
        } else {
          console.log('error submit!!');
          return false;
        }
      });
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


      let type = orderInfo.type
      if (type === 'self') {
        orderInfo.type = '站点自寄'
      } else if (type === 'service') {
        orderInfo.type = '上门取件'
      }



      this.visible = true
      this.data = orderInfo

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
      this.refundPrice = ''
      this.form.refundPrice = ''
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
/deep/ .ant-form-item label {
  font-size: 18px;
}
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