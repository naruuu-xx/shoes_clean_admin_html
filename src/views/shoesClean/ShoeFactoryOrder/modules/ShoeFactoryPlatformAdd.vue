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
            <a-form-model-item label="来源" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="name">
              <a-input v-model="form.name" placeholder="请输入来源"></a-input>
            </a-form-model-item>
          </a-col>
        </a-row>
        <a-row type="flex" justify="space-around">
          <a-col :span="20">
            <a-form-model-item label="标识" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="tag">
              <a-input :maxlength="1" v-model="form.tag" placeholder="请输入标识"></a-input>
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
              <a-button @click="handleSubmit" >确认</a-button>
            </a-col>
            <a-col :span="6"></a-col>
          </a-col>
        </a-row>
      </a-form-model>

    </div>
  </j-modal>
</template>

<script>
const dayjs = require('dayjs');
import {getAction, httpAction} from "../../../../api/manage";
import debounce from "@/utils/debounce"

export default {
  name: "ShoeFactoryPlatformAdd",
  data() {
    return {
      visible: false,
      title: '新增',
      labelCol: {
        xs: {span: 24},
        sm: {span: 5},
      },
      wrapperCol: {
        xs: {span: 24},
        sm: {span: 16},
      },
      model: {},
      form:{name:''},
      rules: {
        name: [{required: true, message: '请输入来源'}],
        tag: [{required: true, message: '请输入标识'}, {pattern: /^[\u4e00-\u9fa5]$/, message: '请输入一个中文的标识!'}],
      },
    }
  },
  created() {
  },
  computed: {

  },


  methods: {
    show() {
      this.visible = true;
    },
    handleCancel() {
      this.visible = false;
      this.form={name:''};
    },
    handleSubmit() {
      this.$refs.ruleForm.validate((valid, object) => {
        if (valid) {
            let form = this.form;
            form = Object.assign(form, {createBy: 2})
            httpAction("/shoeFactoryPlatform/add", form, "post").then((res) => {
              if (res.success) {
                this.$message.success(res.message);
                this.handleCancel()
                this.$emit("ok");
              } else {
                this.$message.warning(res.message);
              }
            }).finally(() => {
            })
        } else {
          return false;
        }
      });
    },
  }
}
</script>

<style scoped>

</style>