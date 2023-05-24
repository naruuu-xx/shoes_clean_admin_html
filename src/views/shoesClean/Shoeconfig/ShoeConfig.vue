<template>
  <a-card :bordered="false">
    <div>
      <span>(1)</span> <br/>
      <a-space>满<a-input-number placeholder="输入金额" style="width: 60px" v-model="freeDeliveryFee" :min="0"
                              size="small"/>元免配送费。</a-space><br/>
      <a-space>满<a-input-number placeholder="输入金额" style="width: 60px" v-model="freeFreightFree" :min="0"
                              size="small"/>元免快递费。</a-space><br/>
      <br/>
      <a-button type="primary" @click="save(1)">提交</a-button>
      </div>
    <a-divider/>
    <div>
      <span>(2)</span><br/>
      <a-space>每个配送订单减<a-input-number placeholder="输入金额" style="width: 60px" v-model="discountDeliveryFee"
                                                    :min="0" size="small"/>元配送费，每个快递单减至原快递费的
        <a-input-number placeholder="输入金额" style="width: 60px" v-model="discountFreightFree" :min="0"
                        size="small"/>%
      </a-space><br/>
      <br/>
      <a-button type="primary" @click="save(2)">提交</a-button>
    </div>
    <a-divider/>

  </a-card>
</template>

<script>

import '@/assets/less/TableExpand.less';
import {httpAction} from "@api/manage";

export default {
  name: 'ShoeConfig',
  data() {
    return {
      description: 'shoe_config配送设置',
      freeDeliveryFee: 0,// 满多少免配送费
      freeFreightFree: 0,// 满多少免快递费
      discountDeliveryFee: 0,// 每个配送订单减多少配送费
      discountFreightFree: 0,// 每个快递单减原快递费的多少%
    }
  },
  created() {
  },
  mounted() {
    this.getShoeConfig();
  },
  computed: {},
  methods: {
    // 获取基础信息
    getShoeConfig() {
      const that = this;
      httpAction("/ShoeConfig/shoeConfig/getDeliveryAndFreight", "", "get").then((res) => {
        let result = res.result;
        that.freeDeliveryFee = result.freeDeliveryFee;
        that.freeFreightFree = result.freeFreightFree;
        that.discountDeliveryFee = result.discountDeliveryFee;
        that.discountFreightFree = result.discountFreightFree;

      })
    },
    // 保存按钮
    save(type) {
      const that = this;
      switch (type) {
        case 1:
          that.saveFree();
          break;
        case 2:
          that.saveDiscount();
          break;
      }
    },
    saveFree(){
      const that = this;
      let params = {
        freeDeliveryFee: that.freeDeliveryFee,
        freeFreightFree: that.freeFreightFree,
      };
      httpAction("/ShoeConfig/shoeConfig/setDeliveryAndFreightFree", params, "post").then((res) => {
        that.$message.success("保存成功");
      })
    },
    saveDiscount(){
      const that = this;
      let params = {
        discountDeliveryFee: that.discountDeliveryFee,
        discountFreightFree: that.discountFreightFree,
      };
      httpAction("/ShoeConfig/shoeConfig/setDeliveryAndFreightDiscount", params, "post").then((res) => {
        that.$message.success("保存成功");
      })
    }
  }
}
</script>
<style scoped>
@import '~@assets/less/common.less';

span {
  display: block;
}
</style>