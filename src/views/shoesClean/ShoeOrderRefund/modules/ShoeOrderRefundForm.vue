<template>
  <a-spin :spinning="confirmLoading">
    <j-form-container :disabled="formDisabled">
      <a-form-model ref="form" :model="model" :rules="validatorRules" slot="detail">
        <a-row>
          <a-col :span="24">
            <a-form-model-item label="订单退款ID" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="orderRefundId">
              <a-input-number v-model="model.orderRefundId" placeholder="请输入订单退款ID" style="width: 100%" />
            </a-form-model-item>
          </a-col>
          <a-col :span="24">
            <a-form-model-item label="父订单ID" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="orderPId">
              <a-input-number v-model="model.orderPId" placeholder="请输入父订单ID" style="width: 100%" />
            </a-form-model-item>
          </a-col>
          <a-col :span="24">
            <a-form-model-item label="子订单ID" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="orderId">
              <a-input-number v-model="model.orderId" placeholder="请输入子订单ID" style="width: 100%" />
            </a-form-model-item>
          </a-col>
          <a-col :span="24">
            <a-form-model-item label="商户订单号" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="outTradeNo">
              <a-input v-model="model.outTradeNo" placeholder="请输入商户订单号"  ></a-input>
            </a-form-model-item>
          </a-col>
          <a-col :span="24">
            <a-form-model-item label="商户退款单号" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="outRefundNo">
              <a-input v-model="model.outRefundNo" placeholder="请输入商户退款单号"  ></a-input>
            </a-form-model-item>
          </a-col>
          <a-col :span="24">
            <a-form-model-item label="订单实付金额" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="actualPrice">
              <a-input-number v-model="model.actualPrice" placeholder="请输入订单实付金额" style="width: 100%" />
            </a-form-model-item>
          </a-col>
          <a-col :span="24">
            <a-form-model-item label="退款金额" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="refundPrice">
              <a-input-number v-model="model.refundPrice" placeholder="请输入退款金额" style="width: 100%" />
            </a-form-model-item>
          </a-col>
          <a-col :span="24">
            <a-form-model-item label="退款场景：0=超时自动取消退款，1=用户申请退款，2=后台发起退款" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="scene">
              <a-input-number v-model="model.scene" placeholder="请输入退款场景：0=超时自动取消退款，1=用户申请退款，2=后台发起退款" style="width: 100%" />
            </a-form-model-item>
          </a-col>
          <a-col :span="24">
            <a-form-model-item label="退款原因 " :labelCol="labelCol" :wrapperCol="wrapperCol" prop="reason">
              <a-input v-model="model.reason" placeholder="请输入退款原因 "  ></a-input>
            </a-form-model-item>
          </a-col>
          <a-col :span="24">
            <a-form-model-item label="退款状态:0=退款中，1=退款成功，2=退款失败" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="refundStatus">
              <a-input-number v-model="model.refundStatus" placeholder="请输入退款状态:0=退款中，1=退款成功，2=退款失败" style="width: 100%" />
            </a-form-model-item>
          </a-col>
          <a-col :span="24">
            <a-form-model-item label="退款成功时间" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="successTime">
              <j-date placeholder="请选择退款成功时间" v-model="model.successTime"  style="width: 100%" />
            </a-form-model-item>
          </a-col>
          <a-col :span="24">
            <a-form-model-item label="操作人" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="sysUserId">
              <a-input v-model="model.sysUserId" placeholder="请输入操作人"  ></a-input>
            </a-form-model-item>
          </a-col>
          <a-col :span="24">
            <a-form-model-item label="备注" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="note">
              <a-input v-model="model.note" placeholder="请输入备注"  ></a-input>
            </a-form-model-item>
          </a-col>
          <a-col :span="24">
            <a-form-model-item label="退款说明" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="description">
              <a-input v-model="model.description" placeholder="请输入退款说明"  ></a-input>
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
    name: 'ShoeOrderRefundForm',
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
           orderRefundId: [
              { required: true, message: '请输入订单退款ID!'},
           ],
           orderPId: [
              { required: true, message: '请输入父订单ID!'},
           ],
           orderId: [
              { required: true, message: '请输入子订单ID!'},
           ],
           outTradeNo: [
              { required: true, message: '请输入商户订单号!'},
           ],
           outRefundNo: [
              { required: true, message: '请输入商户退款单号!'},
           ],
           actualPrice: [
              { required: true, message: '请输入订单实付金额!'},
           ],
           refundPrice: [
              { required: true, message: '请输入退款金额!'},
           ],
           scene: [
              { required: true, message: '请输入退款场景：0=超时自动取消退款，1=用户申请退款，2=后台发起退款!'},
           ],
           reason: [
              { required: true, message: '请输入退款原因 !'},
           ],
           refundStatus: [
              { required: true, message: '请输入退款状态:0=退款中，1=退款成功，2=退款失败!'},
           ],
           sysUserId: [
              { required: true, message: '请输入操作人!'},
           ],
           description: [
              { required: true, message: '请输入退款说明!'},
           ],
        },
        url: {
          add: "/shoes/shoeOrderRefund/add",
          edit: "/shoes/shoeOrderRefund/edit",
          queryById: "/shoes/shoeOrderRefund/queryById"
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