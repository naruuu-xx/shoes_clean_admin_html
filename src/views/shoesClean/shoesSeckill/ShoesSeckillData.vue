<template>
  <div class="page-header-index-wide">

    <a-card :loading="loading" :bordered="false" :body-style="{ padding: '0' }">
      <div class="salesCard">
        <div class="tab">
          <div class="tab-left title">
            时间筛选
          </div>
          <div class="tab-right">
            <xf-date-filter @change="changeFilterDate"></xf-date-filter>
          </div>
        </div>
        <a-row>
          <a-spin :spinning="nSpinning">
           <XfDataTypeFilter :filterList="numberAndSale" @change="changeNumberAndSale"></XfDataTypeFilter>
            <EchartsLine :dataSource="numberAndSaleDataSource" elementId="n"></EchartsLine>
          </a-spin>
        </a-row>

        <a-row>
          <a-spin :spinning="pSpinning">
           <XfDataTypeFilter :filterList="PVFilterList" @change="changePV"></XfDataTypeFilter>
            <EchartsLine :dataSource="PVDataSource" elementId="p"></EchartsLine>
          </a-spin>
        </a-row>

        <a-row>
          <a-spin :spinning="vSpinning">
           <XfDataTypeFilter :filterList="visitorCountFilterList" @change="changeVisitorCount"></XfDataTypeFilter>
            <EchartsLine :dataSource="visitorCountDataSource" elementId="v"></EchartsLine>
          </a-spin>
        </a-row>
      </div>
    </a-card>
  </div>
</template>

<script>
import XfSelect from '@/components/Xf/XfSelect'
import xfLine from './components/Line'
import DLine from './components/DLine'
import EchartsLine from './components/EchartsLine'
import XfDataTypeFilter from './components/XfDataTypeFilter'
import xfDateFilter from './components/xfDateFilter'
import { getAction } from '@/api/manage'
export default {
  name: 'ShoeAnalysis',
  components: {
    xfDateFilter,
    xfLine,
    DLine,
    XfSelect,
    XfDataTypeFilter,
    EchartsLine
  },
  data() {
    return {
      numberAndSale:[{
          label:'订单数折线图',
          value:[],
          type:'',
          selected: false,
          dataType: 'number'
        },
        {
          label:'销售额折线图',
          value:[],
          type:'',
          selected: false,
          dataType: 'sale'
        },
        {
          label:'单产品订单数',
          value:[],
          type:'select',
          selected: false,
          dataType: 'number'
        },
        {
          label:'单产品销售额',
          value:[],
          type:'select',
          selected: false,
          dataType: 'sale'
        },
      ],
      PVFilterList:[
        {
          label:'会场访问量',
          value:[],
          type:'',
          selected: false,
          dataType: 'exhibition'
        },
        {
          label:'产品总访问量',
          value:[],
          type:'',
          selected: false,
          dataType: 'detail'
        },
        {
          label:'单产品访问量',
          value:[],
          type:'select',
          selected: false,
          dataType: 'detail'
        },
      ],
      visitorCountFilterList:[
        {
          label:'会场访问人数',
          value:[],
          type:'',
          selected: false,
          dataType: 'exhibition'
        },
        {
          label:'产品总访问人数',
          value:[],
          type:'',
          selected: false,
          dataType: 'detail'
        },
        {
          label:'单产品访问人数',
          value:[],
          type:'select',
          selected: false,
          dataType: 'detail'
        },
      ],
      numberAndSaleData:{
        dataType: 'number',
        setList:'[]'
      },
      PVData:{
        dataType: 'exhibition',
        setList:'[]'
      },
      visitorCountData:{
        dataType: 'exhibition',
        setList:'[]'
      },
      loading: false,
      indicator: <a-icon type="loading" style="font-size: 24px" spin />,
      nSpinning: false,
      pSpinning: false,
      vSpinning: false,
      queryForm:{
        dateType: 'today',
        startTime: '',
        endTime: '',
        selectType: 'day'
      },
      dataSource:[
        { y: '1', k: 7.0, London: 7.0 },
        { y: '2', k: 6.9, London: 6.9 },
        { y: '3', k: 9.5, London: 9.5 },
        { y: '4', k: 14.5, London: 8.5 },
        { y: '5', k: 7, London: 11.9 },
        { y: '6', k: 21.5, London: 15.2 },
        { y: '7', k: 25.2, London: 17.0 },
        { y: '8', k: 26.5, London: 16.6 },
        { y: '9', k: 23.3, London: 14.2 },
        { y: '10', k: 18.3, London: 10.3 },
        { y: '11', k: 13.9, London: 6.6 },
        { y: '12', k: 9.6, London: 4.8 },
      ],
      productOrderIds:[],
      numberAndSaleDataSource:{
        x:[],
        y:[]
      },
      PVDataSource:{
        x:[],
        y:[]
      },
      visitorCountDataSource:{
        x:[],
        y:[]
      }
    }
  },
  created() {
    this.getAll()
  },
  
  methods: {
    changeNumberAndSale(val) {
      this.numberAndSaleData = val
      this.statistics()
    },
    changePV(val) {
      this.PVData = val
      this.getPv()
    },
    changeVisitorCount(val) {
      this.visitorCountData = val
      this.getUv()
    },
    changeFilterDate(val) {
      this.queryForm = val
      this.getAll()
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
    // 订单数/销售额
    statistics() {
      this.nSpinning
      getAction('/ShoeSeckill/shoeSeckill/statistics',{...this.queryForm,...this.numberAndSaleData}).then((res) => {
        if(res.success == false) return
        this.numberAndSaleDataSource = res.result
      }).finally(s => {
        this.nSpinning = false
        this.loading = false
      })
    },
    // 浏览量
    getPv() {
      this.pSpinning = true
      getAction('/ShoeSeckill/shoeSeckill/pv',{...this.queryForm,...this.PVData}).then((res) => {
        if(res.success == false) return
        this.PVDataSource = res.result
      }).finally(s => {
        this.pSpinning = false
        this.loading = false
      })
    },
    // 浏览量
    getUv() {
      this.vSpinning = true
      getAction('/ShoeSeckill/shoeSeckill/uv',{...this.queryForm,...this.visitorCountData}).then((res) => {
        if(res.success == false) return
        this.visitorCountDataSource = res.result
      }).finally(s => {
        this.vSpinning = false
        this.loading = false
      })
    },
    // 获取所有数据
    getAll() {
      this.statistics()
      this.getPv()
      this.getUv()
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