<!--
 * @Descripttion: your project
 * @version: 1.0
 * @Author: yizhimao
 * @Date: 2023-02-08 15:07:07
 * @LastEditors: yizhimao
 * @LastEditTime: 2023-04-21 15:28:22
-->
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
    <h2>实际到账金额：{{realwithdrawal}}</h2>
    <h2>手续费率：{{withdrawalRatio*100}}%</h2>
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
  name: "ShoeInvestorsWithdrawalDetail",
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
      withdrawalRatio:'',
      realwithdrawal:''
    }
  },
  methods: {
    handleCancel() {
      this.visible = false;
    },
    show(record){

      httpAction("/shoes/shoeLocker/withdrawalDetail?id="+record.sitemanagerWithdrawalId, null, "get").then((res) => {
        if (res) {
          this.visible = true;
          this.name=res.result.name;
          this.amount=res.result.amount;
          this.createTime=res.result.createTime;
          this.cardNo=res.result.cardNo;
          this.cardName=res.result.cardName;
          this.bank=res.result.bank;
          this.openBank=res.result.openBank;
          this.withdrawalRatio=parseFloat(res.result.withdrawalRatio || 0);
          this.realwithdrawal=res.result.realwithdrawal;

          if (res.result.status==0){
            this.status='审核中'
          }else if (res.result.status==1){
            this.status='提现中'
          }else if (res.result.status==2){
            this.status='审核失败'
          }else if (res.result.status==3){
            this.status='已提现'
          }
        }
      })


    }
  }

}
</script>

<style scoped>

</style>