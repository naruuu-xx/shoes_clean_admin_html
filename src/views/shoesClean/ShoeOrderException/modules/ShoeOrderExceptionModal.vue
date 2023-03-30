<template>
  <j-modal
    :title="title"
    :width="800"
    :visible="visible"
    switchFullscreen
    @cancel="handleCancel"
    cancelText="关闭"
    :footer="null"
    wrapClassName="full-modal">
    <div style="margin-left: 20px">
      <a-row>
        <a-col :span="24">
          <p class="label-content">订单编号：{{data.no}}</p>
        </a-col>
        <a-col :span="8">
          <p class="label-content">商品名：{{data.title}}</p>
        </a-col>
        <a-col :span="16">
          <p class="label-content">商品规格：{{data.skuTitle}}</p>
        </a-col>
        <a-col :span="24">
          <p class="label-content">订单备注：{{data.orderNote}}</p>
        </a-col>
        <a-col :span="8">
          <p class="label-content">用户姓名：{{data.name}}</p>
        </a-col>
        <a-col :span="16">
          <p class="label-content">手机号：{{data.phone}}</p>
        </a-col>
      </a-row>
      <a-divider />
      <a-row>
        <a-col :span="24">
          <p class="label-content">异常照片：</p>
          <img alt="example" style="width: 20%;height:20%;margin: 10px" v-for="item in exceptionImageList" :src="item" @click="showImage(item)">
        </a-col>
      </a-row>
      <a-row>
        <a-col :span="24">
          <p class="label-content">异常备注：{{data.exceptionNote}}</p>
        </a-col>
      </a-row>
      <a-divider />

      <a-form-model ref="form" :model="form" :rules="validatorRules">
        <a-row>
          <a-col :span="24">
            <a-form-model-item :labelCol="labelCol" :wrapperCol="wrapperCol" label="处理方式" prop="handleType">
              <a-radio-group :options="options" v-model="form.handleType" />
            </a-form-model-item>
          </a-col>
          <a-col :span="24" v-if="form.handleType == 1">
            <a-form-model-item :labelCol="labelCol" :wrapperCol="wrapperCol" label="服务项名称" prop="title">
              <a-input v-model="form.title" style="width: 200px" />
            </a-form-model-item>
          </a-col>
          <a-col :span="24" v-if="form.handleType == 1">
            <a-form-model-item :labelCol="labelCol" :wrapperCol="wrapperCol" label="追加金额" prop="amount">
              <a-input-number v-model="form.amount" :min="0.01" @change="onChangeAmount" /><span class="label-content">&nbsp;元</span>
            </a-form-model-item>
          </a-col>
          <a-col :span="24" v-if="form.handleType == 2">
            <a-form-model-item :labelCol="labelCol" :wrapperCol="wrapperCol" label="退款金额" prop="refundType">
              <a-radio-group :options="options1" v-model="form.refundType" />
            </a-form-model-item>
          </a-col>
          </a-row>
      </a-form-model>
      <a-row>
        <a-col :span="8"></a-col>
        <a-col :span="4"><a-button @click="handleCancel" size="large">取消</a-button></a-col>
        <a-col :span="4"><a-button type="primary" @click="sendAdditionalOrder" size="large">确认</a-button></a-col>
        <a-col :span="8"></a-col>
      </a-row>
    </div>

    <a-modal :zIndex="2000" :width="1000" :visible="showImageModal" :footer="null" @cancel="handleShoeImageModalCancel()">
      <img alt="example" style="width: 100%" :src="clickedImage">
    </a-modal>

  </j-modal>
</template>

<script>
import {httpAction} from "../../../../api/manage";

export default {
  name: "ShoeOrderExceptionModal",
  components: {
  },
  data(){
    return {
      labelCol: {
        xs: { span: 24 },
        sm: { span: 3 },
      },
      wrapperCol: {
        xs: { span: 24 },
        sm: { span: 16 },
      },
      visible: false,
      title: '异常订单处理',
      data: {},
      exceptionImageList: [],
      showImageModal: false,
      clickedImage: "",
      additionalExpenseModal: false,
      amount: 1,
      serviceTitle: "",
      options: [
        { label: '增加服务费', value: '1' },
        { label: '退回', value: '2' },
        { label: '继续洗', value: '3' },
      ],
      options1: [
        { label: '整单退款', value: '1' },
        { label: '仅退回商品金额', value: '2' }
      ],
      form:{
        orderExceptionId:'',
        orderId:'',
        handleType: '',
        refundType: '',
        amount:'',
        title:''
      },
      validatorRules:{

        handleType: [
          { required: true, message: '请选择处理方式!' },
        ],
        title: [
          { required: true, message: '请输入商品名称!' },
        ],
        amount: [
          { required: true, message: '请输追加金额!' },
        ],
        refundType: [
          { required: true, message: '请选择退款金额类型!' },
        ],
      }
    }
  },
  created() {
  },
  methods: {
    onChangeAmount(value) {
       this.form.amount = parseFloat(`${parseFloat(value+0).toFixed(2)}`) || 0.01
    },
    show(record){
      this.visible = true;
      this.data = Object.assign({}, record);
      this.form.orderExceptionId = record.orderExceptionId
      this.form.orderId = record.orderId
      this.exceptionImageList = record.imagesList;
    },
    handleCancel(){
      this.visible = false;
      this.data = {};
      this.exceptionImageList = [];
    },
    showImage(item){
      this.showImageModal = true;
      this.clickedImage = item;
    },
    handleShoeImageModalCancel(){
      this.showImageModal = false;
      this.clickedImage = "";
    },
    sendBack(){
      let that = this;

      let data = {
        "orderExceptionId": this.data.orderExceptionId,
        "orderId": this.data.orderId
      }

      httpAction("/ShoeOrder/shoeOrder/shoeOrderExceptionSendBack", data, "post").then((res) => {
        if (res.success){
          that.$message.success(res.message);
          this.visible = false;
          this.$emit('ok');
        }else{
          that.$message.warning(res.message);
        }
      })

    },
    additionalExpense(){
      this.additionalExpenseModal = true;
    },
    handleAdditionalExpenseModalCancel(){
      this.additionalExpenseModal = false;
      this.amount = 1;
      this.serviceTitle = "";
    },
    sendAdditionalOrder(){

      this.$refs.form.validate(valid => {
        if (valid) {
          httpAction("/ShoeOrder/shoeOrder/handleOrderException", this.form, "post").then((res) => {
            if (res.success){
              this.$message.success(res.message);
              this.visible = false;
              this.reset()
              this.$emit('ok');
            }else{
              this.$message.warning(res.message);
            }
          })
        }

      })
    },
    reset() {
      this.form = {
        orderExceptionId:'',
        orderId:'',
        handleType: '',
        refundType: '',
        amount:'',
        title:''
      }
    }
  }
}
</script>

<style scoped>
.label-content {
  font-size: 18px;
  color: #000000;
}
</style>