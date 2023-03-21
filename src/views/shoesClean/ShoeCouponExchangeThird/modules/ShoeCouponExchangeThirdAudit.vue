<template>
  <a-spin :spinning="confirmLoading">
    <j-modal title=""
             :width="700"
             :visible="visible"
             switchFullscreen
             @ok="handleSubmit2"
             @cancel="handleCancel2"
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
            <div class="content-font">手机号：{{data.phone}}</div>
          </a-col>
        </a-row>
        <a-row>
          <a-col :span="24">
            <div class="content-font">兑换码：{{data.code}}</div>
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
        <a-row v-if="'1' === auditOption">
          <a-col :span="24">
            <div class="content-font">
              选择优惠券：
              <XfSelect
                :list="weekList"
                @change="checkedSelect"
                @changeList="changeSelect"
                v-model="data.couponId"
                :url='`/shoes/shoeUser/getCouponOrCardBag?type=0`'
              >
              </XfSelect>
            </div>
          </a-col>
        </a-row>



      </div>
      </j-modal>
  </a-spin>
</template>

<script>
import {httpAction} from "../../../../api/manage";
import XfSelect from '@/components/Xf/XfSelect'
export default {
  components:{
    XfSelect
  },
  data() {
    return {
      visible: false,
      weekList:[],
      data: {},
      auditOption: "1",
      confirmLoading: false,
    }
  },
  methods: {
    changeSelect(data) {
      this.weekList = data.records.map(item => ({
        label: item.name,
        value: +item.id
      }));
    },
    checkedSelect(val) {
    },
    show(record) {
      this.visible = true;
      this.data = record;
      this.auditOption = "1";
      this.data.note = "";
    },
    handleCancel2() {
      this.visible = false;
      this.data = {};
      this.auditOption = "1";
      this.data.note = "";
    },
    handleSubmit2() {
      let that = this;

      that.confirmLoading = true;

      if ("2" === this.auditOption && this.data.note.trim() === "") {
        that.$message.warning("请填写拒绝原因！");
        that.confirmLoading = false;
        return false;
      } else {
        this.data.status = this.auditOption;
        this.data.note = this.data.note.trim();
        //发送请求
        let httpUrl = "/shoeCouponExchangeThird/update";
        httpAction(httpUrl, this.data, "put").then((res) => {
          if (res.success) {
            that.$message.success(res.message);
            this.handleCancel2();
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