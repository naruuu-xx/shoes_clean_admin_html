<template>
  <a-spin :spinning="confirmLoading">
    <j-form-container :disabled="formDisabled">
      <a-form-model ref="form" :model="model" :rules="validatorRules" slot="detail">
        <a-row>
          <a-col :span="24" v-if="model.isEdit != 1">
            <a-form-model-item label="推广渠道类型" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="type">
              <a-radio-group v-model:value="model.type" >
                <a-radio value="1">推广人</a-radio>
                <a-radio value="2">其他</a-radio>
              </a-radio-group>
            </a-form-model-item>
          </a-col>
          <a-col :span="24">
            <a-form-model-item label="推广渠道名称" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="channel">
              <a-input v-model="model.channel" placeholder="请输入推广渠道名称"  ></a-input>
            </a-form-model-item>
          </a-col>
<!--          <a-col :span="24" v-if="model.type == 1">-->
<!--            <a-form-model-item label="推广人绑定用户id" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="userId">-->
<!--              <a-input-number v-model="model.userId" placeholder="请输入推广人绑定用户id" style="width: 100%" />-->
<!--            </a-form-model-item>-->
<!--          </a-col>-->
          <a-col :span="24" v-if="model.type == 1">
            <a-form-model-item label="绑定小程序账号" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="userId">
              <a-select
                show-search
                placeholder="选择或搜索需要绑定的用户"
                option-filter-prop="children"
                style="width: 200px"
                :filter-option="filterOption"
                v-model="model.userId"
              >
                <a-select-option  v-for="i in shoeUserList" :value="i.userId.toString()" :key="i.nickname">
                  {{i.nickname}}
                </a-select-option>
              </a-select>
            </a-form-model-item>
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

  import { httpAction, getAction } from '@/api/manage'
  import { validateDuplicateValue } from '@/utils/util'

  export default {
    name: 'ShoePromotionForm',
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
          status:'1',
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
           channel: [
              { required: true, message: '请输入推广渠道名称!'},
           ],
           type: [
              { required: true, message: '请输入推广渠道类型（1=推广人，2=其他）!'},
           ],
           userId: [
              { required: true, message: '请输入推广人绑定用户id!'},
           ],
           status: [
              { required: true, message: '请输入推广状态（0=禁用，1=启用）!'},
           ],
        },
        url: {
          add: "/shoes/shoePromotion/add",
          edit: "/shoes/shoePromotion/edit",
          queryById: "/shoes/shoePromotion/queryById"
        },
        shoeUserList:[],
      }
    },
    computed: {
      formDisabled(){
        return this.disabled
      },
    },
    created () {
       //备份model原始值
      this.getShoeUserList();
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
        this.model.isEdit = 0;
      },
      edit (record) {
        this.model = Object.assign({}, record);
        this.getShoeUserList();
        this.model.isEdit = 1;
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
            if(!this.model.promotionId){
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
      getShoeUserList(){
        httpAction("/shoes/shoeUser/shoeUserListByPromotionId?promotionId="+this.model.promotionId,"", "get").then((res)=>{
          if(res){
            console.log(res.result);
            this.shoeUserList = res.result;

          }
        })
      },
    }
  }
</script>