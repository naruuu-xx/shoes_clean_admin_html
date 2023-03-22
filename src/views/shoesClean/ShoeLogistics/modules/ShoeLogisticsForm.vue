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
            <a-form-model-item label=" 手机号" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="phone">
              <a-input v-model="model.phone" placeholder="请输入 手机号（账号）"  ></a-input>
            </a-form-model-item>
          </a-col>
          <a-col :span="24">
            <a-form-model-item label=" 绑定快递柜" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="lockerCodeList">
              <a-select v-model="model.lockerCodeList" mode="multiple">
                <a-select-option v-for="i in lockerList" :value="i.lockerCode" :key="i.lockerCode">{{i.name}}</a-select-option>
              </a-select>
            </a-form-model-item>
          </a-col>
          <a-col :span="24">
            <a-form-model-item label=" 绑定站点" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="siteCodeList">
              <a-select v-model="model.siteCodeList" mode="multiple">
                <a-select-option v-for="i in siteList" :value="i.lockerCode" :key="i.lockerCode">{{i.name}}</a-select-option>
              </a-select>
            </a-form-model-item>
          </a-col>

          <a-col :span="24">
            <template v-if="!model.logisticsId">
              <a-form-model-item label="登录密码" :labelCol="labelCol" :wrapperCol="wrapperCol"  prop="password" >
                <a-input v-model="model.password" type="password" placeholder="请输入登录密码" />
              </a-form-model-item>
<!--              <a-form-model-item label="确认密码" :labelCol="labelCol" :wrapperCol="wrapperCol"  prop="confirmpassword">-->
<!--                <a-input v-model="model.confirmpassword" type="password" @blur="handleConfirmBlur" placeholder="请重新输入登录密码" />-->
<!--              </a-form-model-item>-->
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
          logisticsId:'',
          status:'1',
          password:'',
          lockerIdList:[],
          siteIdList:[],
          lockerCodeList:[],
          siteCodeList:[],
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
              { required: true, message: '请输入选择状态!'},
           ],
          password: [{required: true,pattern:/^.{6,16}$/,message: '请输入6到16位任意字符!'},
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
        siteList:[],
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
        this.getLockerList();
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
            that.setModel();
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
        httpAction("/shoes/shoeLogistics/lockerList?logisticsId=" + this.model.logisticsId, "", "get").then((res) => {
          if (res.success) {
            this.lockerList = res.result.lockerList;
            this.siteList = res.result.siteList;
          }
        })
      },
      setModel(){
        const that = this;
        let lockerIdList = [];
        for(let i = 0; i < that.lockerList.length; i++){
          if(that.model.lockerCodeList.indexOf(that.lockerList[i].lockerCode) != -1){
            lockerIdList.push(that.lockerList[i].lockerId);
          }
        }
        that.model.lockerIdList = lockerIdList;

        let siteIdList = [];
        for(let i = 0; i < that.siteList.length; i++){
          if(that.model.siteCodeList.indexOf(that.siteList[i].lockerCode) != -1){
            siteIdList.push(that.siteList[i].lockerId);
          }
        }

        that.model.siteIdList = siteIdList;

      }
    }
  }
</script>