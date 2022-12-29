<template>
  <div class="page-header-index-wide">
    <a-row :gutter="24">
      <a-col :sm="24" :md="24" :xl="8" :style="{ marginBottom: '24px' }">
        <div class="box">
          <div class="box-item">
            <div class="box-item-title">总销售量</div>
            <div class="box-item-value">¥12345.6</div>
            <div class="box-item-foot">月同比</div>
          </div>
          <div class="box-item">
            <div class="box-item-title">月销售量</div>
            <div class="box-item-value">¥12345.6</div>
            <div class="box-item-foot">周同比</div>
          </div>
          <div class="box-item">
            <div class="box-item-title">日销售量</div>
            <div class="box-item-value">¥12345.6</div>
            <div class="box-item-foot">日同比</div>
          </div>
        </div>
      </a-col>
      <a-col :sm="24" :md="24" :xl="8" :style="{ marginBottom: '24px' }">
        <div class="box">
          <div class="box-item">
            <div class="box-item-title">总销售量</div>
            <div class="box-item-value">¥12345.6</div>
            <div class="box-item-foot">月同比</div>
          </div>
          <div class="box-item">
            <div class="box-item-title">月销售量</div>
            <div class="box-item-value">¥12345.6</div>
            <div class="box-item-foot">周同比</div>
          </div>
          <div class="box-item">
            <div class="box-item-title">日销售量</div>
            <div class="box-item-value">¥12345.6</div>
            <div class="box-item-foot">日同比</div>
          </div>
        </div>
      </a-col>
      <a-col :sm="24" :md="24" :xl="8" :style="{ marginBottom: '24px' }">
        <div class="box">
          <div class="box-item">
            <div class="box-item-title">总销售量</div>
            <div class="box-item-value">¥12345.6</div>
            <div class="box-item-foot">月同比</div>
          </div>
          <div class="box-item">
            <div class="box-item-title">月销售量</div>
            <div class="box-item-value">¥12345.6</div>
            <div class="box-item-foot">周同比</div>
          </div>
          <div class="box-item">
            <div class="box-item-title">日销售量</div>
            <div class="box-item-value">¥12345.6</div>
            <div class="box-item-foot">日同比</div>
          </div>
        </div>
      </a-col>
    </a-row>

    <a-row>
      <div class="status">
        <div class="status-box" v-for="(status, idx) in satusList" :key="idx">
          <div class="status-box-name">{{ status.name }}</div>
          <div class="status-box-value">{{ status.value }}</div>
        </div>
      </div>
    </a-row>

    <a-row>
      <a-col :sm="24" :md="12" :xl="12" :style="{ marginBottom: '24px' }">
        <div class="withdraw">
          <div class="withdraw-title">提现待审核</div>
          <div class="withdraw-main">
            <div class="withdraw-main-item">
              <div class="withdraw-main-item-name">投资人</div>
              <div class="withdraw-main-item-value">2</div>
            </div>
            <div class="withdraw-main-item">
              <div class="withdraw-main-item-name">投资人</div>
              <div class="withdraw-main-item-value">2</div>
            </div>
            <div class="withdraw-main-item">
              <div class="withdraw-main-item-name">投资人</div>
              <div class="withdraw-main-item-value">2</div>
            </div>
          </div>
        </div>
      </a-col>
      <a-col :sm="24" :md="12" :xl="12" :style="{ marginBottom: '24px' }">
        <div class="withdraw">
          <div class="withdraw-title">提现待审核</div>
          <div class="withdraw-main">
            <div class="withdraw-main-item">
              <div class="withdraw-main-item-name">投资人</div>
              <div class="withdraw-main-item-value">2</div>
            </div>
            <div class="withdraw-main-item">
              <div class="withdraw-main-item-name">投资人</div>
              <div class="withdraw-main-item-value">2</div>
            </div>
            <div class="withdraw-main-item">
              <div class="withdraw-main-item-name">投资人</div>
              <div class="withdraw-main-item-value">2</div>
            </div>
          </div>
        </div>
      </a-col>
    </a-row>

    <a-card :loading="loading" :bordered="false" :body-style="{ padding: '0' }">
      <div class="salesCard">
        <div class="tab">
          <div class="tab-left">
            <div class="tab-left-item" :class="{active: type.value == barQuery.type}" v-for="(type,idx) in typeList" :key="idx" @click="onTab('type',type.value)">{{ type.name }}</div>
          </div>
          <div class="tab-right">
            <div class="tab-right-item" :class="{active: type.value == barQuery.time}" v-for="(type,idx) in timeList" :key="idx" @click="onTab('time',type.value)">{{ type.name }}</div>
          </div>
        </div>
        <a-row>
          <a-col :xl="24" :lg="24" :md="24" :sm="24" :xs="24">
            <bar title="销售额排行" :dataSource="barData" yaxisText="销售额"/>
          </a-col>
        </a-row>
        <a-row :gutter="24">
          <a-col :xl="8" :lg="12" :md="12" :sm="24" :xs="24">
            <div>
              <div class="rankings">
              <div class="rankings-title">商品排行</div>
              <div class="rankings-main">
                <div class="rankings-main-cell" v-for="(good, idx) in goodRankingList" :key="idx">
                  <div class="rankings-main-cell-name">{{ idx + 1 }} {{ good.name }}</div>
                  <div class="rankings-main-cell-value">{{ good.value }}</div>
                </div>
              </div>
            </div>
            </div>
          </a-col>
          <a-col :xl="8" :lg="12" :md="12" :sm="24" :xs="24">
            <div>
              <div class="rankings">
              <div class="rankings-title">机柜排行</div>
              <div class="rankings-main">
                <div class="rankings-main-cell" v-for="(good, idx) in goodRankingList" :key="idx">
                  <div class="rankings-main-cell-name">{{ idx + 1 }} {{ good.name }}</div>
                  <div class="rankings-main-cell-value">{{ good.value }}</div>
                </div>
              </div>
            </div>
            </div>
          </a-col>
          <a-col :xl="8" :lg="12" :md="12" :sm="24" :xs="24">
            <div>
              <div class="rankings">
              <div class="rankings-title">站点排行</div>
              <div class="rankings-main">
                <div class="rankings-main-cell" v-for="(good, idx) in goodRankingList" :key="idx">
                  <div class="rankings-main-cell-name">{{ idx + 1 }} {{ good.name }}</div>
                  <div class="rankings-main-cell-value">{{ good.value }}</div>
                </div>
              </div>
            </div>
            </div>
          </a-col>
        </a-row>
      </div>
    </a-card>
  </div>
