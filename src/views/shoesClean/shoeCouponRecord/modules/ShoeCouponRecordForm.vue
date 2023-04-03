<template>
  <a-spin :spinning="confirmLoading">
    <j-form-container :disabled="formDisabled">
      <a-form-model ref="form" :model="model" :rules="validatorRules" slot="detail">
        <a-row>
          <a-col :span="24">
            <a-form-model-item label="优惠券发放记录ID" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="couponRecordId">
              <a-input-number v-model="model.couponRecordId" placeholder="请输入优惠券发放记录ID" style="width: 100%" />
            </a-form-model-item>
          </a-col>
          <a-col :span="24">
            <a-form-model-item label="优惠券id" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="couponId">
              <a-input-number v-model="model.couponId" placeholder="请输入优惠券id" style="width: 100%" />
            </a-form-model-item>
          </a-col>
          <a-col :span="24">
            <a-form-model-item label="用户id" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="userId">
              <a-input-number v-model="model.userId" placeholder="请输入用户id" style="width: 100%" />
            </a-form-model-item>
          </a-col>
          <a-col :span="24">
            <a-form-model-item label="用户优惠券id" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="userCouponId">
              <a-input-number v-model="model.userCouponId" placeholder="请输入用户优惠券id" style="width: 100%" />
            </a-form-model-item>
          </a-col>
          <a-col :span="24">
            <a-form-model-item label="发放批次(从1递增)" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="recordNo">
              <a-input-number v-model="model.recordNo" placeholder="请输入发放批次(从1递增)" style="width: 100%" />
            </a-form-model-item>
          </a-col>
          <a-col :span="24">
            <a-form-model-item label="状态:0=冻结，1=正常" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="status">
              <a-input-number v-model="model.status" placeholder="请输入状态:0=冻结，1=正常" style="width: 100%" />
            </a-form-model-item>
          </a-col>
          <a-col :span="24">
            <a-form-model-item label="派发人id" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="grantUserId">
              <a-input v-model="model.grantUserId" placeholder="请输入派发人id"  ></a-input>
            </a-form-model-item>
          </a-col>
          <a-col :span="24">
            <a-form-model-item label="派发人姓名" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="grantUsername">
              <a-input v-model="model.grantUsername" placeholder="请输入派发人姓名"  ></a-input>
            </a-form-model-item>
          </a-col>
          <a-col :span="24">
            <a-form-model-item label="撤销人id" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="repealUserId">
              <a-input v-model="model.repealUserId" placeholder="请输入撤销人id"  ></a-input>
            </a-form-model-item>
          </a-col>
          <a-col :span="24">
            <a-form-model-item label="撤销人姓名" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="repealUsername">
              <a-input v-model="model.repealUsername" placeholder="请输入撤销人姓名"  ></a-input>
            </a-form-model-item>
          </a-col>
          <a-col :span="24">
            <a-form-model-item label="派发方式:1=手动派发，2=系统派发" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="grantType">
              <a-input-number v-model="model.grantType" placeholder="请输入派发方式:1=手动派发，2=系统派发" style="width: 100%" />
            </a-form-model-item>
          </a-col>
          <a-col :span="24">
            <a-form-model-item label="派发时间" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="grantTime">
              <j-date placeholder="请选择派发时间" v-model="model.grantTime"  style="width: 100%" />
            </a-form-model-item>
          </a-col>
          <a-col :span="24">
            <a-form-model-item label="撤销时间" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="repealTime">
              <j-date placeholder="请选择撤销时间" v-model="model.repealTime"  style="width: 100%" />
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
    name: 'ShoeCouponRecordForm',
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
           couponRecordId: [
              { required: true, message: '请输入优惠券发放记录ID!'},
           ],
           couponId: [
              { required: true, message: '请输入优惠券id!'},
           ],
           userId: [
              { required: true, message: '请输入用户id!'},
           ],
           userCouponId: [
              { required: true, message: '请输入用户优惠券id!'},
           ],
           recordNo: [
              { required: true, message: '请输入发放批次(从1递增)!'},
           ],
           status: [
              { required: true, message: '请输入状态:0=冻结，1=正常!'},
           ],
           grantType: [
              { required: true, message: '请输入派发方式:1=手动派发，2=系统派发!'},
           ],
           grantTime: [
              { required: true, message: '请输入派发时间!'},
           ],
           repealTime: [
              { required: true, message: '请输入撤销时间!'},
           ],
        },
        url: {
          add: "/shoeCouponRecord/shoeCouponRecord/add",
          edit: "/shoeCouponRecord/shoeCouponRecord/edit",
          queryById: "/shoeCouponRecord/shoeCouponRecord/queryById"
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