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
      form:{name:'',platformId:''},
      rules: {
        name: [{required: true, message: '请输入来源'}],
      },
    }
  },
  created() {
  },
  computed: {

  },


  methods: {
    show(id) {
      this.visible = true;
      this.showUpdate(id);
      this.form.platformId=id;
    },
    handleCancel() {
      this.visible = false;
      this.form={name:''};
    },
    showUpdate(id){
      httpAction("/shoeFactoryPlatform/showUpdate?id="+id, null, "get").then((res) => {
        if (res.success) {
          this.form.name=res.result;
        } else {
          this.$message.warning(res.message);
        }
      })
    },

    handleSubmit() {
      this.$refs.ruleForm.validate((valid, object) => {
        if (valid) {
            let form = this.form
            httpAction("/shoeFactoryPlatform/update", form, "put").then((res) => {
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