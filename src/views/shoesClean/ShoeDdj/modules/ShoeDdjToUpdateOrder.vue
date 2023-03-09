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
            <a-form-model-item label="快递单号" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="kuaidinum">
              <a-input v-model="form.kuaidinum" placeholder="请输入快递单号"></a-input>
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
      rules: {
        kuaidinum: [{required: true, message: '请输入快递单号'}],
        code: [{required: true, message: '请输入核销码'}],

      },
      form: {
        orderType: '1',
        code: null,
        kuaidinum: null,
        day: [],
        time: [],
        dayTime: ''
      },
      codes: [],

      timeOptions: [],
      loading: false
    }
  },
  created() {
    this.getTime()
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
    "form.code"(val) {
      this.codes = val.split(',')
    }
  },
  methods: {
    getTime(start = 9, end = 22) {
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
    show(ddjId) {
      Object.assign(this.form, ddjId)
      this.visible = true;
      this.showUpdateOrder(ddjId);
      this.form.ddjId=ddjId;
    },
    reset() {
      this.form = {
        ddjId: '',
        code: null,
        day: [],
        time: [],
        dayTime: '',
        kuaidinum: null
      }
      this.loading = false
      this.rules = {}
    },
    handleCancel() {
      this.reset()
      this.visible = false;
    },
    showUpdateOrder(ddjId){
      httpAction("/shoeDdj/showUpdateOrder?ddjId="+ddjId, null, "get").then((res) => {
        if (res.success) {
         this.form.code=res.result.code;
         this.form.kuaidinum=res.result.kuaidinum;
        } else {
          this.$message.warning(res.message);
        }
      })
    },
    handleSubmit() {
      this.$refs.ruleForm.validate((valid, object) => {
        if (valid) {
          this.loading = true
          debounce(() => {
            this.loading = true
            let form = {kuaidinum: this.form.kuaidinum, code: this.form.code,ddjId: this.form.ddjId}
            httpAction("/shoeDdj/updateOrder", form, "put").then((res) => {
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