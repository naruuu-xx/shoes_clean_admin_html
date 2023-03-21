<template>
  <a-spin :spinning="confirmLoading">
    <j-form-container :disabled="formDisabled">
      <a-form-model ref="form" :model="model" :rules="validatorRules" slot="detail">
        <a-row>
          <a-col :span="24">
            <a-form-model-item label="id" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="couponExchangeThirdId">
              <a-input-number v-model="model.couponExchangeThirdId" placeholder="请输入id" style="width: 100%" />
            </a-form-model-item>
          </a-col>
          <a-col :span="24">
            <a-form-model-item label="发放优惠券Id" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="couponId">
              <a-input-number v-model="model.couponId" placeholder="请输入发放优惠券Id" style="width: 100%" />
            </a-form-model-item>
          </a-col>
          <a-col :span="24">
            <a-form-model-item label="兑换码" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="code">
              <a-input v-model="model.code" placeholder="请输入兑换码"  ></a-input>
            </a-form-model-item>
          </a-col>
          <a-col :span="24">
            <a-form-model-item label="用户id" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="userId">
              <a-input-number v-model="model.userId" placeholder="请输入用户id" style="width: 100%" />
            </a-form-model-item>
          </a-col>
          <a-col :span="24">
            <a-form-model-item label="核销状态，0=审核中，1=已同意，2=已拒绝" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="status">
              <a-input-number v-model="model.status" placeholder="请输入核销状态，0=审核中，1=已同意，2=已拒绝" style="width: 100%" />
            </a-form-model-item>
          </a-col>
          <a-col :span="24">
            <a-form-model-item label="手机号" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="phone">
              <a-input-number v-model="model.phone" placeholder="请输入手机号" style="width: 100%" />
            </a-form-model-item>
          </a-col>
          <a-col :span="24">
            <a-form-model-item label="姓名" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="name">
              <a-input v-model="model.name" placeholder="请输入姓名"  ></a-input>
            </a-form-model-item>
          </a-col>
          <a-col :span="24">
            <a-form-model-item label="拒绝原因" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="note">
              <a-input v-model="model.note" placeholder="请输入拒绝原因"  ></a-input>
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
    name: 'ShoeCouponExchangeThirdForm',
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
           couponExchangeThirdId: [
              { required: true, message: '请输入id!'},
           ],
           code: [
              { required: true, message: '请输入兑换码!'},
           ],
           userId: [
              { required: true, message: '请输入用户id!'},
           ],
           status: [
              { required: true, message: '请输入核销状态，0=审核中，1=已同意，2=已拒绝!'},
           ],
           phone: [
              { required: true, message: '请输入手机号!'},
           ],
           name: [
              { required: true, message: '请输入姓名!'},
           ],
        },
        url: {
          add: "/ShoeCouponExchangeThird/shoeCouponExchangeThird/add",
          edit: "/ShoeCouponExchangeThird/shoeCouponExchangeThird/edit",
          queryById: "/ShoeCouponExchangeThird/shoeCouponExchangeThird/queryById"
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