<template>
  <a-card :bordered="false">
<!--    <div>-->
<!--      <a-space>取件范围</a-space><br/>-->
<!--      <br/>-->
<!--      <a-space>用户下单时匹配<a-input-number placeholder="输入距离" id="takeRange" v-model="takeRange" style="width: 60px"-->
<!--                                         :min="0" size="small"/>km范围内的机柜</a-space>-->
<!--    </div>-->
<!--    <a-divider/>-->
    <div>
      <a-space>配送费设置</a-space><br/>
      <br/>
      <span>(1)用户配送费</span><br/>
      <br/>
      <a-space>在配送范围内每单配送费为<a-input-number placeholder="输入金额" style="width: 60px"
                                                    v-model="userCourierCost" :min="0" size="small"/>元。</a-space><br/>

      <br/>
      <span>(2)配送员配送费</span>
      <br/>
      <br/>
      <a-space>(2.1)取鞋配送费</a-space><br/>
      <br/>
      <a-space>同一订单第一双鞋配送费为<a-input-number placeholder="输入金额" style="width: 60px" v-model="courierCost"
                                                    :min="0" size="small"/>元,每增加一双鞋增加配送费为
        <a-input-number placeholder="输入金额" style="width: 60px" v-model="courierCostIncrease" :min="0"
                        size="small"/>元。
      </a-space>
      <br/>
      <br/>
      <a-space>(2.2)送鞋配送费</a-space><br/>
      <br/>
      <a-space>一双鞋配送费为<a-input-number placeholder="输入金额" style="width: 60px" v-model="courierSendCost" :min="0"
                                          size="small"/>元
      </a-space>
    </div>
    <a-divider/>
    <div>
      <span>提现设置</span>
      <br/>
      <br/>
      <a-space>余额冻结天数:<a-input-number placeholder="输入天数" style="width: 60px" v-model="freezingTime" :min="0"
                                         size="small"/>天</a-space><br/>
    </div>
    <br/>
    <a-button type="primary" @click="save">保存</a-button>
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
      dictOptions: {},
      takeRange: 0,// 取件范围
      userCourierCost: 0,// 用户配送费
      courierReduce: 0,// 配送费满免金额
      courierCost: 0,// 配送员配送费(同一订单)
      courierCostIncrease: 0,// 配送员配送额外增加费（每增加一双鞋增加多少配送费）（分）
      courierSendCost: 0,//配送员送鞋配送费（同一订单）
      freezingTime: 0,// 冻结天数
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
      httpAction("/ShoeConfig/shoeConfig/showShoeCourierConfig", "", "get").then((res) => {
        let resultList = res.result;
        for (let i = 0; i < resultList.length; i++) {
          // takeRange 取件范围
          if ("takeRange" == resultList[i].name) {
            that.takeRange = resultList[i].value;
          }
          // userCourierCost 用户配送费
          if ("userCourierCost" == resultList[i].name) {
            that.userCourierCost = resultList[i].value;
          }
          // courierReduce 配送费满免金额
          if ("courierReduce" == resultList[i].name) {
            that.courierReduce = resultList[i].value;
          }
          // courierCost 配送员配送费(同一订单)
          if ("courierCost" == resultList[i].name) {
            that.courierCost = resultList[i].value;
          }
          // courierCostIncrease 配送员配送额外增加费（每增加一双鞋增加多少配送费）（分）
          if ("courierCostIncrease" == resultList[i].name) {
            that.courierCostIncrease = resultList[i].value;
          }
          // courierSendCost 配送员送鞋配送费（同一订单）
          if ("courierSendCost" == resultList[i].name) {
            that.courierSendCost = resultList[i].value;
          }
          // freezingTime 冻结天数
          if ("freezingTime" == resultList[i].name) {
            that.freezingTime = resultList[i].value;
          }
        }
      })
    },
    // 保存按钮
    save() {
      const that = this;

      let dataList = [{"name": "takeRange", "value": that.takeRange},
        {"name": "userCourierCost", "value": that.userCourierCost},
        {"name": "courierReduce", "value": that.courierReduce},
        {"name": "courierCost", "value": that.courierCost},
        {"name": "courierCostIncrease", "value": that.courierCostIncrease},
        {"name": "courierSendCost", "value": that.courierSendCost},
        {"name": "freezingTime", "value": that.freezingTime}];
      let param = {"shoeLockerConfigList": dataList};
      httpAction("/ShoeConfig/shoeConfig/saveShoeCourierConfig", param, "post").then((res) => {
        if (res.success) {
          that.$message.success(res.message);
        } else {
          that.$message.warning(res.message);
        }
      })
    },
  }
}
</script>
<style scoped>
@import '~@assets/less/common.less';

a-space {
  display: block;
}
</style>