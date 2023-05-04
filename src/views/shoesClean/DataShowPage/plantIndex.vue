<template>
  <div class="page-header-index-wide">
    <a-row :gutter="24">
      <a-col :sm="24" :md="24" :xl="12" :style="{ marginBottom: '24px' }">
        <div class="box">
          <div class="box-title">入库统计</div>
          <div class="box-main">
            <div class="box-item" v-for="(item,idx) in dataObj.quantityOfSale" :key="idx">
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
            <div class="box-item" v-for="(item,idx) in dataObj.orderForm" :key="idx">
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
              <img class="box-item-i-img" :src="item.icon"></img>
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
            <div class="tab-right-main">
              <div
              class="tab-right-main-item"
              :class="{ active: type.value == barQuery.time.value }"
              v-for="(type, idx) in timeList"
              :key="idx"
              @click="onTab('time', type)"
              >
                {{ type.name }}
              </div>
            </div>
            <a-range-picker @change="onChangeDate" />
            
          </div>
        </div>
        <a-row>
          <div class="tabbar">
            <div class="tabbar-item" v-for="(item,idx) in incomingShoes" :key="idx">
              <div class="tabbar-item-title">{{ item.name }}</div>
              <div class="tabbar-item-value">{{ item.num }}</div>
            </div>
          </div>
        </a-row>
        <div class="title">
          出库鞋数
        </div>
        <a-row>
          <div class="tabbar">
            <div class="tabbar-item" v-for="(item,idx) in incomingShoes" :key="idx">
              <div class="tabbar-item-title">{{ item.name }}</div>
              <div class="tabbar-item-value">{{ item.num }}</div>
            </div>
          </div>
        </a-row>
        <a-row>
          <a-col :xl="12" :lg="12" :md="24" :sm="24" :xs="24">
            <a-spin :spinning="spinning">
              <bar
                :title="`${barQuery.time.name}${barQuery.type.name}排行`"
                :dataSource="barData"
                :yaxisText="barQuery.type.name"
                color="#48CAF0"
              />
            </a-spin>

          </a-col>
          <a-col :xl="12" :lg="12" :md="24" :sm="24" :xs="24">
            <a-spin :spinning="spinning">
              <bar
                :title="`${barQuery.time.name}${barQuery.type.name}排行`"
                :dataSource="barData"
                :yaxisText="barQuery.type.name"
                color="#FFBB00"
              />
            </a-spin>
          </a-col>
        </a-row>
      </div>
    </a-card>
    <BrandStatistics></BrandStatistics>
  </div>
</template>

<script>
import Bar from './components/Bar'
import Pie from './components/Pie'
import BrandStatistics from './components/BrandStatistics'
import { getLoginfo, getVisitInfo } from '@/api/api'
import { getAction } from '@/api/manage'
export default {
  name: 'ShoeAnalysis',
  components: {
    Bar,
    Pie,
    BrandStatistics
  },
  data() {
    return {
      loading: true,
      center: null,
      barData:[],
      loginfo: {},
      visitFields: ['ip', 'visit'],
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
      typeList: [
        {
          name: '订单数',
          value: 'order',
        },
        {
          name: '销售额',
          value: 'sale',
        },
      ],
      timeList: [
        {
          name: '今日',
          value: 'day',
        },
        {
          name: '昨日',
          value: 'yesterday',
        },
        {
          name: '本月',
          value: 'month',
        },
        {
          name: '上月',
          value: 'lastMonth',
        },
        {
          name: '全年',
          value: 'year',
        },
      ],
      dataObj: {
        // 销售量
        quantityOfSale: [], // 订单量
        orderForm: [], // 用户数
        numberOfUsers: [], // 状态列表
        statuslist: [], //
        withdrawCheckPending: [], // 提现待审核
        withdrawToBeConfirmed: [], // 提现待确认
      },
      spinning: false,
      pieData:[
        { item: '配送', count: 0 },
        { item: '自提', count: 0 },
        { item: '快递', count: 0 },
        { item: '站点', count: 0 }
      ],
      factoryShoes:[
        {
          name:'总鞋数',
          icon:require('@/assets/data-shoe.png'),
          color:'#39C9C9',
          num:'102'
        },
        {
          name:'机柜',
          icon:require('@/assets/data-cabinet.png'),
          color:'#FFB673',
          num:'102'
        },
        {
          name:'站点',
          icon:require('@/assets/data-site.png'),
          color:'#FC456C',
          num:'102'
        },
        {
          name:'快递',
          icon:require('@/assets/data-express.png'),
          color:'#48CAF0',
          num:'102'
        },
        {
          name:'其他',
          icon:require('@/assets/data-else.png'),
          color:'#21C3BC',
          num:'102'
        },
      ],
      incomingShoes:[
        {
          name:'总鞋数',
          num: 164
        },
        {
          name:'机柜',
          num: 164
        },
        {
          name:'站点',
          num: 164
        },
        {
          name:'快递',
          num: 164
        },
        {
          name:'候鸟',
          num: 164
        },
      ]
    }
  },
  created() {

    // this.initLogInfo()
    this.getIndexUp()
    this.getIndexDown()
  },
  methods: {
    
    onChangeDate(date, dateString) {
      console.log(date, dateString);
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
    // 点击tab
    onTab(type, value) {
      this.barQuery[type] = value
      this.getIndexDown()
    },
    initLogInfo() {
      getLoginfo(null).then((res) => {
        if (res.success) {
          Object.keys(res.result).forEach((key) => {
            res.result[key] = res.result[key] + ''
          })
          this.loginfo = res.result
        }
      })
      getVisitInfo().then((res) => {
        if (res.success) {
          this.visitInfo = res.result
        }
      })
    },
    //
    getIndexUp() {
      getAction('/indexUp').then((res) => {
        this.dataObj = res
      })
    },
    getIndexDown() {
      let type = this.barQuery.type.value
      let time = this.barQuery.time.value
      let form = {
        type,
        time
      }
      this.spinning = true
      getAction('/indexDown',form).then((res) => {
        if(res.success == false) return
        this.barData = res.barData
        this.rankingList = [
          {
            name:'商品',
            list:res.goodRankingList || []
          },
          {
            name:'机柜',
            list:res.lockerRankingList || []
          },
          {
            name:'站点',
            list:res.siteRankingList || []
          },
          {
            name:'站点自提',
            list:res.siteSelfRankingList || []
          },
        ]
        this.pieData = res.imgDtoArrayList.map(({type:item,num}) => ({
          item,count: parseFloat(num)
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
      padding-right: 90px;
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