<template>
  <j-modal
    :title="title"
    :width="width"
    :visible="visible"
    @cancel="handleCancel"
    :footer="null"
    >
    <div style="width: 100%;height: 100px;">
      <a-select
        v-model:value="selectedCoupon"
        style="width: 200px;display: block;margin: 0 auto;"
        placeholder="请选择"
        :options="couponList"
      >
      </a-select>
      <div style="margin: 30px 0"></div>
      <a-button type="primary" @click="handleSave" style="display: block;margin: 0 auto;">保存</a-button>
    </div>
  </j-modal>
</template>

<script>
import {httpAction} from "../../../../api/manage";

export default {
  name: "CouponSelectModal",
  data() {
    return {
      title: "优惠券设置",
      width: 400,
      visible: false,
      couponList: [],
      selectedCoupon: "",
      id: ""
    }
  },
  created() {

  },
  methods: {
    show(id, couponId){
      this.visible = true;
      this.selectedCoupon = couponId;
      this.id = id;
      //获取优惠券列表
      httpAction("/ShoeEvent/ShoeEvent/getCouponList", null, "get").then((res) => {
        if (res.success) {
          // this.couponList = res.result;

          this.couponList = res.result.map((item,index,arr)=>{
            let c = {label:item.name, value:item.couponId.toString()}
            return c;
          })

        }
      })
    },
    handleCancel() {
      this.visible = false;
    },
    handleSave() {
      let data = {
        "id": this.id,
        "couponId": this.selectedCoupon
      }
      httpAction("/ShoeEvent/ShoeEvent/updateEventBindingCoupon", data, "post").then((res) => {
        if (res.success) {
          this.$message.success(res.message);
          this.visible = false;
          this.$emit('ok');
        }
      })
      // console.log(this.selectedCoupon);
    }
  }
}
</script>

<style scoped>

</style>