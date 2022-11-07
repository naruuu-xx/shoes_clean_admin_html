<template>
  <a-card :bordered="false">
    <div>
      <span>取件范围</span><br/>
      <span>上门取件范围:<a-input-number  placeholder="输入距离" id="takeRange" v-model="takeRange" style="width: 150px" :min="0" />km(以快递柜为中心,半径多少km可取件)</span>
    </div>
    <a-divider />
    <div>
      <span>配送费设置</span><br/>
      <span>(1)用户配送费</span><br/>
      <span>在配送范围内每单配送费为<a-input-number  placeholder="输入金额" style="width: 150px" v-model="userCourierCost" :min="0" />元。</span><br/>
      <span>满<a-input-number  placeholder="输入金额" style="width: 150px" v-model="courierReduce" :min="0" />元免配送费。</span><br/>
      <span>(2)配送员配送费</span><br/>
      <span>同一订单第一双鞋配送费为<a-input-number  placeholder="输入金额" style="width: 150px" v-model="courierCost" :min="0" />元,每增加一双鞋增加配送费为
        <a-input-number  placeholder="输入金额" style="width: 150px" v-model="courierCostIncrease" :min="0" />元。
      </span>
    </div>
    <a-divider />
    <div>
      <span>提现设置</span><br/>
      <span>余额冻结天数:<a-input-number  placeholder="输入天数" style="width: 150px" v-model="freezingTime" :min="0" />天</span><br/>
    </div>
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
      freezingTime: 0,// 冻结天数
    }
  },
  created() {
  },
  mounted(){
    this.getShoeConfig();
  },
  computed: {
  },
  methods: {
    // 获取基础信息
    getShoeConfig(){
      const that = this;
      httpAction("/ShoeConfig/shoeConfig/showShoeCourierConfig", "", "get").then((res)=> {
        let resultList = res.result;
        for(let i  = 0 ; i < resultList.length; i ++) {
          // takeRange 取件范围
          if("takeRange" == resultList[i].name){
            that.takeRange = resultList[i].value;
          }
          // userCourierCost 用户配送费
          if("userCourierCost" == resultList[i].name){
            that.userCourierCost = resultList[i].value;
          }
          // courierReduce 配送费满免金额
          if("courierReduce" == resultList[i].name){
            that.courierReduce = resultList[i].value;
          }
          // courierCost 配送员配送费(同一订单)
          if("courierCost" == resultList[i].name){
            that.courierCost = resultList[i].value;
          }
          // courierCostIncrease 配送员配送额外增加费（每增加一双鞋增加多少配送费）（分）
          if("courierCostIncrease" == resultList[i].name){
            that.courierCostIncrease = resultList[i].value;
          }
          // freezingTime 冻结天数
          if("freezingTime" == resultList[i].name){
            that.freezingTime = resultList[i].value;
          }
        }
      })
    },
    // 保存按钮
    save(){
      const that = this;

      let dataList = [{"name": "takeRange", "value": that.takeRange},
                      {"name": "userCourierCost", "value": that.userCourierCost},
                      {"name": "courierReduce", "value": that.courierReduce},
                      {"name": "courierCost", "value": that.courierCost},
                      {"name": "courierCostIncrease", "value": that.courierCostIncrease},
                      {"name": "freezingTime", "value": that.freezingTime}];
      let param = {"shoeLockerConfigList":dataList};
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
</style>