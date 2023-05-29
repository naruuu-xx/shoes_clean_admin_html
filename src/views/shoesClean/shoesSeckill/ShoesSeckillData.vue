<template>
  <div class="page-header-index-wide">

    <a-card :loading="loading" :bordered="false" :body-style="{ padding: '0' }">
      <div class="salesCard">
        <div class="tab">
          <div class="tab-left title">
            入库鞋数
          </div>
          <div class="tab-right">
            <xf-date-filter @change="changeFilterDate"></xf-date-filter>
            
          </div>
        </div>
        <a-row>
          <a-spin :spinning="spinning">
            <xfLine title="出库数折线图" :dataSource="outHistogram" alias="出库数" color="#FFBB00"></xfLine>
            <DLine :dataSource="dataSource"></DLine>
          </a-spin>
        </a-row>
      </div>
    </a-card>
  </div>
</template>

<script>
import xfLine from './components/Line'
import DLine from './components/DLine'
import xfDateFilter from './components/xfDateFilter'
import { getAction } from '@/api/manage'
export default {
  name: 'ShoeAnalysis',
  components: {
    xfDateFilter,
    xfLine,
    DLine
  },
  data() {
    return {
     xljgData: [],
      xljgFields:['y'],
      aliases:[{field:'y',alias:'入库数'}],
      loading: false,
      center: null,
      inHistogram:[],
      outHistogram:[{
        x:'02日',
        y:2
      },{
        x:'03日',
        y:4
      }],
      visitInfo: [],
      indicator: <a-icon type="loading" style="font-size: 24px" spin />,
      rankingList:[], // 排行的列表
      barQuery: {
        type: {
          name: '订单数',
          value: 'order',
        },
        time: {
          name: '今日',
          value: 'day',
        },
      },
      spinning: false,
      pieData:[],
      // 入库统计
      warehousingStatistics:[
        {
          name:'总入库数(单)',
          num:0
        },
        {
          name:'本月入库数(单)',
          num:0
        },
        {
          name:'今日入库数(单)',
          num:0
        },
      ],
      
      // 出库统计
      outboundStatistics:[
        {
          name:'总出库数(单)',
          num:0
        },
        {
          name:'本月出库数(单)',
          num:0
        },
        {
          name:'今日出库数(单)',
          num:0
        },
      ],
      inOfStorageCount:[],
      outOfStorageCount:[],
      queryForm:{
        dateType: 'today',
        startTime: '',
        endTime: '',
        selectType: 'day'
      },
      dataSource:[
        { y: '1', k: 7.0, London: 3.9 },
        { y: '2', k: 6.9, London: 4.2 },
        { y: '3', k: 9.5, London: 5.7 },
        { y: '4', k: 14.5, London: 8.5 },
        { y: '5', k: 18.4, London: 11.9 },
        { y: '6', k: 21.5, London: 15.2 },
        { y: '7', k: 25.2, London: 17.0 },
        { y: '8', k: 26.5, London: 16.6 },
        { y: '9', k: 23.3, London: 14.2 },
        { y: '10', k: 18.3, London: 10.3 },
        { y: '11', k: 13.9, London: 6.6 },
        { y: '12', k: 9.6, London: 4.8 },
      ],
    }
  },
  created() {
    // this.factoryIndexUp()
    // this.getIndexDown()
  },
  methods: {
    
    changeFilterDate(val) {
      // this.queryForm = val
      // this.getIndexDown()
    },
    // 点击
    onClickw(status,val) {
      if(+val.num == 0) return
      let url = ''
      switch (val.name) {
        case '投资人':
          url = '/shoesClean/ShoeInvestors/ShoeInvestorsWithdrawalList'
          break;
        case '配送员':
          url = '/courierWithdrawal/list'
          break;

        default:
          break;
      }
      this.$router.push(`${url}?status=${status}`)
    },
    //
    factoryIndexUp() {
      getAction('/factoryIndexUp').then(({success,result}) => {
        if(success) {
          this.warehousingStatistics[0].num = result.totalInOfStorage
          this.warehousingStatistics[1].num = result.monthInOfStorage
          this.warehousingStatistics[2].num = result.todayInOfStorage
          this.outboundStatistics[0].num = result.totalOutOfStorage
          this.outboundStatistics[1].num = result.monthOutOfStorage
          this.outboundStatistics[2].num = result.todayOutOfStorage
        }
      })
    },
    getIndexDown() {
      this.spinning = true
      getAction('/factoryIndexDown',this.queryForm).then((res) => {
        if(res.success == false) return
        this.inOfStorageCount = res.result.inOfStorageCount
        this.outOfStorageCount = res.result.outOfStorageCount
        this.inHistogram = res.result.inHistogram || []
        this.outHistogram = res.result.outHistogram || []
        this.pieData = res.result.brandPieChart || []
        this.xljgData = res.result.inHistogram.map(({x:type,y}) => ({
          type,y
        }))

      }).finally(s => {
        this.spinning = false
        this.loading = false
      })
    }

  },
}
</script>

<style lang="less" scoped>

