<template>
  <j-modal title="详情"
           :width="700"
           :visible="visible"
           switchFullscreen
           @cancel="handleCancel"
           cancelText="关闭"
           :footer="null"
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
          <div class="content-font">申请时间：{{data.createTime}}</div>
        </a-col>
      </a-row>
      <a-row>
        <a-col :span="24">
          <div class="content-font">审核时间：{{data.auditTime === null ? "-" : data.auditTime}}</div>
        </a-col>
      </a-row>
      <a-row>
        <a-col :span="24">
          <div class="content-font">提现时间：{{data.transferTime === null ? "-" : data.transferTime}}</div>
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
          <div class="content-font">申请状态：{{statusText}}</div>
        </a-col>
      </a-row>
      <a-row v-if="data.status === '2'">
        <a-col :span="24">
          <div class="content-font">拒绝原因：{{data.note}}</div>
        </a-col>
      </a-row>
    </div>
  </j-modal>
</template>

<script>
export default {
  name: "ShoeCourierWithdrawalDetail",
  data() {
    return {
      visible: false,
      data: {},
      statusText: ""
    }
  },
  methods: {
    show(record) {
      this.visible = true;
      this.data = record;

      let status = record.status;

      if ("0" === status) {
        this.statusText = "审核中";
      } else if ("1" === status) {
        this.statusText = "提现中";
      } else if ("2" === status) {
        this.statusText = "已拒绝";
      } else if ("3" === status) {
        this.statusText = "已提现";
      }

    },
    handleCancel() {
      this.visible = false;
      this.data = {};
      this.statusText = "";
    }
  }
}
</script>

<style scoped lang="less">
.content-font {
  color: #000000;
  font-size: 20px;
  margin-top: 10px;
  margin-bottom: 10px;
}
</style>