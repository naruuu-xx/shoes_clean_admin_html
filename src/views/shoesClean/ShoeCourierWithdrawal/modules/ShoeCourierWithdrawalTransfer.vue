<template>
  <a-spin :spinning="confirmLoading">
    <j-modal title=""
             :width="700"
             :visible="visible"
             switchFullscreen
             @ok="handleSubmit"
             @cancel="handleCancel"
             cancelText="关闭"
             wrapClassName="full-modal">
      <div>
        <a-row>
          <a-col :span="24">
            <div class="content-font">申请人：{{data.name}}</div>
          </a-col>
        </a-row>
        <a-row>
          <a-col :span="24">
            <div class="content-font">提现金额：{{data.amountTemp}}</div>
          </a-col>
        </a-row>
        <a-row>
          <a-col :span="24">
            <div class="content-font">实际到账金额：{{data.realwithdrawal}}</div>
          </a-col>
        </a-row>
        <a-row>
          <a-col :span="24">
            <div class="content-font">手续费率：{{data.withdrawalRatio*100}}%</div>
          </a-col>
        </a-row>
        <a-row>
          <a-col :span="24">
            <div class="content-font">银行卡号：{{data.cardNo}}</div>
          </a-col>
        </a-row>
        <a-row>
          <a-col :span="24">
            <div class="content-font">持卡人：{{data.cardName}}</div>
          </a-col>
        </a-row>
        <a-row>
          <a-col :span="24">
            <div class="content-font">开户行：{{data.openBank}}</div>
          </a-col>
        </a-row>
        <a-row>
          <a-col :span="24">
            <div class="content-font">开户行地址：{{data.bankAddress}}</div>
          </a-col>
        </a-row>
        <a-row>
          <a-col :span="24">
            <div class="content-font">是否已转账：
              <a-radio-group v-model:value="transferOption">
                <a-radio value="3">是</a-radio>
                <a-radio value="4">否</a-radio>
              </a-radio-group>
            </div>
          </a-col>
        </a-row>
      </div>
    </j-modal>
  </a-spin>
</template>

<script>
import {httpAction} from "../../../../api/manage";

export default {
  name: "ShoeCourierWithdrawalTransfer",
  data(){
    return {
      visible: false,
      data: {},
      transferOption: "3",
      confirmLoading: false,
    }
  },
  methods: {
    show(record) {
      this.visible = true;
      this.data = record;
      this.transferOption = "3";
    },
    handleCancel() {
      this.visible = false;
      this.data = {};
      this.auditOption = "3";
    },
    handleSubmit() {
      let that = this;

      that.confirmLoading = true;

      if ("3" === this.transferOption) {
        this.data.status = this.transferOption;
        // this.data.amount = this.data.amount * 100;

        //发送请求
        let httpUrl = "/ShoeCourierWithdrawal/shoeCourierWithdrawal/handleTransfer";

        httpAction(httpUrl, this.data, "post").then((res) => {
          if (res.success) {
            that.$message.success(res.message);
            this.handleCancel();
            that.$emit('ok');
          } else {
            that.$message.warning(res.message);
          }
        }).finally(() => {
          that.confirmLoading = false;
        })

      } else if ("4" === this.transferOption) {
        //直接关闭窗口
        this.handleCancel();
        that.confirmLoading = false;
      }

    }
  }
}
</script>

<style scoped>
.content-font {
  color: #000000;
  font-size: 16px;
  margin-top: 10px;
  margin-bottom: 10px;
}
</style>