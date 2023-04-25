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
            <div class="content-font">手续费率：{{(data.withdrawalRatio || 0)*100}}%</div>
          </a-col>
        </a-row>
        <a-row>
          <a-col :span="24">
            <div class="content-font">审核&nbsp;&nbsp;&nbsp;
              <a-radio-group v-model:value="auditOption">
                <a-radio value="1">同意</a-radio>
                <a-radio value="2">拒绝</a-radio>
              </a-radio-group>
            </div>
          </a-col>
        </a-row>
        <a-row v-if="'2' === auditOption">
          <a-col :span="24">
            <div class="content-font">
              拒绝原因：
              <a-textarea v-model="data.note" rows="4" placeholder="请输入备注"/>
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
  name: "ShoeCourierWithdrawalAudit",
  data() {
    return {
      visible: false,
      data: {},
      auditOption: "1",
      confirmLoading: false,
    }
  },
  methods: {
    show(record) {
      this.visible = true;
      this.data = record;
      this.auditOption = "1";
      this.data.note = "";
    },
    handleCancel() {
      this.visible = false;
      this.data = {};
      this.auditOption = "1";
      this.data.note = "";
    },
    handleSubmit() {
      let that = this;

      that.confirmLoading = true;

      if ("2" === this.auditOption && this.data.note.trim() === "") {
        that.$message.warning("请填写拒绝原因！");
        that.confirmLoading = false;
        return false;
      } else {
        this.data.status = this.auditOption;
        // this.data.amount = this.data.amount * 100;
        this.data.note = this.data.note.trim();
        //发送请求
        let httpUrl = "/ShoeCourierWithdrawal/shoeCourierWithdrawal/handleAudit";
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