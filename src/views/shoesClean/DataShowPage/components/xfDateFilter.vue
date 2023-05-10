<!--
 * @Descripttion: your project
 * @version: 1.0
 * @Author: yizhimao
 * @Date: 2023-05-10 09:37:00
 * @LastEditors: yizhimao
 * @LastEditTime: 2023-05-10 10:17:22
-->
<!--  -->
<template>
  <div class='filter'>
    <div class="filter-main">
      <div
      class="filter-main-item"
      :class="{ active: type.value == dateType }"
      v-for="(type, idx) in timeList"
      :key="idx"
      @click="onTab(type.value)"
      >
        {{ type.name }}
      </div>
    </div>
    <a-select :options="dayOptions" v-model="selectType" style="width: 100px;margin: 0 32px;">
    </a-select>
    <div v-for="(op,idx) in dayOptions" :key="idx">
      <div v-if="selectType == op.value">
        <a-date-picker
          v-model="startTime"
          :disabled-date="disabledStartDate"
          :format="op.format"
          :mode="op.mode"
          placeholder="开始时间"
          :open="showStartPicker"
          @openChange="openChangeOne($event,'start')"
          @panelChange="panelChangeOne($event,'start')"
          style="width: 118px;"
        />
        -
        <a-date-picker
          v-model="endTime"
          :disabled-date="disabledEndDate"
          :format="op.format"
          :mode="op.mode"
          placeholder="结束时间"
          :open="showEndPicker"
          @openChange="openChangeOne($event,'end')"
          @panelChange="panelChangeOne($event,'end')"
          style="width: 118px;"
        />
      </div>
    </div>
    
  </div>
</template>

<script>
const dayjs = require('dayjs');
export default {
  //import引入的组件需要注入到对象中才能使用
  components: {},
  props:{
    timeList: {
      type:Array,
      // today=今日；yesterday=昨日；thisMonth=本月；lastMonth=上月；thisYear=本年；
      // day=今日；yesterday=昨日；month=本月；lastMonth=上月；year=本年；
      default:() =>([
        {
          name: '今日',
          value: 'today',
        },
        {
          name: '昨日',
          value: 'yesterday',
        },
        {
          name: '本月',
          value: 'thisMonth',
        },
        {
          name: '上月',
          value: 'lastMonth',
        },
        {
          name: '全年',
          value: 'thisYear',
        },
      ])
    },
  },
  data() {
    return {
      dateType:'today', // 时间类型
      dayOptions:[
        {
          label:'日',
          value:'day',
          mode:'date',
          format:'YYYY-MM-DD',
        },
        {
          label:'月',
          value:'month',
          mode:'month',
          format:'YYYY-MM',
        },
        {
          label:'年',
          value:'year',
          mode:'year',
          format:'YYYY',
        },
      ],
      selectType:'day', //选择器类型
      selectTypeObj: {
        label:'日',
        value:'day',
        mode:'date',
        format:'YYYY-MM-DD',
      },
      startTime:'',
      endTime:'',
      showStartPicker:false,
      showEndPicker:false
    };
  },
  computed: {
  },
  watch: {
    selectType(val) {
      this.selectTypeObj = this.dayOptions.find(item => item.value == val)
      this.startTime = ''
      this.endTime = ''
    },
    dateType(val) {
      if(val) {
        this.startTime = ''
        this.endTime = ''
        this.change()
      }
    },
    startTime(val,old) {
      let isChange =  dayjs(val).isSame(dayjs(old))
      if(val && !isChange && this.endTime) {
        this.change()
      }
    },
    endTime(val,old) {
      let isChange = dayjs(val).isSame(dayjs(old))
      if(val && !isChange && this.startTime) {
        this.change()
      }
    },
  },
  methods: {
     // 弹出日历和关闭日历的回调
    openChangeOne (status,type) {
      if(type == 'start') {
        this.showStartPicker = status
      } else {
        this.showEndPicker = status
      }
      
    },
    // 得到年份选择器的值
    panelChangeOne (value,type) {
      if(type == 'start') {
        this.startTime = value
        this.showStartPicker = false
      } else {
        this.endTime = value
        this.showEndPicker = false
      }
    },
    change() {
      if(this.startTime && this.endTime) {
        this.dateType = ''
      }
      this.$emit('change', {
        dateType: this.dateType,
        startTime: this.startTime ? dayjs(this.startTime).format(this.selectTypeObj.format) : '',
        endTime: this.endTime ? dayjs(this.endTime).format(this.selectTypeObj.format) : '',
        selectType: this.selectType
      })
    },
    // 开始判断
    disabledStartDate(startValue) {
      if(this.selectType != 'day') {
        return null
      }
      const endValue = this.endTime;
      if (endValue !== '') {
        return dayjs(startValue).isBefore(dayjs(endValue).subtract(31, 'day')) || dayjs(startValue).isAfter(dayjs(endValue))
      } else {
        return null
      }
      
    },
    disabledEndDate(endValue) {
      if(this.selectType != 'day') {
        return null
      }
      const startValue = this.startTime;
      if (startValue !== '') {
        return dayjs(endValue).isAfter(dayjs(startValue).add(31, 'day')) ||  dayjs(endValue).isBefore(dayjs(startValue))
      } else {
        return null
      }
    },
    onChangeDate(date, dateString) {
      console.log(date, dateString);
    },
    // 点击tab
    onTab(value) {
      this.dateType = value
    },
  },
  created() {

  },
  mounted() {

  },
}
</script>
<style lang='less' scoped>
.active {
  color: #3b98ff !important;
}
  //@import url(); 引入公共css类
  .filter {
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

</style>