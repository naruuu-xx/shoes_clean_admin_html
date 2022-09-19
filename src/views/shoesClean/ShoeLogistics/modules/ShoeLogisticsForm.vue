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
            <a-form-model-item label=" 手机号（账号）" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="phone">
              <a-input v-model="model.phone" placeholder="请输入 手机号（账号）"  ></a-input>
            </a-form-model-item>
          </a-col>
          <a-col :span="24">
            <a-form-model-item label=" 绑定机柜编码" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="lockerId">
<!--              <a-input v-model="model.lockerId" placeholder="请输入机柜编码"  ></a-input>-->
              <a-select v-model="model.lockerId">
                <a-select-option v-for="i in lockerList" :value="i.lockerId+''" :key="i.lockerId">{{i.lockerCode}}</a-select-option>
              </a-select>
            </a-form-model-item>
          </a-col>

          <a-col :span="24">
            <template v-if="!model.logisticsId">
              <a-form-model-item label="登录密码" :labelCol="labelCol" :wrapperCol="wrapperCol"  prop="password" >
                <a-input v-model="model.password" type="password" placeholder="请输入登录密码" />
              </a-form-model-item>
              <a-form-model-item label="确认密码" :labelCol="labelCol" :wrapperCol="wrapperCol"  prop="confirmpassword">
                <a-input v-model="model.confirmpassword" type="password" @blur="handleConfirmBlur" placeholder="请重新输入登录密码" />
              </a-form-model-item>
            </template>

          </a-col>


          <a-col :span="24">
            <a-form-model-item label=" 状态" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="status">
              <j-switch v-model="model.status"  ></j-switch>
            </a-form-model-item>
          </a-col>
        </a-row>
      </a-form-model>
    </j-form-container>
  </a-spin>
</template>

<script>

  // import { httpAction, getAction } from '@/api/manage'
  // import { validateDuplicateValue } from '@/utils/util'

  import { httpAction } from '@api/manage'

  export default {
    name: 'ShoeLogisticsForm',
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
        confirmDirty: false,
        model:{
            status:[1,0],
          password:'',
          lockerId:0,
          lockerCode:'',
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
              { required: true, message: '请输入 手机号（账号）!'},
              { pattern: /^1[3456789]\d{9}$/, message: '请输入正确的手机号码!'},
           ],
           status: [
              { required: true, message: '请输入 状态:0=禁用,1=正常!'},
           ],
          lockerId:[
            { required: true, message: '请输入机柜编码'},
          ],
          password: [{required: true,pattern:/^(?=.*[a-zA-Z])(?=.*\d)(?=.*[~!@#$%^&*()_+`\-={}:";'<>?,./]).{8,}$/,message: '密码由8位数字、大小写字母和特殊符号组成!'},
            {validator: this.validateToNextPassword,trigger: 'change'}],
          confirmpassword: [{required: true, message: '请重新输入登录密码!'},
            { validator: this.compareToFirstPassword,}],
        },
        url: {
          add: "/shoes/shoeLogistics/add",
          edit: "/shoes/shoeLogistics/edit",
          queryById: "/shoes/shoeLogistics/queryById"
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
      add () {
        this.edit(this.modelDefault);
      },
      edit (record) {
        // record.lockerId = this.model.lockerId;
        console.log("codeId     :"+record.lockerId);
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
            if(!this.model.logisticsId){
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
      validateToNextPassword (rule, value, callback) {
        const confirmpassword=this.model.confirmpassword;
        if (value && confirmpassword && value !== confirmpassword) {
          callback('两次输入的密码不一样！');
        }
        if (value && this.confirmDirty) {
          this.$refs.form.validateField(['confirmpassword']);
        }
        callback();
      },
      compareToFirstPassword (rule, value, callback) {
        if (value && value !== this.model.password) {
          callback('两次输入的密码不一样！');
        } else {
          callback()
        }
      },
      handleConfirmBlur  (e) {
        const value = e.target.value
        this.confirmDirty = this.confirmDirty || !!value
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