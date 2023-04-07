<template>
  <j-modal
    :title="title"
    :width="800"
    :visible="visible"
    switchFullscreen
    @cancel="handleCancel"
    cancelText="关闭"
    :footer="null"
    wrapClassName="full-modal">
    <div>
      <a-form-model ref="ruleForm" :model="form" :rules="rules">
        <a-row type="flex" justify="space-around">
          <a-col :span="20">
            <a-form-model-item label="核销码" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="code">
              <a-input v-model="form.code" placeholder="请输入核销码"></a-input>
            </a-form-model-item>
          </a-col>
        </a-row>
        <a-row type="flex" justify="space-around">
          <a-col :span="20">
            <a-form-model-item label="核销码" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="code">
              <a-tag v-for="(item,idx) in codes" :key="idx">{{ item }}</a-tag>
            </a-form-model-item>
          </a-col>
        </a-row>
        <a-row type="flex" justify="space-around">
          <a-col :span="20">
            <a-form-model-item label="双数" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="num">
              <a-input v-model="form.num" placeholder="请输入双数"></a-input>
            </a-form-model-item>
          </a-col>
        </a-row>
        <a-row type="flex" justify="space-around">
          <a-col :span="20">
            <a-form-model-item label="来源" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="platformId">
              <a-select v-model="form.platformId" :options="sourceOption">
              </a-select>
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
            <a-form-model-item label="省" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="province">
              <a-input v-model="form.province" placeholder="请输入省"></a-input>
            </a-form-model-item>
          </a-col>
        </a-row>
        <a-row type="flex" justify="space-around">
          <a-col :span="20">
            <a-form-model-item label="市" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="city">
              <a-input v-model="form.city" placeholder="请输入市"></a-input>
            </a-form-model-item>
          </a-col>
        </a-row>
        <a-row type="flex" justify="space-around">
          <a-col :span="20">
            <a-form-model-item label="区" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="area">
              <a-input v-model="form.area" placeholder="请输入区"></a-input>
            </a-form-model-item>
          </a-col>
        </a-row>

        <a-row type="flex" justify="space-around">
          <a-col :span="20">
            <a-form-model-item label="详情地址" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="address">
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
      <div>{{ dayTime }}</div>
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
        xs: {span: 24},
        sm: {span: 5},
      },
      wrapperCol: {
        xs: {span: 24},
        sm: {span: 16},
      },
      model: {},
      form: {
        orderType: '1',
        code: null,
        day: [],
        time: [],
        dayTime: '',
        platformId: ''
      },
      dayOptions: [
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
      rules: {
        num: [{required: true, message: '请选择双数'},
          {pattern: /^[0-9]*$/, message: '只能输入数字!'}],
        code: [{required: true, message: '请输入核销码'}],
        name: [{required: true, message: '请输入姓名'}],
        phone: [{required: true, message: '请输入手机号'},
          {pattern: /^1[3456789]\d{9}$/, message: '请输入正确的手机号码!'}],
        province: [{required: true, message: '请输入省'}],
        city: [{required: true, message: '请输入市'}],
        area: [{required: true, message: '请输入区'}],
        address: [{required: true, message: '请详细地址'}],
      },
      timeOptions: [],
      sourceOption: [],
      codes: [],
      loading: false
    }
  },
  created() {
    this.getTime()
    this.getSource();
  },
  computed: {
    dayTime() {
      let str = !!this.form.day.length && !!this.form.time.length
      this.form.dayTime = str || ''
      this.$refs.ruleForm && this.$refs.ruleForm.validateField(['dayTime'])
      return
    }
  },

  watch: {
    "form.orderType": {
      deep: true,
      immediate: true,
    },
      "form.code"(val) {
        val = val.replace(/；/g,';')
        this.codes = val.split(';')
    },
  },
  methods: {
    getSource() {
      httpAction("/shoeDdj/getSource", "", "get").then((res) => {
        console.log("====", res.result);
        this.sourceOption = res.result;
      })
    },
    getTime(start = 9, end = 18) {
      let leng = end - start
      this.timeOptions = new Array(leng).fill('').map((item, idx) => item = {
        label: `${start + idx}:00-${start + idx + 1}:00`,
        value: `${start + idx}:00-${start + idx + 1}:00`
      })
    },
    filterOption(input, option) {
      return (
        option.componentOptions.children[0].text.toLowerCase().indexOf(input.toLowerCase()) >= 0
      );
    },
    show() {
      //Object.assign(this.form, record)
      this.visible = true;
    },
    reset() {
      this.form = {
        orderType: '1',
        code: null,
        day: [],
        time: [],
        dayTime: '',
        platformId: ''
      }
      this.loading = false
      this.rules = {}
    },
    handleCancel() {
      this.reset()
      this.visible = false;
    },
    handleSubmit() {
      this.$refs.ruleForm.validate((valid, object) => {
        if (valid) {
            let code=null
            if (this.form.code){
             code = this.form.code.replace(/；/g,';')
            }

          let form = Object.assign({}, this.form, {code})
            httpAction("/shoeDdj/add", form, "post").then((res) => {
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