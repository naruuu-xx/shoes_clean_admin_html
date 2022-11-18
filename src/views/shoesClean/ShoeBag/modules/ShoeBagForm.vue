<template>
  <a-spin :spinning="confirmLoading">
    <j-form-container :disabled="formDisabled">
      <a-form-model ref="form" :model="model" :rules="validatorRules" slot="detail">
        <a-row>
<!--          <a-col :span="24">-->
<!--            <a-form-model-item label="ID" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="bagId">-->
<!--              <a-input-number v-model="model.bagId" placeholder="请输入ID" style="width: 100%" />-->
<!--            </a-form-model-item>-->
<!--          </a-col>-->
<!--          <a-col :span="24">-->
<!--            <a-form-model-item label="工厂编码" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="orgCode">-->
<!--              <a-input v-model="model.orgCode" placeholder="请输入工厂编码"  ></a-input>-->
<!--            </a-form-model-item>-->
<!--          </a-col>-->
<!--          <a-col :span="24">-->
<!--            <a-form-model-item label="袋子编码" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="bagCode">-->
<!--              <a-input v-model="model.bagCode" placeholder="请输入袋子编码"  ></a-input>-->
<!--            </a-form-model-item>-->
<!--          </a-col>-->
          <a-col :span="24">
            <a-form-model-item label="袋子状态" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="status">
<!--              <a-input-number v-model="model.status" placeholder="请输入状态:0=异常,1=正常" style="width: 100%" />-->
              <j-dict-select-tag type="radio" v-model="model.status" dictCode="shoe_bag_status" placeholder="请选择状态"/>
            </a-form-model-item>
          </a-col>
<!--          <a-col :span="24">-->
<!--            <a-form-model-item label="使用状态:0=空闲,1=使用中" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="useStatus">-->
<!--              <a-input-number v-model="model.useStatus" placeholder="请输入使用状态:0=空闲,1=使用中" style="width: 100%" />-->
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
    name: 'ShoeBagForm',
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
           bagId: [
              { required: false, message: '请输入ID!'},
           ],
           orgCode: [
              { required: false, message: '请输入工厂编码!'},
           ],
           bagCode: [
              { required: false, message: '请输入袋子编码!'},
           ],
           status: [
              { required: true, message: '请选择袋子状态!'},
           ],
           useStatus: [
              { required: false, message: '请选择使用状态!'},
           ],
        },
        url: {
          add: "/ShoeBag/shoeBag/add",
          edit: "/ShoeBag/shoeBag/edit",
          queryById: "/ShoeBag/shoeBag/queryById"
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