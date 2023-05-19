<template>
  <j-modal
    :title="title"
    :width="width"
    :visible="visible"
    @cancel="handleCancel"
    :footer="null"
    >
    <div style="width: 100%;">
      <a-form-model :model="form" :label-col="labelCol" :wrapper-col="wrapperCol">
        <a-form-model-item label="给邀请人的奖励(老用户)">
          <XfSelect
              allowClear
              :list="pullUserCoupons"
              :rawList="rowPullUserCoupons"
              @changeList="changeSelect($event,'pullUserCoupons')"
              placeholder="请选择优惠券"
              v-model="form.couponId"
              :url='`/shoes/shoeUser/getCouponOrCardBagOrTimecard?type=0`'
            >
            </XfSelect>
        </a-form-model-item>
        <a-form-model-item label="给被邀请人的奖励(新用户)">
          <XfSelect
              allowClear
              :list="bePulledUserCoupons"
              :rawList="rowBePulledUserCoupons"
              @changeList="changeSelect($event,'bePulledUserCoupons')"
              placeholder="请选择优惠券"
              v-model="form.registerCoupon"
              :url='`/shoes/shoeUser/getCouponOrCardBagOrTimecard?type=0`'
            >
            </XfSelect>
        </a-form-model-item>
      </a-form-model>
      <div style="margin: 30px 0"></div>
      <a-button type="primary" @click="handleSave" style="display: block;margin: 0 auto;">保存</a-button>
    </div>
  </j-modal>
</template>

<script>
import {httpAction} from "../../../../api/manage";
import XfSelect from "@comp/Xf/XfSelect";

export default {
  name: "CouponSelectModal",
  components:{
    XfSelect
  },
  data() {
    return {
      labelCol: { span: 10 },
      wrapperCol: { span: 14 },
      title: "优惠券设置",
      width: 460,
      visible: false,
      form:{
        couponId:'',
        registerCoupon:''
      },
      pullUserCoupons:[],
      bePulledUserCoupons:[],
      rowPullUserCoupons:[],
      rowBePulledUserCoupons:[],
    }
  },
  created() {

  },
  methods: {
    changeSelect(data,name) {
      this[name] = data.records.map(item => ({
        label: item.name,
        value: item.id+''
      }));
    },
    show(data){
      this.rowPullUserCoupons = [{
        label:data.couponName,
        value:data.couponId
      }]
      
      this.rowBePulledUserCoupons = [{
        label:data.registerCouponName,
        value:data.registerCoupon
      }]
      this.form = Object.assign({},this.form,data)
      this.visible = true;
    },
    handleCancel() {
      this.visible = false;
    },
    handleSave() {
      this.form.couponId = this.form.couponId || ''
      this.form.registerCoupon = this.form.registerCoupon || ''
      httpAction("/ShoeEvent/ShoeEvent/updatePullEventBindingCoupon", this.form, "post").then((res) => {
        if (res.success) {
          this.$message.success(res.message);
          this.visible = false;
          this.$emit('ok');
        }
      })
    }
  }
}
</script>

<style scoped>

</style>