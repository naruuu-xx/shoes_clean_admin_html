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
        v-model="selectOption"
        style="width: 200px;display: block;margin: 0 auto;"
        placeholder="选择卡包"
      >
        <a-select-option v-for="item in cardBagList" :value="item.cardBagId" :key="item.cardBagId">{{ item.name }}
        </a-select-option>
      </a-select>

      <div style="margin: 30px 0"></div>
      <a-button type="primary" @click="handleSave" style="display: block;margin: 0 auto;">保存</a-button>
    </div>
  </j-modal>
</template>

<script>
import {getAction, httpAction} from "../../../../api/manage";

export default {
  name: "CouponSelectModal",
  data() {
    return {
      title: "自动派发卡包设置",
      width: 400,
      visible: false,
      couponList: [],
      selectedCoupon: "",
      selectOption:"",
      cardBagList: [],
      id: ""
    }
  },
  created() {

  },
  methods: {
    // filterOption(input, option) {
    //   return (
    //     option.componentOptions.children[0].text.toLowerCase().indexOf(input.toLowerCase()) >= 0
    //   );
    // },
    show(id, couponId) {
      this.visible = true;
      this.selectOption = +couponId;
      this.id = id;
      //获取优惠券列表
      getAction("/shoes/ShoeCardBag/queryAllCardBagList", null).then((res) => {
        if (res.success) {
          this.cardBagList = res.result;
        }
      })
    },
    handleCancel() {
      this.visible = false;
    },
    handleSave() {
      console.log("///////")
      let data = {
        "id": this.id,
        "couponId": this.selectOption
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