main {
  color: #333;
}
.box {
  background-color: #fff;
  &-title {
    padding: 19px 20px;
    border-bottom: #ddd solid 1px;
  }
  &-main {
    display: flex;
    padding: 18px 0;
    // min-width: 500px;
    overflow-x: scroll;
  }
  &-item {
    flex: 1;
    border-right: #ddd solid 1px;
    display: flex;
    flex-direction: column;
    align-content: center;
    justify-content: center;
    text-align: center;
    &:last-child {
      border-right-width: 0px;
    }
    &-title {
      font-size: 14px;
      font-weight: 400;
      color: rgba(0,0,0,0.65);
      line-height: 22px;
    }
    &-value {
      font-size: 30px;
      font-weight: 400;
      color: rgba(0,0,0,0.85);
      line-height: 38px;
    }
    &-foot {
      font-size: 10px;
    }
  }
  &-item-i {
    flex: 1;
    flex-shrink: 0;
    min-width: 170px;
    border-right: #ddd solid 1px;
    display: flex;
    align-content: center;
    justify-content: center;
    text-align: center;
    &-img {
      width: 90px;
      height: 90px;
    }
    &-main {
      display: flex;
      flex-direction: column;
      justify-content: center;
      align-items: flex-start;
      &-value {
        font-size: 30px;
        font-family: PingFangSC-Regular, PingFang SC;
        font-weight: 400;
        color: #39C9C9;
        line-height: 38px;
      }
    }
    &:last-child {
      border-right-width: 0px;
    }
    &-title {
      font-size: 14px;
      font-weight: 400;
      color: rgba(0,0,0,0.65);
      line-height: 22px;
    }
    &-value {
      font-size: 30px;
      font-weight: 400;
      color: rgba(0,0,0,0.85);
      line-height: 38px;
    }
    &-foot {
      font-size: 10px;
    }
  }
}

.status {
  overflow-x: scroll;
  display: flex;
  margin-bottom: 24px;
  background-color: #fff;
  &-box {
    flex-shrink: 0;
    padding: 0 24px;
    text-align: center;
    &-name {
      padding-top: 8px;
      font-size: 16px;
      color: #a0a0a0;
    }
    &-value {
      padding: 8px 0;
      font-weight: 500;
      font-size: 26px;
    }
  }
}

.withdraw {
  background-color: #fff;
  &-title {
    padding-top: 8px;
    font-weight: 600;
    font-size: 14px;
    margin-top: 8px;
  }
  &-main {
    display: flex;
    justify-content: center;
    min-width: 300px;
    &-item {
      padding: 0 24px;
      text-align: center;
      &-name {
        font-size: 16px;
        color: #a0a0a0;
      }
      &-value {
        padding: 8px 0;
        font-weight: 500;
        font-size: 26px;
      }
    }
  }
}

.active {
  color: #3b98ff !important;
}

.tab {
  display: flex;
  justify-content: space-between;
  border-bottom: 1px solid #e3e3e3;
  &-left {
    display: flex;
    &-item {
      padding: 0 24px;
      cursor: pointer;
    }
  }
  &-right {
    display: flex;
    align-items: center;
    padding-right: 20px;
    &-main {
      display: flex;
      &-item {
        font-size: 14px;
        color: rgba(0,0,0,0.65);
        line-height: 20px;
        padding: 0 12px;
        cursor: pointer;
      }
    }
  }
}

.title {
  padding:18px 0 18px 20px;
  font-size: 16px;
  font-weight: 600;
  color: #333333;
  line-height: 16px;
}

.tabbar {
  // min-width: 500px;
  overflow-x: scroll;
  display: flex;
  &::after {
    content: '';
    height: 54px;
    display: block;
    background-color: #F5F5F5;
    flex: 1;
  }
  &-item {
    flex-shrink: 0;
    border-bottom: 1px solid #e3e3e3;
    &:first-child{
      
      .tabbar-item-title {
        color: #397AFF !important;
        padding-left: 20px;
      }
      .tabbar-item-value {
        padding-left: 20px;
      }
      
    }
    &-title {
      background: #F5F5F5;
      padding: 16px 0;
      padding-right: 40px;
      font-size: 16px;
      font-weight: 500;
      line-height: 22px;
    }
    &-value {
      padding: 12px 0;
    }
  }
}

.circle-cust {
  position: relative;
  top: 28px;
  left: -100%;
}
.extra-wrapper {
  line-height: 55px;
  padding-right: 24px;

  .extra-item {
    display: inline-block;
    margin-right: 24px;

    a {
      margin-left: 24px;
    }
  }
}

/* 首页访问量统计 */
.head-info {
  position: relative;
  text-align: left;
  padding: 0 32px 0 0;
  min-width: 125px;

  &.center {
    text-align: center;
    padding: 0 32px;
  }

  span {
    color: rgba(0, 0, 0, 0.45);
    display: inline-block;
    font-size: 0.95rem;
    line-height: 42px;
    margin-bottom: 4px;
  }
  p {
    line-height: 42px;
    margin: 0;
    a {
      font-weight: 600;
      font-size: 1rem;
    }
  }
}
</style>