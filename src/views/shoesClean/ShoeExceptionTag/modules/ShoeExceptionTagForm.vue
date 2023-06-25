<template>
  <a-spin :spinning="confirmLoading">
    <j-form-container :disabled="formDisabled">
      <a-form-model ref="form" :model="model" :rules="validatorRules" slot="detail">
        <a-row>
          <a-col :span="24">
            <a-form-model-item label="订单编号" :labelCol="labelCol" :wrapperCol="wrapperCol">
              <h3>{{date.no}}</h3>
            </a-form-model-item>
          </a-col>
          <a-col :span="24">
            <a-form-model-item label="商品名称" :labelCol="labelCol" :wrapperCol="wrapperCol">
              <h3>{{date.name}}</h3>
            </a-form-model-item>
          </a-col>
          <a-col :span="24">
            <a-form-model-item label="商品规格" :labelCol="labelCol" :wrapperCol="wrapperCol">
              <h3>{{date.skuTitle}}</h3>
            </a-form-model-item>
          </a-col>
          <a-col :span="24">
            <a-form-model-item label="处理方式" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="dealType">
              <j-date placeholder="请选择处理时间" v-model="model.dealType"  style="width: 100%" />
            </a-form-model-item>
          </a-col>
          <a-col :span="24">
            <a-form-model-item label="状态：0=未处理，1=已处理（订单状态非洗护中且未处理则标为已失效）" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="status">
              <a-input-number v-model="model.status" placeholder="请输入状态：0=未处理，1=已处理（订单状态非洗护中且未处理则标为已失效）" style="width: 100%" />
            </a-form-model-item>
          </a-col>
        </a-row>
      </a-form-model>
    </j-form-container>
  </a-spin>
</template>

<script>

  import { httpAction, getAction } from '@/api/manage'
  import { validateDuplicateValue } from '@/utils/util'

  export default {
    name: 'ShoeExceptionTagForm',
    components: {
    },
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
        date:{},
        model:{
         },
        labelCol: {
          xs: { span: 24 },
          sm: { span: 5 },
        },
        wrapperCol: {
          xs: { span: 24 },
          sm: { span: 16 },
        },
        confirmLoading: false,
        validatorRules: {
           exceptionTagId: [
              { required: true, message: '请输入异常id!'},
           ],
           orderId: [
              { required: true, message: '请输入订单id!'},
           ],
           dealType: [
              { required: true, message: '请输入处理方式：1=转异常，2=继续洗!'},
           ],
           status: [
              { required: true, message: '请输入状态：0=未处理，1=已处理（订单状态非洗护中且未处理则标为已失效）!'},
           ],
        },
        url: {
          add: "/shoeExceptionTag/shoeExceptionTag/add",
          edit: "/shoeExceptionTag/shoeExceptionTag/edit",
          queryById: "/shoeExceptionTag/shoeExceptionTag/queryById"
        }
      }
    },
    computed: {
      formDisabled(){
        return this.disabled
      },
    },
    created () {
       //备份model原始值
      this.modelDefault = JSON.parse(JSON.stringify(this.model));
    },
    methods: {
      add () {
        this.edit(this.modelDefault);
      },
      edit (record) {
        this.model = Object.assign({}, record);
        this.visible = true;
      },
      submitForm () {
        const that = this;
        // 触发表单验证
        this.$refs.form.validate(valid => {
          if (valid) {
            that.confirmLoading = true;
            let httpurl = '';
            let method = '';
            if(!this.model.id){
              httpurl+=this.url.add;
              method = 'post';
            }else{
              httpurl+=this.url.edit;
               method = 'put';
            }
            httpAction(httpurl,this.model,method).then((res)=>{
              if(res.success){
                that.$message.success(res.message);
                that.$emit('ok');
              }else{
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