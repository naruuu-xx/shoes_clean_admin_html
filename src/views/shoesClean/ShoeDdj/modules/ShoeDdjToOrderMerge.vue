<template>
  <j-modal
    :title="title"
    :width="500"
    :visible="visible"
    switchFullscreen
    @cancel="handleCancel"
    cancelText="关闭"
    :footer="null"
    wrapClassName="full-modal">
    <div>
    <a-form-model ref="ruleForm" :model="form" :rules="rules">
      <a-row type="flex" justify="space-around" v-for="(item,idx) in form.arr" :key="idx" v-if="form.orderType == 3">
        <a-col :span="20">
          <a-form-model-item :label="`核销码${idx+1}`" :labelCol="labelCol" :wrapperCol="wrapperCol" :prop="`checkOffCode${idx+1}`">
            <a-input v-model="form[`checkOffCode${idx+1}`]" placeholder="请输入核销码"></a-input>
          </a-form-model-item>
        </a-col>
      </a-row>
      <a-row type="flex" justify="space-around">
        <a-col :span="20">
          <a-form-model-item label="姓名" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="name">
            <a-input v-model="form.name" placeholder="请输入姓名"></a-input>
          </a-form-model-item>
        </a-col>
      </a-row>
      <a-row type="flex" justify="space-around">
        <a-col :span="20">
          <a-form-model-item label="手机号" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="phone">
            <a-input v-model="form.phone" placeholder="请输入手机号"></a-input>
          </a-form-model-item>
        </a-col>
      </a-row>
      <a-row type="flex" justify="space-around">
        <a-col :span="20">
          <a-form-model-item label="省市区" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="area">
            <a-space>
              <a-input value="福建省" disabled></a-input>
              <a-input value="厦门市" disabled></a-input>
              <a-select :options="areaOptions" v-model="form.area" @change="changeArea" style="width: 100px" placeholder="请选择区">
              </a-select>
            </a-space>
          </a-form-model-item>
        </a-col>
      </a-row>
      <a-row type="flex" justify="space-around">
        <a-col :span="20">
          <a-form-model-item label="详细地址" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="address">
            <a-input v-model="form.address" placeholder="请输入详细地址"></a-input>
          </a-form-model-item>
        </a-col>
      </a-row>
      <a-row type="flex" justify="space-around">
        <a-col :span="20">
          <a-form-model-item label="上门时间" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="dayTime">
            <a-space>
              <a-select :options="dayOptions" v-model="form.day" style="width: 80px" placeholder="时间">
              </a-select>
              <a-select :options="timeOptions" v-model="form.time" style="width: 160px" placeholder="请选择具体时间">
              </a-select>
            </a-space>
            
          </a-form-model-item>
        </a-col>
      </a-row>
    </a-form-model>
      <a-row>
        <a-col :span="24">
          <a-col :span="6"></a-col>
          <a-col :span="6">
            <a-button @click="handleCancel">取消</a-button>
          </a-col>
          <a-col :span="6">
            <a-button @click="handleSubmit" :loading="loading">确认</a-button>
          </a-col>
          <a-col :span="6"></a-col>
        </a-col>
      </a-row>
    </div>
    <div>{{dayTime}}</div>
  </j-modal>
</template>

<script>
const dayjs = require('dayjs');
import {getAction, httpAction} from "../../../../api/manage";

export default {
  name: "DistributeCouponModal",
  data() {
    return {
      visible: false,
      title: '合并下单',
      labelCol: {
        xs: { span: 24 },
        sm: { span: 5 },
      },
      wrapperCol: {
        xs: { span: 24 },
        sm: { span: 16 },
      },
      model: {},
      rules: {
        name: [{required: true, message: '请输入名字'}],
        phone: [{required: true, message: '请输入手机号'}],
        area: [{required: true, message: '请输入区'}],
        address: [{required: true, message: '请输入详细地址'}],
        dayTime: [{required: true, message: '请选择时间'}],
      },
      form:{
        name:'',
        phone: '',
        address: '',
        day:[],
        time:[],
        area: [],
        arr:[],
        dayTime:'',
        orderType: '3', // 3有核销码 4无核销码
      },
      dayOptions:[
        {
          label: '今天',
          value: dayjs().format('YYYY-MM-DD')
        },
        {
          label: '明天',
          value: dayjs().add(1, 'day').format('YYYY-MM-DD')
        },
        {
          label: '后天',
          value: dayjs().add(2, 'day').format('YYYY-MM-DD')
        },
      ],
      timeOptions:[
        {
          label:'9:00-10:00',
          value:'9:00-10:00'
        }
      ],
      areaOptions:[
        {
          label:'思明区',
          value:'思明区'
        },
        {
          label:'湖里区',
          value:'湖里区'
        },
        {
          label:'集美区',
          value:'集美区'
        },
        {
          label:'海沧区',
          value:'海沧区'
        },
        {
          label:'同安区',
          value:'同安区'
        },
        {
          label:'翔安区',
          value:'翔安区'
        },
      ],
      loading:false
    }
  },
  created() {
    this.getTime()
  },
  computed:{
    dayTime() {
      let str = !!this.form.day.length && !!this.form.time.length
      this.form.dayTime = str || ''
      if(this.$refs.ruleForm) {
        this.$refs.ruleForm.validateField('dayTime')
      }
      return 
    }
  },
  methods: {
    changeArea(e) {
      this.$refs.ruleForm.validateField('area')
    },
    reset() {
      this.rules = {
        name: [{required: true, message: '请输入名字'}],
        phone: [{required: true, message: '请输入手机号'}],
        area: [{required: true, message: '请输入区'}],
        address: [{required: true, message: '请输入详细地址'}],
        dayTime: [{required: true, message: '请选择时间'}],
      }
      this.form = {
        name:'',
        phone: '',
        address: '',
        day:[],
        time:[],
        area: [],
        arr:[],
        dayTime:'',
        orderType: '3'
      }
      this.loading = false
    },
    getTime(start=9,end=20) {
      let leng = end - start
      this.timeOptions = new Array(leng).fill('').map((item,idx) => item = {
        label: `${start+idx}:00-${start+idx+1}:00`,
        value: `${start+idx}:00-${start+idx+1}:00`
      })
    },
    filterOption(input, option) {
      return (
        option.componentOptions.children[0].text.toLowerCase().indexOf(input.toLowerCase()) >= 0
      );
    },
    show(record) {
      this.form.orderType = record.orderType
      this.form.arr = record.ids.map((id,idx) => {
        let index = idx + 1
        this.rules[`checkOffCode${index}`] = [{required: true, message: `请输入核销码${index}`}]
        return {
          id,
          checkOffCode:''
        }
      })
      
      console.log(999111,this.form);
      // this.rules.push(
      //   dayTime: [{required: true, message: '请选择时间'}],
      // )
      console.log(999,record);
      this.visible = true;
    },
    handleCancel() {
      this.$parent.$parent.selectedRowKeys = []
      this.reset()
      this.visible = false;
    },
    handleSubmit() {
      this.$refs.ruleForm.validate((valid,object) => {
        if (valid) {
          debounce(() => {
            this.loading = true
            if(this.form.orderType == 3) {
              this.form.arr.forEach((element,idx) => {
                element.checkOffCode = this.form[`checkOffCode${idx+1}`]
              });
            }
            this.loading = false
            console.log('submit',this.form);
          })
        } else {
          console.log('error submit!!');
          return false;
        }
      });
    },
    radioChange(){
      //根据所选的单选值，请求不同的接口
      
    },
  }
}
</script>

<style scoped>

</style>