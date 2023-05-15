<template>
  <div class="page-header-index-wide">
    <a-row :gutter="24">
      <a-col :sm="24" :md="24" :xl="8" :style="{ marginBottom: '24px' }">
        <div class="box">
          <div class="box-item" v-for="(item,idx) in dataObj.quantityOfSale" :key="idx">
            <div class="box-item-title">{{ item.name }}</div>
            <div class="box-item-value">¥{{ item.num }}</div>
            <!-- <div class="box-item-foot">
              月同比 {{ item.YoY }}% <a-icon :type="item.state == 'increase' ? 'caret-up' : 'caret-down'" :style="{ color: item.state == 'increase' ? '#0dbc79' : 'red' }" />
            </div> -->
          </div>
        </div>
      </a-col>
      <a-col :sm="24" :md="24" :xl="8" :style="{ marginBottom: '24px' }">
        <div class="box">
          <div class="box-item" v-for="(item,idx) in dataObj.orderForm" :key="idx">
            <div class="box-item-title">{{ item.name }}</div>
            <div class="box-item-value">{{ item.num }}</div>
          </div>
        </div>
      </a-col>
      <a-col :sm="24" :md="24" :xl="8" :style="{ marginBottom: '24px' }">
        <div class="box">
          <div class="box-item" v-for="(item,idx) in dataObj.numberOfUsers" :key="idx">
            <div class="box-item-title">{{ item.name }}</div>
            <div class="box-item-value">{{ item.num }}</div>
          </div>
        </div>
      </a-col>
    </a-row>

    <!-- <a-row>
      <div class="status">
        <div class="status-box" v-for="(status, idx) in dataObj.statuslist" :key="idx" @click="onClickOrder(status)">
          <div class="status-box-name">{{ status.name }}</div>
          <div class="status-box-value">{{ status.num }}</div>
        </div>
      </div>
    </a-row> -->

    <div class="title">
      订单状态统计
    </div>
    <a-row style="margin-bottom: 20px;">
      <div class="tabbar">
        <div class="tabbar-item" v-for="(item,idx) in dataObj.statuslist" :key="idx" @click="onClickOrder(item)">
          <div class="tabbar-item-title">{{ item.name }}</div>
          <div class="tabbar-item-value">{{ item.num }}</div>
        </div>
      </div>
    </a-row>

    <a-card :loading="loading" :bordered="false" :body-style="{ padding: '0' }">
      <div class="salesCard">
        <div class="tab">
          <div class="title" style="border-bottom-color: transparent;padding: 0;line-height: 32px">
            <!-- 平台新增用户 -->
          </div>
          <div class="tab-right">
            <xf-date-filter @change="changeFilterDate" :timeList="timeList"  defaultDateType="day"></xf-date-filter>
          </div>
        </div>
        <a-row>
          <a-col :xl="16" :lg="12" :md="24" :sm="24" :xs="24">
            <a-spin :spinning="spinning">
              <div class="bar">
                <xfLine :dataSource="barUserData" alias="用户数" color="#fcdc5b"></xfLine>
              </div>
            </a-spin>
          </a-col>
          <a-col :xl="8" :lg="10" :md="24" :sm="24" :xs="24">
            <a-spin :spinning="spinning">
              <div style="padding-top: 20px;">
                <Pie v-if="pieUserData.length" :height="268" :dataSource="pieUserData"/>
                <a-empty v-if="!pieUserData.length"/>
              </div>
            </a-spin>
          </a-col>
        </a-row>
        <div class="tab" style="border-top: 1px solid #DDDDDD;border-bottom: 1px solid #DDDDDD;">
          <div class="tab-left">
            <div
              class="tab-left-item"
              :class="{ active: type.value == barQuery.type.value }"
              v-for="(type, idx) in typeList"
              :key="idx"
              @click="onTab('type', type)"
            >
              {{ type.name }}
            </div>
          </div>
        </div>
        <a-row>
          <a-col :xl="16" :lg="12" :md="24" :sm="24" :xs="24">
            <a-spin :spinning="spinning">
              <div class="bar">
                <xfLine :dataSource="barData" :alias="barQuery.type.name"></xfLine>
              </div>
            </a-spin>

          </a-col>
          <a-col :xl="8" :lg="10" :md="24" :sm="24" :xs="24">
            <a-spin :spinning="spinning">
              <div style="padding-top: 20px;">
                <Pie :height="268" :dataSource="pieData" v-if="pieData.length"/>
                <a-empty v-if="!pieData.length"/>
              </div>
            </a-spin>
          </a-col>
        </a-row>
        <a-divider />
        <a-row>
          <a-col :xl="6" :lg="12" :md="12" :sm="24" :xs="24" v-for="(ranking,idx) in rankingList" :key="idx">
            <div>
              <div class="rankings">
                <div class="rankings-title">{{ranking.name}}{{ barQuery.type.name }}排行</div>
                <a-spin :spinning="spinning">
                  <div class="rankings-main">
                    <div class="rankings-main-cell" v-for="(good, idx) in ranking.list" :key="idx">
                      <a-tooltip :title="good.name">
                        <div class="rankings-main-cell-name u-line-1">{{ idx + 1 }} {{ good.name }}</div>
                      </a-tooltip>
                      <div class="rankings-main-cell-value"> {{barQuery.type.name == '销售额' ? '¥' : ''}}{{ good.num }}</div>
                    </div>
                    <a-empty v-if="!ranking.list.length"/>
                  </div>
                </a-spin>
              </div>
            </div>
          </a-col>
        </a-row>
      </div>
    </a-card>
    <BrandStatistics :pieData="pieBrandData" :queryForm="queryForm" :spinningPie="spinning" type="index"></BrandStatistics>
    <a-row :gutter="24">
          <a-col :sm="24" :md="12" :xl="12" :style="{ marginBottom: '24px' }">
            <div class="withdraw">
              <div class="withdraw-title">提现待审核</div>
              <div class="withdraw-main">
                <div class="withdraw-main-item" @click="onClickw('0',item)" v-for="(item, idx) in dataObj.withdrawCheckPending" :key="idx">
                  <div class="withdraw-main-item-name">{{ item.name }}</div>
                  <div class="withdraw-main-item-value" :style="{color: +item.num > 0 ? '#3b98ff' : '#333'}">{{ item.num }}</div>
                </div>
              </div>
            </div>
          </a-col>
          <a-col :sm="24" :md="12" :xl="12" :style="{ marginBottom: '24px' }">
            <div class="withdraw">
              <div class="withdraw-title">提现待确认</div>
              <div class="withdraw-main">
                <div class="withdraw-main-item" @click="onClickw('1',item)" v-for="(item, idx) in dataObj.withdrawToBeConfirmed" :key="idx">
                  <div class="withdraw-main-item-name">{{ item.name }}</div>
                  <div class="withdraw-main-item-value" :style="{color: +item.num > 0 ? '#3b98ff' : '#333'}">{{ item.num }}</div>
                </div>
              </div>
            </div>
          </a-col>
        </a-row>
  </div>
