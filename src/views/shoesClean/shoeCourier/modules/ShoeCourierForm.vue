<template>
  <a-spin :spinning="confirmLoading">
    <j-form-container :disabled="formDisabled">
      <a-form-model ref="form" :model="model" :rules="validatorRules" slot="detail">
        <a-row>
          <a-col :span="24">
            <a-form-model-item label=" 姓名" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="name">
              <a-input v-model="model.name" placeholder="请输入 姓名"  ></a-input>
            </a-form-model-item>
          </a-col>
          <a-col :span="24">
            <a-form-model-item label=" 电话（账号）" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="phone">
              <a-input v-model="model.phone" placeholder="请输入 电话（账号）"  ></a-input>
            </a-form-model-item>
          </a-col>
          <a-col :span="24">
            <a-form-model-item label=" 身份证" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="idcard">
              <a-input v-model="model.idcard" placeholder="请输入 身份证"  ></a-input>
            </a-form-model-item>
          </a-col>
          <a-col :span="24">
            <a-form-model-item label=" 密码" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="password" v-if="this.model.courierId === null || this.model.courierId === undefined">
              <a-input-password v-model="model.password" placeholder="请输入 密码" />
            </a-form-model-item>
          </a-col>
          <a-col :span="24">
            <a-form-model-item label=" 绑定机柜编码" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="lockerId">
              <a-select v-model="model.lockerId">
                <a-select-option v-for="i in lockerList" :value="i.lockerId+''" :key="i.lockerId">{{i.lockerCode}}</a-select-option>
              </a-select>
            </a-form-model-item>
          </a-col>
<!--          <a-col :span="24">-->
<!--            <a-form-model-item label=" 总配送单数" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="num">-->
<!--              <a-input-number v-model="model.num" placeholder="请输入 总配送单数" style="width: 100%" />-->
<!--            </a-form-model-item>-->
<!--          </a-col>-->
<!--          <a-col :span="24">-->
<!--            <a-form-model-item label=" 总收入" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="income">-->
<!--              <a-input-number v-model="model.income" placeholder="请输入 总收入" style="width: 100%" />-->
<!--            </a-form-model-item>-->
<!--          </a-col>-->
<!--          <a-col :span="24">-->
<!--            <a-form-model-item label=" 账户金额" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="amount">-->
<!--              <a-input-number v-model="model.amount" placeholder="请输入 账户金额" style="width: 100%" />-->
<!--            </a-form-model-item>-->
<!--          </a-col>-->
<!--          <a-col :span="24">-->
<!--            <a-form-model-item label=" 提现中金额" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="withdrawal">-->
<!--              <a-input-number v-model="model.withdrawal" placeholder="请输入 提现中金额" style="width: 100%" />-->
<!--            </a-form-model-item>-->
<!--          </a-col>-->
<!--          <a-col :span="24">-->
<!--            <a-form-model-item label=" 冻结金额" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="frozenAmount">-->
<!--              <a-input-number v-model="model.frozenAmount" placeholder="请输入 冻结金额" style="width: 100%" />-->
<!--            </a-form-model-item>-->
<!--          </a-col>-->
          <a-col :span="24">
            <a-form-model-item label="登录状态" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="status">
              <j-dict-select-tag type="radio" v-model="model.status" dictCode="shoe_courier_status" placeholder="请选择登录状态" />
            </a-form-model-item>
          </a-col>
<!--          <a-col :span="24">-->
<!--            <a-form-model-item label="删除状态" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="delFlag">-->
<!--              <j-dict-select-tag type="radio" v-model="model.delFlag" dictCode="" placeholder="请选择 删除状态:0=正常,1=删除" />-->
<!--            </a-form-model-item>-->
<!--          </a-col>-->
        </a-row>
      </a-form-model>
    </j-form-container>
  </a-spin>
</template>

<script>

  import { httpAction, getAction } from '@/api/manage'
  import { validateDuplicateValue } from '@/utils/util'

  export default {
    name: 'ShoeCourierForm',
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
           name: [
              { required: true, message: '请输入 姓名!'},
           ],
           phone: [
              { required: true, message: '请输入 电话（账号）!'},
              { pattern: /^1[3456789]\d{9}$/, message: '请输入正确的手机号码!'},
           ],
           idcard: [
              { required: true, message: '请输入 身份证!'},
              {validator: this.validateIdCard}
           ],
           password: [
              { required: true, message: '请输入 密码!'},
              { pattern: /^.{6,16}$/, message: '请输入6到16位任意字符!'},
           ],
           num: [
              { required: true, message: '请输入 总配送单数!'},
           ],
           income: [
              { required: true, message: '请输入 总收入!'},
           ],
           amount: [
              { required: true, message: '请输入 账户金额!'},
           ],
           withdrawal: [
              { required: true, message: '请输入 提现中金额!'},
           ],
           frozenAmount: [
              { required: true, message: '请输入 冻结金额!'},
           ],
           status: [
              { required: true, message: '请选择 状态'},
           ],
           delFlag: [
              { required: true, message: '请输入 删除状态:0=正常,1=删除!'},
           ],
          lockerId: [
              { required: true, message: '请选择快递柜!'},
           ],
        },
        url: {
          add: "/shoeCourier/shoeCourier/add",
          edit: "/shoeCourier/shoeCourier/edit",
          queryById: "/shoeCourier/shoeCourier/queryById"
        },
        lockerList:[],
      }
    },
    computed: {
      formDisabled(){
        return this.disabled
      },
    },
    created () {
      this.getLockerList();
       //备份model原始值
      this.modelDefault = JSON.parse(JSON.stringify(this.model));
    },
    methods: {
      validateIdCard(rule, value, callback) {
        if(!value || new RegExp(/^([1-6][1-9]|50)\d{4}(18|19|20)\d{2}((0[1-9])|10|11|12)(([0-2][1-9])|10|20|30|31)\d{3}[0-9Xx]$/
        ).test(value) || new RegExp(/^([1-6][1-9]|50)\d{4}\d{2}((0[1-9])|10|11|12)(([0-2][1-9])|10|20|30|31)\d{3}$/).test(value)){
          callback();
        }
        else{
          callback("您输入的身份证格式不正确!");
        }
      },
      add () {
        this.edit(this.modelDefault);
      },
      edit (record) {
        this.model = Object.assign({}, record);
        this.model.lockerId = record.lockerId.toString();
        this.model.lockerCode = record.lockerCode;
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
            if(!this.model.courierId){
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
      getLockerList(){
        httpAction("/shoes/shoeLocker/lockerList", null, "get").then((res) => {
          if (res.success) {
            this.lockerList = res.result;
          }
        })
      }
    }
  }
</script>