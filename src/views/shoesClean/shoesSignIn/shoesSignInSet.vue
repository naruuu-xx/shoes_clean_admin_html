<template>
  <a-spin tip="请求中..."  :spinning="loading">
  <a-card :bordered="false">
    <a-row>
      <a-col :xs="24" :sm="24" :md="6">
        <a-space>
          签到周期:
          <a-input-number @blur="periodBlur" v-model="period" placeholder="请输入签到周期"
          @change="v => period = isNaN(parseInt(v)) ? 1 : parseInt(v)" :min="1" />天
        </a-space>
      </a-col>
      <a-col :xs="24" :sm="24" :md="18">
        <a-space>
          <a-button @click="onReset">重置</a-button>
        </a-space>
      </a-col>
    </a-row>

    <a-row>
      <div class="table">
        <table border="1px" cellpadding="10px" v-for="(integral, integralIdx) in integralList2" :key="integralIdx">
          <tr>
            <th>天数</th>
            <th v-for="(val, idx) in integral" :key="idx">第{{ toChineseNum(integralIdx * 7 + idx + 1)}}天</th>
          </tr>
          <tr>
            <td>积分值</td>
            <td v-for="(val, idx) in integral" :key="idx">
              <a-input-number v-model="integral[idx].integra" placeholder="请输入积分值"
                @change="v => integral[idx].integra = isNaN(parseInt(v)) ? 1 : parseInt(v)" :min="0" />
            </td>
          </tr>
        </table>
      </div>
    </a-row>

    <a-row>
      <a-space>
        <span>特殊天数设置:</span>
        <!-- <a-button @click="onAddSpecialDay" type="primary" :disabled="addSpecialDayDisabled">新增</a-button> -->
        <a-button @click="onAddSpecialDay" type="primary">新增</a-button>
      </a-space>
    </a-row>

    <a-row v-for="(specialDay,idx) in specialDays" :key="idx">
      <div class="specialDays">
        <div class="specialDays-top" :data-idx="`(${idx+1})`">
          <a-space>
            第<a-input-number @blur="specialDayBlur(idx,specialDays[idx].day)" v-model="specialDays[idx].day" placeholder="请输入天数" @change="v => specialDays[idx].day = isNaN(parseInt(v)) ? 1 : parseInt(v)" :min="1" />天
          </a-space>
          <a-space style="margin-left: 24px;">
            <a-button @click="onAddCoupon(idx)" type="primary" :disabled="specialDays[idx].day == '' || (!!specialDays[idx].coupons.length && specialDays[idx].coupons.some(coupon => coupon.id == ''))">新增</a-button>
            <a-button @click="onDelSpecialDay(idx)" type="danger">删除</a-button>
          </a-space>
        </div>
        <!-- <div class="specialDays-sub">
          <span style="flex-shrink: 0;margin-right: 16px;">描述:</span> <a-input v-model="specialDays[idx].describe"></a-input>
        </div> -->
        <div class="specialDays-table">
          <a-table bordered :columns="columns" :data-source="specialDays[idx].coupons" :pagination="false" rowKey="uuid">
            <div slot="type" slot-scope="text, record, tableIdx">
              <a-select v-model="specialDays[idx].coupons[tableIdx].type"  style="width: 240px" :options="typeOptions" @change="changeType(idx,tableIdx)">
              </a-select>
            </div>
            <div slot="id" slot-scope="text, record, tableIdx">
              <XfSelect
                :additionalData="{idx,tableIdx}"
                :list="specialDays[idx].coupons[tableIdx].weekList"
                @change="checkedSelect($event,idx,tableIdx,record.type)"
                @changeList="changeSelect"
                v-model="specialDays[idx].coupons[tableIdx].id"
                :url='`/shoes/shoeUser/getCouponOrCardBagOrTimecard?type=${specialDays[idx].coupons[tableIdx].type}`'
                style="width: 80%;"
              >
              </XfSelect>
            </div>
            <div slot="num" slot-scope="text, record, tableIdx">
              <a-input-number v-model="specialDays[idx].coupons[tableIdx].num" placeholder="请输入数量"
                @change="v => specialDays[idx].coupons[tableIdx].num = isNaN(parseInt(v)) ? 1 : parseInt(v)" :min="1" />
            </div>
            <span slot="action" slot-scope="text, record,tableIdx">
              <a-button type="link" style="color: #ff4d4f" @click="onDelCoupon(idx,tableIdx)">
                删除
              </a-button>
            </span>
          </a-table>
        </div>
      </div>
    </a-row>

    <a-row style="margin-top: 20px;">
      <div style="margin-bottom: 12px;">签到规则:</div>
      <JEditor v-model="rule" placeholder="请输入签到规则"></JEditor>
    </a-row>

    <div class="btns">
      <a-space>
        <a-button @click="onCancel">取消</a-button>
        <a-button type="primary" @click="onSave">保存</a-button>
      </a-space>
    </div>
  </a-card>