</template>

<script>
import Bar from './components/Bar'
import Pie from './components/Pie'
import xfLine from './components/Line'
import BrandStatistics from './components/BrandStatistics'
import { getLoginfo, getVisitInfo } from '@/api/api'
import { getAction } from '@/api/manage'
import xfDateFilter from './components/xfDateFilter'
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
          name: '订单数(件)',
          value: 'order',
        },
        {
          name: '销售额(元)',
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
          name: '本年',
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
      pieData:[],
      pieBrandData:[],
      barUserData:[],
      pieUserData:[],
      startTime:'',
      endTime:'',
      pickTime: null,
      queryForm:{
        dateType: 'day',
        startTime: '',
        endTime: '',
        selectType: 'day'
      }
    }
  },
  created() {

    // this.initLogInfo()
    this.getIndexUp()
    this.getIndexDown()
  },
  methods: {
    changeFilterDate(val) {
      this.queryForm = val
      this.getIndexDown()
    },
    onChangeDate(date,dateString) {
      this.startTime = dateString[0]
      this.endTime = dateString[1]
    },
    // 点击订单状态
    onClickOrder(val) {
      this.$router.push({ name: 'order-list', params: { status: [val.status+'']}})
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
      let time = this.queryForm.dateType
      let form = {
        ...this.queryForm,
        type,
        time
      }
      this.spinning = true
      getAction('/indexDown',form).then((res) => {
        if(res.success == false) return
        this.barData = res.barData
        this.barUserData = res.userList
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
            name:'站点配送',
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
        this.pieUserData = res.imgDtoUserList.map(({type:item,num}) => ({
          item,count: parseFloat(num)
        }))
        this.pieBrandData = res.imgDtoBrandList.map(({type:item,num}) => ({
          item,count: parseFloat(num)
        })).sort((a,b) => b.count-a.count)

      }).finally(s => {
        this.spinning = false
        this.loading = false
      })
    }

  },
}
</script>

