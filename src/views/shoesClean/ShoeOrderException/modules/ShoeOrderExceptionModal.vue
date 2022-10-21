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
      </a-row>
      <a-row>
        <a-col :span="7">
          <p class="label-content">商品名：{{data.title}}</p>
        </a-col>
        <a-col :span="7">
          <p class="label-content">商品规格：{{data.skuTitle}}</p>
        </a-col>
        <a-col :span="10">
        </a-col>
      </a-row>
      <a-row>
        <a-col :span="24">
          <p class="label-content">订单备注：{{data.orderNote}}</p>
        </a-col>
      </a-row>
      <a-row>
        <a-col :span="7">
          <p class="label-content">用户姓名：{{data.name}}</p>
        </a-col>
        <a-col :span="7">
          <p class="label-content">手机号：{{data.phone}}</p>
        </a-col>
        <a-col :span="10"></a-col>
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
      <a-row>
        <a-col :span="8"></a-col>
        <a-col :span="4"><a-button type="primary" @click="sendBack" size="large">退&nbsp;回</a-button></a-col>
        <a-col :span="4"><a-button type="primary" @click="additionalExpense" size="large">追加金额</a-button></a-col>
        <a-col :span="8"></a-col>
      </a-row>
    </div>

    <a-modal :zIndex="2000" :width="1000" :visible="showImageModal" :footer="null" @cancel="handleShoeImageModalCancel()">
      <img alt="example" style="width: 100%" :src="clickedImage">
    </a-modal>

    <a-modal :zIndex="1500" :width="600" :visible="additionalExpenseModal" :footer="null" @cancel="handleAdditionalExpenseModalCancel()">
      <div>
        <a-row style="margin: 20px 0 20px 0;">
          <a-col :span="24">
            <p class="label-content">订单编号：{{data.no}}</p>
          </a-col>
        </a-row>
        <a-row style="margin: 20px 0 20px 0;">
          <a-col :span="24">
            <span class="label-content">服务项名称：<a-input v-model:value="serviceTitle" style="width: 200px" /></span>
          </a-col>
        </a-row>
        <a-row style="margin: 20px 0 20px 0;">
          <a-col :span="24">
            <span class="label-content">追加金额：</span><a-input-number v-model:value="amount" :min="1" /><span class="label-content">&nbsp;元</span>
          </a-col>
        </a-row>
        <a-row style="margin: 20px 0 20px 0;">
          <a-col :span="9"></a-col>
          <a-col :span="15">
            <a-button type="primary" @click="sendAdditionalOrder" size="large">发送订单</a-button>
          </a-col>
        </a-row>
      </div>
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
      visible: false,
      title: '异常订单处理',
      data: {},
      exceptionImageList: [],
      showImageModal: false,
      clickedImage: "",
      additionalExpenseModal: false,
      amount: 1,
      serviceTitle: "",
    }
  },
  created() {
  },
  methods: {
    show(record){
      this.visible = true;
      this.data = Object.assign({}, record);
      this.exceptionImageList = JSON.parse(record.images);
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
      if (this.amount !== null) {
        let that = this;

        //处理金额单位
        let amount = this.amount;
        amount = amount * 100

        let data = {
          "orderExceptionId": this.data.orderExceptionId,
          "orderId": this.data.orderId,
          "amount": amount,
          "title": this.serviceTitle
        }

        httpAction("/ShoeOrder/shoeOrder/shoeOrderExceptionAdditional", data, "post").then((res) => {
          if (res.success){
            that.$message.success(res.message);
            this.additionalExpenseModal = false;
            this.visible = false;
            this.$emit('ok');
          }else{
            that.$message.warning(res.message);
          }
        })
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