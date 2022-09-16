<template>
  <a-spin :spinning="confirmLoading">
    <j-form-container :disabled="formDisabled">
      <a-form-model ref="form" :model="model" :rules="validatorRules" slot="detail">
        <a-row>
          <a-col :span="24">
            <a-form-model-item label="小程序open_id" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="openId">
              <a-input v-model="model.openId" placeholder="请输入小程序open_id"  ></a-input>
            </a-form-model-item>
          </a-col>
          <a-col :span="24">
            <a-form-model-item label="推荐人用户id" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="pId">
              <a-input v-model="model.pId" placeholder="请输入推荐人用户id"  ></a-input>
            </a-form-model-item>
          </a-col>
          <a-col :span="24">
            <a-form-model-item label="微信昵称" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="nicakname">
              <a-input v-model="model.nicakname" placeholder="请输入微信昵称"  ></a-input>
            </a-form-model-item>
          </a-col>
          <a-col :span="24">
            <a-form-model-item label="头像" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="avatar">
              <a-input v-model="model.avatar" placeholder="请输入头像"  ></a-input>
            </a-form-model-item>
          </a-col>
          <a-col :span="24">
            <a-form-model-item label="手机号码" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="phone">
              <a-input v-model="model.phone" placeholder="请输入手机号码"  ></a-input>
            </a-form-model-item>
          </a-col>
          <a-col :span="24">
            <a-form-model-item label="总支付金额（分）" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="payAmount">
              <a-input-number v-model="model.payAmount" placeholder="请输入总支付金额（分）" style="width: 100%" />
            </a-form-model-item>
          </a-col>
          <a-col :span="24">
            <a-form-model-item label="实际消费金额" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="actualAmount">
              <a-input-number v-model="model.actualAmount" placeholder="请输入实际消费金额" style="width: 100%" />
            </a-form-model-item>
          </a-col>
          <a-col :span="24">
            <a-form-model-item label="最近登录时间" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="lastLoginTime">
              <j-date placeholder="请选择最近登录时间" v-model="model.lastLoginTime"  style="width: 100%"  disabled/>
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
    name: 'ShoeUserForm',
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
           openId: [
              { required: true, message: '请输入小程序open_id!'},
           ],
           pId: [
              { required: true, message: '请输入推荐人用户id!'},
           ],
           nicakname: [
              { required: true, message: '请输入微信昵称!'},
           ],
           avatar: [
              { required: true, message: '请输入头像!'},
           ],
           phone: [
              { required: true, message: '请输入手机号码!'},
           ],
           payAmount: [
              { required: true, message: '请输入总支付金额（分）!'},
           ],
           actualAmount: [
              { required: true, message: '请输入实际消费金额!'},
           ],
        },
        url: {
          add: "/org.jeecg.modules.shoes/shoeUser/add",
          edit: "/org.jeecg.modules.shoes/shoeUser/edit",
          queryById: "/org.jeecg.modules.shoes/shoeUser/queryById"
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