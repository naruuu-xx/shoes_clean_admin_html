<template>
  <div class="page-header-index-wide">
    <a-card style="height: 100vh">
      <a-row>
        <a-col :span="24" style="font-size: 30px;font-weight: bold;margin-bottom: 30px;">
          &nbsp;鞋蜂欢迎您！
        </a-col>
      </a-row>
      <a-row style="margin-bottom: 10px">
        <a-col :span="24">
          &nbsp;&nbsp;鞋蜂总部设立于美丽的鹫岛之城-厦门，厦门是国务院批复确定的中国经济特区和东南沿海重要的中心城市、港口及风景旅游城市。
          <br/>
          &nbsp;&nbsp;鞋蜂，是以城市新基建5G智慧洗护工厂为依托，通过互联网洗护类生产服务平台结合运用“C2B2F+鞋蜂蜂箱”模式，进行都市年轻群体鞋子洗护的自主创新品牌。以洗护链接为入口，打造高校、公寓综合服务中心，延伸上下产业链，打通鞋靴全生命周期管理，实现智慧洗鞋服务。
        <br/>
          &nbsp;&nbsp;未来，鞋蜂不断优化运营模式和工艺流程，以人为本，开放包容，优选国内外顶级洗护产品，注重洗护品质，降低环境污染，并致力于绿色环保、循环经济，为我国早日实现碳中和，为行业的进步和经济的发展贡献自身的力量!
        </a-col>
      </a-row>
      <a-row style="margin-bottom: 10px">
        <a-col :span="24">
          1.团队
          <br/>
          &nbsp;&nbsp;蜂鞋创始团队来自阿里、字节、快手等头部互联网公司的连续创业者，人才密度高，已获得多个受益人、机构青睐。
        </a-col>
      </a-row>
      <a-row style="margin-bottom: 10px">
        <a-col :span="24">
          2工厂
          <br/>
          &nbsp;&nbsp;本地自营千平5G智慧洗鞋工厂，国内首条标准化洗鞋产业流水线，日吞吐量最高可达五千双，实现行业最快24H内出库。
        </a-col>
      </a-row>
      <a-row style="margin-bottom: 10px">
        <a-col :span="24">
          3.运营
          <br/>
          &nbsp;&nbsp;自主品牌、商标，运营团队年轻、富有激情，懂私域，擅长各种新媒体平台运营。
        </a-col>
      </a-row>
      <a-row style="margin-bottom: 10px">
        <a-col :span="24">
          4.技术
          <br/>
          &nbsp;&nbsp;与国内知名高校--华侨大学建立产学研合作，共同研发“互联网+洗鞋”标准化智能管理系统，实现“C2B2F+鞋蜂蜂箱”模式落地及不断创新。
        </a-col>
      </a-row>
      <a-row style="margin-bottom: 10px">
        <a-col :span="24">
          5.服务
          <br/>
          &nbsp;&nbsp;专业物流团队结合自主开发配送APP，实现24H全天配送响应;十余位匠人多年洗护行业经验，不断更新洗护技术，用心洗好每一双鞋。
        </a-col>
      </a-row>
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
import { getAction } from '@/api/manage'
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
      barData:[],
      loginfo: {},
      visitFields: ['ip', 'visit'],
      visitInfo: [],
      indicator: <a-icon type="loading" style="font-size: 24px" spin />,
      goodRankingList: [],
      lockerRankingList:[],
      siteRankingList:[],
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
          name: '本月',
          value: 'month',
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
      spinning: false
    }
  },
  created() {

    // this.initLogInfo()
    // this.getIndexUp()
    // this.getIndexDown()
  },
  methods: {
    // 点击订单状态
    onClickOrder(val) {
      this.$router.push(`/order/list?status=${val.status}`)
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
        console.log(777,res);
        if(res.success == false) return
        this.barData = res.barData
        this.goodRankingList = res.goodRankingList
        this.lockerRankingList = res.lockerRankingList
        // this.siteRankingList = res.siteRankingList

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