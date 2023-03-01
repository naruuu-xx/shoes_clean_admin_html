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
        <a-row type="flex" justify="space-around" v-if="form.orderType != 0">
          <a-col :span="20">
            <a-form-model-item label="下单类型" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="orderType">
              <a-radio-group v-model="form.orderType">
                <a-radio value="1" style="margin-right: 60px">立即下单</a-radio>
                <a-radio value="2">延迟下单</a-radio>
              </a-radio-group>
            </a-form-model-item>
          </a-col>
        </a-row>
        <a-row type="flex" justify="space-around" v-if="form.orderType != 0">
          <a-col :span="20">
            <a-form-model-item label="核销码" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="code">
              <a-input v-model="form.code" placeholder="请输入核销码"></a-input>
            </a-form-model-item>
          </a-col>
        </a-row>
        <a-row type="flex" justify="space-around" v-if="form.orderType != 2">
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
      </a-form-model>
      <div>{{dayTime}}</div>
    </div>
  </j-modal>
</template>

<script>
  const dayjs = require('dayjs');
import {getAction, httpAction} from "../../../../api/manage";
import debounce from "@/utils/debounce"

export default {
  name: "ShoeDdjToOrder",
  data() {
    return {
      visible: false,
      title: '下单',
      labelCol: {
        xs: { span: 24 },
        sm: { span: 5 },
      },
      wrapperCol: {
        xs: { span: 24 },
        sm: { span: 16 },
      },
      model: {},
      rules: {},
      form:{
        orderType:'1',
        code: null,
        day:[],
        time:[],
        dayTime:''
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
      timeOptions:[],
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
      this.$refs.ruleForm && this.$refs.ruleForm.validateField(['dayTime'])
      return 
    }
  },
  watch:{
    "form.orderType":{
      deep:true,
      immediate: true,
      handler(newVal,oldVal){
        if(newVal == 1) {
          this.rules = {
            type: [{required: true, message: '请选择下单类型'}],
            code: [{required: true, message: '请输入核销码'}],
            dayTime: [{required: true, message: '请选择下单时间'}],
          }
        }
        if(newVal == 2) {
          this.rules = {
            type: [{required: true, message: '请选择下单类型'}],
            code: [{required: true, message: '请输入核销码'}],
          }
        }
      }
    }
  },
  methods: {
    getTime(start=9,end=22) {
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
      Object.assign(this.form,record)
      this.visible = true;
    },
    reset() {
      this.form = {
        orderType:'1',
        code: null,
        day:[],
        time:[],
        dayTime:''
      }
      this.loading = false
      this.rules = {}
    },
    handleCancel() {
      this.reset()
      this.visible = false;
    },
    handleSubmit() {
      this.$refs.ruleForm.validate((valid,object) => {
        if (valid) {
          this.loading = true
          debounce(() => {
            this.loading = true
            let obj = this.form.orderType == 2 ? {day:'',time:'',orderType: 2} : {orderType:1}
            let form = Object.assign({},this.form,obj)
            httpAction("/shoeDdj/order", form, "put").then((res) => {
              if (res.success) {
                this.$message.success(res.message);
                this.handleCancel()
                this.$emit("ok");
              } else {
                this.$message.warning(res.message);
              }
            }).finally(() => {
              this.loading = false
            })
          })
          
        } else {
          console.log('error submit!!');
          return false;
        }
      });
    },
  }
}
</script>

<style scoped>

</style>