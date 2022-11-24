<template>
  <a-card :bordered="false">
    <div>
<!--      <span>收益百分比</span><br/>-->
      <span>收益百分比：<a-input-number  placeholder="输入百分比" id="percentageOfRevenue" v-model="percentageOfRevenue" style="width: 150px" :min="0" size="small" /></span>
    </div>
    <a-button type="primary" @click="save">保存</a-button>
  </a-card>
</template>
<script>
import { httpAction } from '@api/manage'

export default {
  name: 'ShoeInvestorsConfig',
  data() {
    return {
      description: 'shoe_config受益设置',
      dictOptions: {},
      percentageOfRevenue: 0,// 收益百分比
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
      httpAction("/ShoeConfig/shoeConfig/ShoeInvestorsConfig", "", "get").then((res)=> {
        let resultList = res.result;
        for(let i  = 0 ; i < resultList.length; i ++) {
          // percentageOfRevenue 收益百分比
          if("percentageOfRevenue" == resultList[i].name){
            that.percentageOfRevenue = resultList[i].value;
          }
        }
      })
    },
    // 保存按钮
    save(){
      const that = this;

      let dataList = [{"name": "percentageOfRevenue", "value": that.percentageOfRevenue}];
      let param = {"shoeLockerConfigList":dataList};
      httpAction("/ShoeConfig/shoeConfig/saveShoeInvestorsConfig", param, "post").then((res) => {
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

</style>