<template>
  <a-spin :spinning="confirmLoading">
    <j-modal
      :title="title"
      :width="600"
      :visible="visible"
      switchFullscreen
      @ok="submitForm"
      @cancel="handleCancel"
      cancelText="取消"
    >
      <a-form-model ref="form" :model="model" :rules="validatorRules">
        <a-row>
          <a-col :span="24">
            <a-form-model-item label="完单原因" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="note">
              <a-textarea  v-model="model.note" placeholder="请输入完单原因" style="width: 100%" />
            </a-form-model-item>
          </a-col>
        </a-row>
      </a-form-model>
    </j-modal>
  </a-spin>
</template>

<script>
import {httpAction} from "../../../../api/manage";

export default {
  name: "HandleOrderFinishModal",
  data () {
    return {
      labelCol: {
        xs: { span: 24 },
        sm: { span: 5 },
      },
      wrapperCol: {
        xs: { span: 24 },
        sm: { span: 16 },
      },
      confirmLoading: false,
      title: "完单处理",
      visible: false,
      validatorRules: {
        note: [{required: true, message: '请输入完单原因!'}]
      },
      model: {},
    }
  },
  methods: {
    show(record){
      let orderId = {"orderId": record.orderId};
      this.model = Object.assign({}, orderId);
      this.visible = true;
    },
    submitForm() {
      const that = this;
      // 触发表单验证
      this.$refs.form.validate(valid => {
        if (valid) {
          that.confirmLoading = true;

          let submitUrl = "/ShoeOrder/shoeOrder/manualFinishOrder";

          httpAction(submitUrl, this.model, "Post").then((res) => {
            if (res.success) {
              that.$message.success(res.message)
              that.$emit('ok')
              this.visible = false;
            } else {
              that.$message.warning(res.message);
            }
          }).finally(() => {
            that.confirmLoading = false
          })
        }
      })
    },
    handleCancel(){
      this.model = {};
      this.visible = false;
    }
  }
}
</script>

<style scoped>

</style>