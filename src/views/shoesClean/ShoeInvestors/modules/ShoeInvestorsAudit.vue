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


    <h2>申请人：{{ name }}</h2>
    <h2>提现金额：{{ amount }}</h2>

    <!--      <a-form-model-item label="审核" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="status">-->
    <!--        <j-dict-select-tag type="radio" v-model="model.status"  dictCode="shoe_courier_status" placeholder="请选择登录状态" />-->
    <!--      </a-form-model-item>-->
    <h2>审核：
      <j-dict-select-tag type="radio" v-model="model.status" dictCode="withdrawal_audit"/>
    </h2>

      <h2 v-if="this.model.status==1">拒绝原因(必填)：
        <a-textarea v-model="model.note"  rows="4" />
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
      visible: false,
      model: {
        status: 0
      },

    }
  },
  methods: {
    handleOk() {
      const that = this;
      let data = {
        "investorsWithdrawalId": that.id,
        "status": that.model.status,
        "note": that.model.note,
      };
     if (that.model.note==null){
       that.$message.error('请填写拒绝原因')
     }else {
       putAction("/shoes/shoeInvestors/updateWithdrawalAuditStatus", data).then((res) => {
         if (res.code === 200) {
           this.visible = false;
           that.$message.success('提交成功')
           that.$emit('ok');
           that.model.note=null;
         }
       })
     }


    },
    handleCancel() {
      this.visible = false;
    },
    show(record) {
      this.visible = true;

      httpAction("/shoes/shoeInvestors/withdrawalDetail?id=" + record.investorsWithdrawalId, null, "get").then((res) => {
        if (res) {
          this.visible = true;
          this.id = res.result.investorsWithdrawalId;
          this.name = res.result.name;
          this.amount = res.result.amount;
        }
      })
    }
  }

}
</script>

<style scoped>

</style>