</a-spin>
</template>

<script>

import {toChineseNum} from '@/utils/util'
import XfSelect from '@/components/Xf/XfSelect'
import {httpAction,getAction} from "@api/manage";
export default {
  name: 'ShoeCouponList',
  mixins: [],
  components: {
    XfSelect
  },
  data() {
    return {
      loading: false,
      period: '',
      integralList2: [],
      integralList:[],
      columns:[
        {
          title:'类型',
          align:"center",
          dataIndex: 'type',
          scopedSlots: { customRender: 'type' },
          width: '140px'
        },
        {
          title:'名称',
          align:"center",
          dataIndex: 'id',
          scopedSlots: { customRender: 'id' },
        },
        {
          title:'数量',
          align:"center",
          dataIndex: 'num',
          scopedSlots: { customRender: 'num' },
          width: '120px'
        },
        {
          title: '操作',
          align:"center",
          scopedSlots: { customRender: 'action' },
          width: '120px'
        },
      ],
      specialDays:[],
      typeOptions:[
        {
          label:'优惠券',
          value:'0'
        },
        {
          label:'卡包',
          value:'1'
        }
      ],
      weekList:[],
      rule:''
    }
  },
  created() {
    this.getShoeSign()
  },
  computed: {
    addSpecialDayDisabled() {
      return this.period == '' || !!this.specialDays.length && this.specialDays.some(specialDay => {
        return specialDay.day == '' || (!specialDay.coupons.length || specialDay.coupons.some(coupon => coupon.id == ''))
      })
    }
  },
  watch: {
    period: {
      handler(val) {

      }
    },
    specialDays:{
      handler(val) {
        // console.log(99999,val);
      },
      immediate:true,
      deep:true
    }
  },
  methods: {
    getShoeSign() {
      this.loading = true
      // /
      getAction("shoeSign/show").then((res) => {
        this.loading = false
        if(res.success) {
          this.period = res.result.length
          this.integralList = res.result
          this.integralList2 = this.chunk(this.integralList, 7)
          this.specialDays = this.integralList.filter(item => item.coupons.length).map(item => ({
            ...item,
            coupons: item.coupons.map(cou => ({
              ...cou,
              id:+cou.id,
              uuid:this.getUuid(),
              weekList:[],
              oldWeekList:[{
                name: cou.name,
                id:+cou.id
              }]
            })),
            
          }))
        }
        
      })
      getAction("/shoeSign/getSignRule").then((res) => {
        if(res.success) {
          this.rule = res.result
        }
        
      })
    },
    getUuid() {
      return Math.random().toString(16).substring(2)
    },
    checkedSelect(val,idx,tableIdx,type) {
      let coupons = [...this.specialDays[idx].coupons]
      coupons.splice(tableIdx,1)
      if(coupons.filter(coupon => coupon.type == type).findIndex(item => item.id == val) != -1) {
        this.$message.error('当前特殊天数有选中重复的优惠券或者卡包!')
        setTimeout(()=>{
          this.specialDays[idx].coupons[tableIdx].id = ''
        },0)
      }
    },
    changeSelect(data,additionalData) {
      let arr = data.records
      let oldArr = this.specialDays[additionalData.idx].coupons[additionalData.tableIdx].oldWeekList || []
      if(oldArr.length) {
        arr = [...arr.filter(item => item.id != oldArr[0].id),...oldArr]
        this.specialDays[additionalData.idx].coupons[additionalData.tableIdx].oldWeekList = []
      }
      this.specialDays[additionalData.idx].coupons[additionalData.tableIdx].weekList = arr.map(item => ({
        label: item.name,
        value: +item.id
      }));
    },
    changeType(idx,tableIdx) {
      this.specialDays[idx].coupons[tableIdx].id = ''
    },
    // 添加优惠券或者卡包
    onAddCoupon(idx) {
      this.specialDays[idx].coupons.push(
        {
          type:'0', // 优惠券
          id:'',
          uuid:this.getUuid(),
          num:1, // 数量
          weekList:[]
        }
      )
    },
    // 删除优惠券或者卡包
    onDelCoupon(idx,tableIdx) {
      this.specialDays[idx].coupons.splice(tableIdx, 1)
    },
    // 
    specialDayBlur(idx,val) {
      let specialDays = [...this.specialDays]
      specialDays.splice(idx,1)
      let findIndex = specialDays.findIndex(item => item.day == val)
      if(val <= this.period && (specialDays.length ? findIndex == -1 : true)) {

      } else {
        this.$message.error('输入的天数大于最大天数或者已有重复的!')
        this.specialDays[idx].day = ''
      }
    },
    // 删除特殊天数
    onDelSpecialDay(idx) {
      let integralListIdx = this.specialDays[idx].day - 1
      if(this.integralList[integralListIdx]) {
        this.integralList[integralListIdx].coupons = []
      }
      this.specialDays.splice(idx, 1)
      // 
    },
    // 添加`特殊天数
    onAddSpecialDay() {
      this.specialDays.push(
        {
          day:'', // 天数
          // describe:'',
          coupons:[]
        }
      )
    },
    // 连续签到天数移除焦点
    periodBlur() {
      let oldArr = this.integralList2.flat()
      let oldArrLength = oldArr.length
      this.integralList = new Array(parseInt(this.period)).fill(0).map((item, idx) => {
        if (oldArrLength > idx) {
          return oldArr[idx]
        } else {
          return {
            day: idx+1,
            integra: 0, // 积分
            // describe: '',
            coupons: []
          }
        }

      })
      this.integralList2 = this.chunk(this.integralList, 7)
    },
    // 点击重置
    onReset() {
      this.period = ''
      this.integralList = []
      this.integralList2 = []
      this.specialDays = []
    },
    chunk(array, size) {
      let result = []
      let x = 0
      for (let x = 0; x < Math.ceil(array.length / size); x++) {
        let start = x * size
        let end = start + size
        result.push(array.slice(start, end))
      }
      return result
    },
    onCancel() {
      this.$router.go(-1)
    },
    onSave() {
      console.log(333,this.integralList);
      for (let index = 0; index < this.specialDays.length; index++) {
        const specialDay = this.specialDays[index];
        console.log(1111,specialDay);
        const day = specialDay.day
        const coupons = specialDay.coupons
        if(day == '') {
          return this.$message.error('有特殊天时间未填写!')
        }
        if(coupons.some(coupon => coupon.id == '')) {
          return this.$message.error('有优惠券或者卡包没选择!')
        }

      }
      this.specialDays.forEach((item,idx) => {
        let coupons = item.coupons.map(({id,num,type}) => ({
          id,num,type
        }))
        this.integralList[item.day-1].coupons = coupons
        // this.integralList[item.day-1].describe = item.describe
        this.integralList[item.day-1].day = item.day
      })
      this.loading = true
      httpAction('shoeSign/updateOrAdd',this.integralList,'post').then(res => {
        if(res.success) {
          this.$message.success(res.message)
        } else {
          this.$message.error(res.message)
        }
        this.loading = false
      })
      httpAction('shoeSign/signRule',{rule:this.rule},'put').then(res => {
        if(res.success) {
          this.$message.success(res.message)
        }
        this.loading = false
      })
    },
    toChineseNum
  }
}
</script>
<style scoped lang="less">
@import '~@assets/less/common.less';
.btns {
  display: flex;
  justify-content: center;
  margin-top: 20px;
}

table,
th,
td {
  border-color: #f5f5f5;
}
table {
  border: solid #f5f5f5;
  border-width: 1px 1px 1px 1px;
}

th {
  min-width: 64px;
}

.table {
  text-align: center;
  margin: 20px 0;
  overflow-x: scroll;
  max-width: 844px;
}

.specialDays {
  margin-left: 34px;
  width: 770px;
  &-top {
    margin: 20px 0;
    position: relative;
    &::after {
      position: absolute;
      content: attr(data-idx);
      top: 50%;
      transform: translateY(-50%);
      left: -24px;
    }
  }
  &-sub {
    display: flex;
    margin-bottom: 20px;
    align-items: center;
  }
  &-table {
    
  }

}


</style>