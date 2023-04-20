<template>
  <a-spin :spinning="confirmLoading">
    <j-form-container :disabled="formDisabled">
      <a-form-model ref="form" :model="model" :rules="validatorRules" slot="detail">
        <a-row>

          <a-col :span="24">
            <a-form-model-item label="设置访问域名:" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="keyword">
              xf.beeshoes.cn/l/
              <a-input v-model="model.keyword" placeholder="请输入域名后缀"  ></a-input>
              (只能输入英文字母，请勿输入标点符号。)
            </a-form-model-item>
          </a-col>
          <a-col :span="24">
            <a-form-model-item label="跳转类型" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="type">
              <a-radio-group v-model:value="model.type">
                <a-radio value="1">鞋蜂小程序</a-radio>
                <a-radio value="2">公众号文章</a-radio>
              </a-radio-group>
            </a-form-model-item>
          </a-col>
          <a-col :span="24">
            <a-form-model-item label="目标地址" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="toUrl">
              <a-input v-model="model.toUrl" placeholder="请输入目标地址"  ></a-input>
            </a-form-model-item>
          </a-col>
          <a-col :span="24">
            <a-form-model-item label="状态" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="status">
              <a-radio-group v-model:value="model.status" >
                <a-radio value="0">停用</a-radio>
                <a-radio value="1">启用</a-radio>
              </a-radio-group>
            </a-form-model-item>
          </a-col>
          <a-col :span="24">
            <a-form-model-item label="备注" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="note">
              <a-input v-model="model.note" placeholder="请输入备注"  ></a-input>
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
    name: 'ShoeLinkForm',
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

           keyword: [
              { required: true, message: '请输入域名后缀!'},
           ],
           url: [
              { required: true, message: '请输入完整域名!'},
           ],
           type: [
              { required: true, message: '请选择跳转类型'},
           ],
           toUrl: [
              { required: true, message: '请输入目标地址!'},
           ],
           status: [
              { required: true, message: '请选择状态!'},
           ],
           note: [
              { required: true, message: '请输入备注!'},
           ],
           delFlag: [
              { required: true, message: '请输入软删除标识：0=正常，1=删除!'},
           ],
           addUserId: [
              { required: true, message: '请输入添加人id!'},
           ],
           updateUserId: [
              { required: true, message: '请输入最后操作人姓名!'},
           ],
        },
        url: {
          add: "/shoeLink/add",
          edit: "/shoeLink/edit",
          queryById: "/shoeLink/shoeLink/queryById"
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
            if(!this.model.linkId){
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