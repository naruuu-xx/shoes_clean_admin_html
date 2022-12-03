<template>
  <j-modal
    title="手工录单"
    :width="600"
    :visible="visible"
    @cancel="handleCancel"
    :footer="null"
    wrapClassName="full-modal">
    <a-spin :spinning="confirmLoading">
      <j-form-container :disabled="formDisabled">
        <a-form-model ref="form" :model="model" :rules="validatorRules" slot="detail">
          <a-row>
            <a-col :span="24">
              <a-form-model-item label="订单编号" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="no">
                <a-input v-model="model.no" placeholder="请输入订单编号" style="width: 200px"></a-input>
              </a-form-model-item>
            </a-col>
            <a-col :span="24">
              <a-form-model-item label="订单类型" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="source">
                <!--                  <a-input v-model="model.source" placeholder="请选择订单类型"></a-input>-->
                <a-select v-model="model.source" style="width: 100px">
                  <a-select-option v-for="item in orderType" :value="item.value" :key="item.value">{{ item.name }}
                  </a-select-option>
                </a-select>
              </a-form-model-item>
            </a-col>
            <a-col :span="24">
              <a-form-model-item label="商品名称" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="title">
                <a-input v-model="model.title" placeholder="请输入商品名称" style="width: 200px"></a-input>
              </a-form-model-item>
            </a-col>
            <a-col :span="24">
              <a-form-model-item label="商品规格" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="skuTitle">
                <a-input v-model="model.skuTitle" placeholder="请输入商品规格" style="width: 200px"></a-input>
              </a-form-model-item>
            </a-col>
            <a-col :span="24">
              <a-form-model-item label="手机号" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="phone">
                <a-input v-model="model.phone" placeholder="请输入手机号" style="width: 200px"></a-input>
              </a-form-model-item>
            </a-col>
            <a-col :span="24">
              <a-form-model-item label="姓名" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="name">
                <a-input v-model="model.name" placeholder="请输入姓名" style="width: 200px"></a-input>
              </a-form-model-item>
            </a-col>
            <a-col :span="24">
              <a-form-model-item label="备注" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="note">
                <a-textarea v-model="model.note" placeholder="请输入备注"></a-textarea>
              </a-form-model-item>
            </a-col>
          </a-row>
          <a-row>
            <a-col :span="24">
              <a-col :span="6"></a-col>
              <a-col :span="6">
                <a-button type="primary" @click="handleSubmit">确认</a-button>
              </a-col>
              <a-col :span="6">
                <a-button @click="handleCancel">取消</a-button>
              </a-col>
              <a-col :span="6"></a-col>
            </a-col>
          </a-row>
        </a-form-model>
      </j-form-container>
    </a-spin>
  </j-modal>
</template>

<script>
import {httpAction} from "../../../../../api/manage";

export default {
  name: "ManualInOfStorage",
  components: {},
  props: {
    //表单禁用
    disabled: {
      type: Boolean,
      default: false,
      required: false
    }
  },
  data() {
    return {
      visible: false,
      confirmLoading: false,
      model: {},
      orderType: [{"value": "2", "name": "候鸟"}, {"value": "3", "name": "干洗店"}, {"value": "4", "name": "供应商"}],
      labelCol: {
        xs: {span: 24},
        sm: {span: 5},
      },
      wrapperCol: {
        xs: {span: 24},
        sm: {span: 16},
      },
      validatorRules: {
        no: [
          {required: true, message: '请输入订单编号!'},
        ],
        source: [
          {required: true, message: '请选择订单类型!'},
        ],
        title: [
          {required: true, message: '请输入商品名称!'},
        ],
        skuTitle: [
          {required: true, message: '请输入商品规格!'},
        ],
        phone: [
          {required: true, message: '请输入手机号!'},
          { pattern: /^1[3456789]\d{9}$/, message: '请输入正确的手机号码!'}
        ],
        name: [
          {required: true, message: '请输入姓名!'},
        ],
        note: [
          {required: false, message: '请输入备注!'},
        ]
      },
    }
  },
  computed: {
    formDisabled() {
      return this.disabled
    },
  },
  created() {
  },
  methods: {
    show() {
      this.visible = true;
      this.model = {};
    },
    handleCancel() {
      this.visible = false;
      this.model = {};
    },
    handleSubmit(){
      const that = this;

      this.$refs.form.validate(valid => {
        if (valid) {
          that.confirmLoading = true;

          httpAction("/ShoeFactoryOrder/shoeFactoryOrder/manualInOfStorage",this.model, "post").then((res)=> {
            if (res.success) {
              that.$message.success(res.message);
              this.visible = false;
              this.model = {};
              this.$emit('ok');
            } else {
              that.$message.warning(res.message);
            }
          }).finally(() => {
            that.confirmLoading = false;
          })
        }
      })
    },
  }
}
</script>

<style scoped>

</style>