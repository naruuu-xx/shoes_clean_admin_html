<template>
  <a-spin :spinning="confirmLoading">
    <j-form-container :disabled="formDisabled">
      <a-form-model ref="form" :model="model" :rules="validatorRules" slot="detail">
        <a-row>
          <a-col :span="24">
            <a-form-model-item label="姓名" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="name">
              <a-input v-model="model.name" placeholder="请输入姓名"  ></a-input>
            </a-form-model-item>
          </a-col>
          <a-col :span="24">
            <a-form-model-item label="手机号" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="phone">
              <a-input v-model="model.phone" placeholder="请输入手机号"  ></a-input>
            </a-form-model-item>
          </a-col>
          <a-col :span="24">
            <a-form-model-item label="身份" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="level">
              <a-select v-model="model.level" >
                  <a-select-option value = "1" >代理人</a-select-option>
                  <a-select-option value = "2" >投资人</a-select-option>
              </a-select>
            </a-form-model-item>
          </a-col>
          <a-col :span="24">
            <a-form-model-item label="绑定小程序账号" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="userId">
              <a-select
                show-search
                placeholder="选择或搜索需要绑定的用户"
                option-filter-prop="children"
                style="width: 200px"
                :filter-option="filterOption"
                v-model="model.userId"
              >
                <a-select-option  v-for="i in shoeUserList" :value="i.userId" :key="i.nickname">
                  {{i.nickname}}
                </a-select-option>
              </a-select>
            </a-form-model-item>
          </a-col>
          <a-col :span="24">
            <a-form-model-item label="绑定上级" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="investorsPId" v-if="model.level == 2">
              <a-select
                show-search
                placeholder="选择或搜索需要绑定的用户"
                option-filter-prop="children"
                style="width: 200px"
                :filter-option="filterOption"
                v-model="model.investorsPId"
              >
                <a-select-option  v-for="i in agentList" :value="i.investorsId" :key="i.nickname">
                  {{i.nickname}}
                </a-select-option>
              </a-select>
            </a-form-model-item>
          </a-col>
          <a-col :span="24">
            <a-form-model-item label="绑定机柜" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="lockerId" >
              <a-select
                mode="multiple"
                show-search
                placeholder="选择或搜索需要绑定的用户"
                option-filter-prop="children"
                style="width: 200px"
                :filter-option="filterOption"
                v-model="model.lockerIds"
              >
                <a-select-option  v-for="i in lockerList" :value="i.lockerId" :key="i.lockerId">
                  {{i.name}}
                </a-select-option>
              </a-select>
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
    name: 'ShoeInvestorsForm',
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
              { required: true, message: '请输入姓名!'},
           ],
           phone: [
              { required: true, message: '请输入手机号!'},
             { pattern: /^1[3456789]\d{9}$/, message: '请输入正确的手机号码!'},
           ],
           level: [
              { required: true, message: '请选择身份!'},
           ],
           userId: [
              { required: true, message: '请选择绑定小程序用户id!'},
           ],
          investorsPId:[
            { required: false, message: '请选择绑定上级!'},
          ]
        },
        url: {
          add: "/shoes/shoeInvestors/add",
          edit: "/shoes/shoeInvestors/edit",
          queryById: "/shoes/shoeInvestors/queryById"
        },
        levelTextList:[],
        shoeUserList:[],
        lockerList:[],
        agentList:[]
      }
    },
    computed: {
      formDisabled(){
        return this.disabled
      },
    },
    created () {
       //备份model原始值
      this.getLevelTextList();
      this.getShoeUserList();
      this.getLockerList();
      this.getAgentList();
      this.modelDefault = JSON.parse(JSON.stringify(this.model));
    },
    methods: {
      filterOption(input, option) {
        return (
          option.componentOptions.children[0].text.toLowerCase().indexOf(input.toLowerCase()) >= 0
        );
      },
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
            console.log("ceshi.....");
            console.log(this.model.investorsId);
            if(!this.model.investorsId){
              httpurl+=this.url.add;
              method = 'post';
            }else{
              httpurl+=this.url.edit;
               method = 'put';
              this.model.income = parseInt(this.model.income)*100;
              this.model.amount = parseInt(this.model.amount)*100;
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
      getLevelTextList(){
        httpAction("/shoes/shoeInvestors/statusList", null, "get").then((res) => {
          if (res){
            this.levelTextList = res.result;
          }
        })
      },
      getShoeUserList(){
        httpAction("/shoes/shoeUser/shoeUserList",null, "get").then((res)=>{
          if(res){
            console.log(res.result);
            this.shoeUserList = res.result;

          }
        })
      },
      getLockerList(){
        httpAction("/shoes/shoeLocker/investorsShoeLockerList",null,"get").then((res)=>{
          if(res){
            this.lockerList = res.result;
          }
        })
      },
      getAgentList(){
        httpAction("/shoes/shoeInvestors/agentList", null, "get").then((res)=>{
          if(res){
            this.agentList = res.result;

          }
        })
      }
    }
  }
</script>