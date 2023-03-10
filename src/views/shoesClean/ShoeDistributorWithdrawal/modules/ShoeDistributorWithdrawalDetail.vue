<template>
  <j-modal
    :title="title"
    :width="width"
    :visible="visible"
    switchFullscreen
    @cancel="handleCancel"
    cancelText="关闭"
    :footer="null"
  >
    <h2>申请人：{{name}}</h2>
    <h2>提现金额：{{amount}}</h2>
    <h2>申请时间：{{createTime}}</h2>
    <h2>银行卡号：{{cardNo}}</h2>
    <h2>持卡人：{{cardName}}</h2>
    <h2>开户行：{{bank}}</h2>
    <h2>开户行地址：{{openBank}}</h2>
    <h2>申请状态：{{status}}</h2>


  </j-modal>

</template>

<script>
import {httpAction} from "@api/manage";

export default {
  name: "ShoeDistributorWithdrawalDetail",
  props: {
    //表单禁用
    disabled: {
      type: Boolean,
      default: false,
      required: false
    }
  },
  data(){
    return{
      title: '提现详情',
      width: 600,
      visible: false,
      name:'',
      amount:'',
      createTime:'',
      cardNo:'',
      cardName:'',
      bank:'',
      openBank:'',
      status:'',
    }
  },
  methods: {
    handleCancel() {
      this.visible = false;
    },
    show(record){
      this.visible = true;
      this.name=record.name;
      this.amount=record.amount;
      this.createTime=record.createTime;
      this.cardNo=record.cardNo;
      this.cardName=record.cardName;
      this.bank=record.bank;
      this.openBank=record.openBank;
      this.status=record.status;
    }
  }

}
</script>

<style scoped>

</style>