</template>

<script>
import ChartCard from '@/components/ChartCard'
import ACol from 'ant-design-vue/es/grid/Col'
import ATooltip from 'ant-design-vue/es/tooltip/Tooltip'
import MiniArea from '@/components/chart/MiniArea'
import MiniBar from '@/components/chart/MiniBar'
import MiniProgress from '@/components/chart/MiniProgress'
import RankList from '@/components/chart/RankList'
import Bar from '@/components/chart/Bar'
import LineChartMultid from '@/components/chart/LineChartMultid'
import HeadInfo from '@/components/tools/HeadInfo.vue'

import Trend from '@/components/Trend'
import { getLoginfo, getVisitInfo } from '@/api/api'

const rankList = []
for (let i = 0; i < 7; i++) {
  rankList.push({
    name: '白鹭岛 ' + (i + 1) + ' 号店',
    total: 1234.56 - i * 100,
  })
}
const barData = []
for (let i = 0; i < 12; i += 1) {
  barData.push({
    x: `${i + 1}月`,
    y: Math.floor(Math.random() * 1000) + 200
  })
}
export default {
  name: 'IndexChart',
  components: {
    ATooltip,
    ACol,
    ChartCard,
    MiniArea,
    MiniBar,
    MiniProgress,
    RankList,
    Bar,
    Trend,
    LineChartMultid,
    HeadInfo,
  },
  data() {
    return {
      loading: true,
      center: null,
      rankList,
      barData,
      loginfo: {},
      visitFields: ['ip', 'visit'],
      visitInfo: [],
      indicator: <a-icon type="loading" style="font-size: 24px" spin />,
      satusList: [
        {
          name: 'daifuj',
          value: 1,
        },
        {
          name: 'daifuj',
          value: 1,
        },
        {
          name: 'cscscddcd',
          value: 1,
        },
        {
          name: 'daifuj',
          value: 1,
        },
        {
          name: 'csdcsdcdscds',
          value: 1,
        },
        {
          name: 'daifcdscuj',
          value: 1,
        },
        {
          name: 'dacsdcsdcifuj',
          value: 1,
        },
        {
          name: 'daicdfuj',
          value: 1,
        },
        {
          name: 'daifuj',
          value: 1,
        },
        {
          name: 'dacdscsdifuj',
          value: 1,
        },
        {
          name: 'daifuj',
          value: 1,
        },
      ],
      goodRankingList: [
        {
          name: 'cdcds',
          value: 12,
        },
        {
          name: 'cdcds',
          value: 12,
        },
        {
          name: 'cdcds',
          value: 12,
        },
        {
          name: 'cdcds',
          value: 12,
        },
        {
          name: 'cdcds',
          value: 12,
        },
        {
          name: 'cdcds',
          value: 12,
        },
      ],
      barQuery:{
        type:'order',
        time:'day'
      },
      typeList:[
        {
          name:'订单数',
          value:'order'
        },
        {
          name:'销售额',
          value:'sale'
        },
      ],
      timeList:[
        {
          name:'今日',
          value:'day'
        },
        {
          name:'本月',
          value:'month'
        },
        {
          name:'本年',
          value:'year'
        },
      ]
    }
  },
  created() {
    setTimeout(() => {
      this.loading = !this.loading
    }, 1000)
    this.initLogInfo()
  },
  methods: {
    // 点击tab
    onTab(type,value) {
      this.barQuery[type] = value
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
  },
}
</script>

<style lang="less" scoped>
main {
  color: #333;
}
.box {
  display: flex;
  justify-content: space-around;
  background-color: #fff;
  padding: 20px 0;
  position: relative;
  &::before,
  &::after {
    position: absolute;
    display: block;
    content: '';
    height: calc(100% - 40px);
    background-color: #d6d6d6;
    width: 1px;
  }
  &::before {
    left: 33.33%;
  }
  &::after {
    left: 66.66%;
  }
  &-item {
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
  color: #3b98ff;
}

.rankings {
  padding: 20px 32px 0 32px;
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
      padding: 0 24px;
      cursor: pointer;
    }
  }
  &-right {
    display: flex;
    &-item {
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