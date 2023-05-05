<template>
  <a-card :bordered="false">
    <a-row>
      <a-col :xs="24" :sm="24" :md="6">签到周期:<a-input-number v-model="period" placeholder="请输入签到周期" @change="v => period = isNaN(parseInt(v)) ? 1 : parseInt(v)" :min="1"/>天</a-col>
      <a-col :xs="24" :sm="24" :md="18">
        <a-space>
          <a-button>确定</a-button>
          <a-button>重置</a-button>
        </a-space>
      </a-col>
    </a-row>

    <a-row>
      <div class="table">
        <table border="1px" cellpadding="10px">
          <tr>
            <th>天数</th>
            <th v-for="(val,idx) in integral" :key="idx">第{{idx+1}}天</th>
          </tr>
          <tr>
            <td>积分值</td>
            <td v-for="(val,idx) in integral" :key="idx">
              <a-input-number v-model="integral[idx]" placeholder="请输入积分值" @change="v => integral[idx] = isNaN(parseInt(v)) ? 1 : parseInt(v)" :min="0"/>
            </td>
          </tr>
        </table>
        <table border="1px" cellpadding="10px">
          <tr><th>天数</th><th>姓名</th><th>年龄</th></tr>
          <tr><td>积分值</td><td>憨憨</td><td>21</td></tr>
        </table>
      </div>
    </a-row>

    <a-row>
      <a-space>
        <span>特殊天数设置:</span>
        <a-button>新增</a-button>
      </a-space>
    </a-row>
  </a-card>
</template>

<script>


  export default {
    name: 'ShoeCouponList',
    mixins:[],
    components: {

    },
    data () {
      return {
        period:'',
        integral:[
          0,0,0,0,0,0,0
        ]
      }
    },
    created() {

    },
    computed: {
      
    },
    methods: {
      
    }
  }
</script>
<style scoped>
  @import '~@assets/less/common.less';
  table,th,td {
    border-color: #f5f5f5;
  }
  .table {
    text-align: center;
    
  }
</style>