<style lang="less" scoped>
.bar {
  padding-top: 40px;
}
.title {
  padding:18px 0 18px 20px;
  font-size: 16px;
  font-weight: 600;
  color: #333333;
  line-height: 16px;
  background: #fff;
  border-bottom: 1px solid #DDDDDD;
}

.tabbar {
  // min-width: 500px;
  overflow-x: scroll;
  display: flex;
  background: #fff;
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
        cursor: pointer;
        color: #3b98ff;
    }
  }
}

main {
  color: #333;
}
.box {
  display: flex;
  background-color: #fff;
  padding: 20px 0;
  position: relative;
  overflow-x: scroll;
  // &::before,
  // &::after {
  //   position: absolute;
  //   display: block;
  //   content: '';
  //   height: calc(100% - 40px);
  //   background-color: #d6d6d6;
  //   width: 1px;
  // }
  // &::before {
  //   left: 33.33%;
  // }
  // &::after {
  //   left: 66.66%;
  // }
  &-item {
    flex: 1;
    text-align: center;
    border-right: solid 1px #d6d6d6;
    min-width: 150px;
    &:last-child {
      border-right-color: transparent;
    }
    &-title {
      font-size: 12px;
      color: #a0a0a0;
    }
    &-value {
      
      font-weight: 500;
      font-size: 26px;
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
    padding: 16px 20px;
    font-weight: 600;
    font-size: 14px;
    margin-top: 20px;
    border-bottom: 1px solid #DDDDDD;
  }
  &-main {
    display: flex;
    justify-content: center;
    min-width: 300px;
    &-item {
      margin: 16px 0;
      flex: 1;
      text-align: center;
      border-right: solid 1px #d6d6d6;
      min-width: 120px;
      &:last-child {
        border-right-color: transparent;
      }
      &-name {
        font-size: 14px;
        font-family: PingFangSC-Regular, PingFang SC;
        font-weight: 400;
        color: rgba(0,0,0,0.65);
        line-height: 22px;
      }
      &-value {
        padding-top: 4px;
        font-size: 26px;
        font-size: 30px;
        font-family: PingFangSC-Regular, PingFang SC;
        font-weight: 400;
        color: rgba(0,0,0,0.85);
        line-height: 38px;
      }
    }
  }
}

.active {
  color: #3b98ff;
  &::before {
    width: 100% !important;
    height: 2px;
    background-color: #3b98ff !important;
    bottom: -11px;
  }
}

.rankings {
  padding: 0 20px;
  margin-top: 20px;
  background-color: #fff;
  min-height: 334px;
  color: #333;
  border-right: 1px solid #e3e3e3;
  &-title {
    margin-bottom: 12px;
    text-align: center;
    font-size: 18px;
    font-weight: 900;
  }
  &-main {
    &-cell {
      display: flex;
      justify-content: space-between;
      margin: 16px 0;
      font-size: 16px;
      &-name {
        padding-right: 40px;
      }
      &-value {
      }
    }
  }
}

.tab {
  display: flex;
  justify-content: space-between;
  padding: 10px 24px;
  border-bottom: 1px solid #e3e3e3;
  &-left {
    display: flex;
    &-item {
      margin: 0 24px;
      cursor: pointer;
      position: relative;
      &::before {
        content: '';
        position: absolute;
        display: block;
        width: 0;
        background-color: transparent;
        bottom: -11px;
        transition: width 0.3s;
      }
    }
  }
  &-right {
    display: flex;
    &-item {
      line-height: 28px;
      padding: 0 24px;
      cursor: pointer;
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