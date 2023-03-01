<template>
  <j-modal
    :title="title"
    :width="width"
    :visible="visible"
    switchFullscreen
    @cancel="handleCancel"
    cancelText="关闭"
    :footer="null"
  >
<!--    <j-form-container :disabled="formDisabled">-->
      <a-form-model ref="form" :model="model" :label-col="{ span: 5 }" :wrapper-col="{ span: 12 }" :rules="validatorRules">
  <!--      <a-form-item label="机柜收益">-->
        <!--        <a-input autocomplete="off"-->
        <!--          v-decorator="['note', { rules: [{ required: true, message: '请输入1-100之间的整数!' },{ pattern: /^([1-9][0-9]{0,1}|100)$/, message: '请输入1-100之间的整数!'},] }]"-->
        <!--        />-->
        <!--      </a-form-item>-->
        <a-form-model-item label=" 收益比例" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="percentage">
          <a-input v-model="model.percentage" placeholder="请输入0-100的整数" autocomplete="off" suffix="%"></a-input>
        </a-form-model-item>
        <a-form-item :wrapper-col="{ span: 12, offset: 5 }">
          <a-button type="primary" html-type="submit" @click="setPercentage()">
            提交
          </a-button>
        </a-form-item>
      </a-form-model>
<!--    </j-form-container>-->
  </j-modal>
</template>

<script>
import {httpAction} from "@api/manage";

export default {
  name: "SetPercentage.vue",
  props: {
    //表单禁用
    disabled: {
      type: Boolean,
      default: false,
      required: false
    }
  },
  data () {
    return {
      model:{},
      title: '收益设置',
      width: 600,
      visible: false,
      distributorId: "",
      validatorRules: {
        percentage: [
          { required: true, message: '请输入0-100之间的整数!'},
          { pattern: /^([0-9]{0,2}|100)$/, message: '请输入0-100之间的整数!'},
        ],
      },
      labelCol: {
        xs: { span: 24 },
        sm: { span: 5 },
      },
      wrapperCol: {
        xs: { span: 24 },
        sm: { span: 16 },
      },
    }
  },
  computed: {
    formDisabled(){
      return this.disabled
    },
  },
  methods: {
    show(record) {
      this.model = Object.assign({}, record);
      this.distributorId = record.distributorId;
      this.visible = true;
    },
    handleCancel() {
      this.visible = false;
    },
    setPercentage() {
      const that = this;
      this.$refs.form.validate(valid => {
        if (valid) {
          let data = {
            "distributorId": that.distributorId,
            "percentage": that.model.percentage,
          }

          httpAction("/shoeDistributor/shoeDistributor/setPercentage", data, 'post').then((res) => {
            if (res.code === 200) {
              that.$message.success("设置成功")
              this.visible = false;
              that.$emit('ok');
            } else {
              that.$message.warning(res.message);
            }
          })
        }
      })


    }

  }
}
</script>

<style scoped>

</style>