<template>
  <j-modal
    :title="title"
    :width="width"
    :visible="visible"
    switchFullscreen
    @cancel="handleCancel"
    cancelText="关闭"
    @ok="handleOk"
  >


    <h2>申请人：{{name}}</h2>
    <h2>提现金额：{{amount}}</h2>
    <h2>银行卡号：{{cardNo}}</h2>
    <h2>持卡人：{{cardNo}}</h2>
    <h2>开户行：{{bank}}</h2>
    <h2>开户行地址：{{openBank}}</h2>


    <h2>是否已转账：
      <j-dict-select-tag type="radio" v-model="model.status" dictCode="withdrawal_transfer_status"/>
    </h2>



  </j-modal>

</template>

<script>
import {httpAction, putAction} from "@api/manage";

export default {
  name: "ShoeInvestorsAudit",
  props: {
    //表单禁用
    disabled: {
      type: Boolean,
      default: false,
      required: false
    }
  },
  data() {
    return {
      title: '提现详情',
      width: 600,
      amount: '',
      name: '',
      id: '',
      cardNo:'',
      cardName:'',
      bank:'',
      openBank:'',
      visible: false,
      model: {
        status: 0
      },
    }
  },
  methods: {
    handleOk() {
      const that = this;
      if (this.model.status==0){
        let data = {
          "investorsWithdrawalId": that.id,
          "status": that.model.status,
          "amount": that.amount * 100,
        };
        putAction("/shoes/shoeInvestors/updateWithdrawalTransferStatus", data).then((res) => {
          if (res.code === 200) {
            this.visible = false;
            that.$message.success('提交成功')
            that.$emit('ok');
          }
        })
      }else {
        this.visible = false;
      }
    },
    handleCancel() {
      this.visible = false;
    },
    show(record){
      httpAction("/shoes/shoeInvestors/withdrawalDetail?id="+record.investorsWithdrawalId, null, "get").then((res) => {
        if (res) {
          this.visible = true;
          this.id = res.result.investorsWithdrawalId;
          this.name=res.result.name;
          this.amount=res.result.amount;
          this.cardNo=res.result.cardNo;
          this.cardName=res.result.cardName;
          this.bank=res.result.bank;
          this.openBank=res.result.openBank;
        }
      })


    }
  }

}
</script>

<style scoped>

</style>