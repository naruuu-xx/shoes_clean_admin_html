<template>
  <div class="page-header-index-wide">
    <a-row :gutter="24">
      <a-col :sm="24" :md="24" :xl="12" :style="{ marginBottom: '24px' }">
        <div class="box">
          <div class="box-title">入库统计</div>
          <div class="box-main">
            <div class="box-item" v-for="(item,idx) in warehousingStatistics" :key="idx">
              <div class="box-item-title">{{ item.name }}</div>
              <div class="box-item-value">{{ item.num }}</div>
            </div>
          </div>
        </div>
      </a-col>
      <a-col :sm="24" :md="24" :xl="12" :style="{ marginBottom: '24px' }">
        <div class="box">
          <div class="box-title">出库统计</div>
          <div class="box-main">
            <div class="box-item" v-for="(item,idx) in outboundStatistics" :key="idx">
              <div class="box-item-title">{{ item.name }}</div>
              <div class="box-item-value">{{ item.num }}</div>
            </div>
          </div>
        </div>
      </a-col>
    </a-row>

    <a-row :gutter="24">
      <a-col :sm="24" :md="24" :xl="24" :style="{ marginBottom: '24px' }">
        <div class="box">
          <div class="box-title">工厂鞋数</div>
          <div class="box-main">
            <div class="box-item-i" v-for="(item,idx) in factoryShoes" :key="idx">
              <img class="box-item-i-img" :src="item.icon" />
              <div class="box-item-i-main">
                <div class="box-item-i-main-title">{{ item.name }}</div>
                <div class="box-item-i-main-value" :style="{color:item.color}">{{ item.num }}</div>
              </div>
            </div>
          </div>
        </div>
      </a-col>
    </a-row>

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
          <div class="tabbar">
            <div class="tabbar-item" v-for="(item,idx) in inOfStorageCount" :key="idx">
              <div class="tabbar-item-title">{{ item.platformName }}</div>
              <div class="tabbar-item-value">{{ item.count }}</div>
            </div>
          </div>
        </a-row>
        <div class="title">
          出库鞋数
        </div>
        <a-row>
          <div class="tabbar">
            <div class="tabbar-item" v-for="(item,idx) in outOfStorageCount" :key="idx">
              <div class="tabbar-item-title">{{ item.platformName }}</div>
              <div class="tabbar-item-value">{{ item.count }}</div>
            </div>
          </div>
        </a-row>
        <a-row>
          <a-col :xl="12" :lg="12" :md="24" :sm="24" :xs="24">
            <a-spin :spinning="spinning">
              <xfLine title="入库数折线图" :dataSource="inHistogram" alias="入库数" color="#48CAF0"></xfLine>
            </a-spin>

          </a-col>
          <a-col :xl="12" :lg="12" :md="24" :sm="24" :xs="24">
            <a-spin :spinning="spinning">
              <xfLine title="出库数折线图" :dataSource="outHistogram" alias="出库数" color="#FFBB00"></xfLine>
            </a-spin>
          </a-col>
        </a-row>
      </div>
    </a-card>
    <BrandStatistics :pieData="pieData" :queryForm="queryForm" :spinningPie="spinning"></BrandStatistics>
  </div>
</template>

<script>
import Bar from './components/Bar'
import Pie from './components/Pie'
import xfLine from './components/Line'
import BrandStatistics from './components/BrandStatistics'
import xfDateFilter from './components/xfDateFilter'
import { getAction } from '@/api/manage'
export default {
  name: 'ShoeAnalysis',
  components: {
    Bar,
    Pie,
    BrandStatistics,
    xfDateFilter,
    xfLine
  },
  data() {
    return {
     xljgData: [],
      xljgFields:['y'],
      aliases:[{field:'y',alias:'入库数'}],
      loading: false,
      center: null,
      inHistogram:[],
      outHistogram:[],
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
      factoryShoes:[
        {
          name:'总鞋数',
          icon:require('@/assets/data-shoe.png'),
          color:'#39C9C9',
          num:0
        },
        {
          name:'机柜',
          icon:require('@/assets/data-cabinet.png'),
          color:'#FFB673',
          num:0
        },
        {
          name:'站点',
          icon:require('@/assets/data-site.png'),
          color:'#FC456C',
          num:0
        },
        {
          name:'快递',
          icon:require('@/assets/data-express.png'),
          color:'#48CAF0',
          num:0
        },
        {
          name:'其他',
          icon:require('@/assets/data-else.png'),
          color:'#21C3BC',
          num:0
        },
      ],
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
      }
    }
  },
  created() {
    this.factoryIndexUp()
    this.getIndexDown()
  },
  methods: {
    
    changeFilterDate(val) {
      this.queryForm = val
      this.getIndexDown()
    },
    // 点击
    onClickw(status,val) {
      if(+val.num == 0) return
      let url = ''
      switch (val.name) {
        case '受益人':
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
          this.factoryShoes[0].num = result.totalRetention
          this.factoryShoes[1].num = result.lockerRetention
          this.factoryShoes[2].num = result.siteRetention
          this.factoryShoes[3].num = result.expressageRetention
          this.factoryShoes[4].num = result.otherRetention
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