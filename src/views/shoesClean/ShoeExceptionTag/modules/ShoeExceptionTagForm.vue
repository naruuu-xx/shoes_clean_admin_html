<template>
  <a-spin :spinning="confirmLoading">
    <j-form-container :disabled="formDisabled">
      <a-form-model ref="form" :model="model" :rules="validatorRules" slot="detail">
        <a-row>
          <a-col :span="24">
            <a-form-model-item label="订单编号" :labelCol="labelCol" :wrapperCol="wrapperCol">
              <h3>{{this.model.no}}</h3>
            </a-form-model-item>
          </a-col>
          <a-col :span="24">
            <a-form-model-item label="商品名称" :labelCol="labelCol" :wrapperCol="wrapperCol">
              <h3>{{this.model.title}}</h3>
            </a-form-model-item>
          </a-col>
          <a-col :span="24">
            <a-form-model-item label="商品规格" :labelCol="labelCol" :wrapperCol="wrapperCol">
              <h3>{{this.model.skuTitle}}</h3>
            </a-form-model-item>
          </a-col>

          <a-col :span="24">
            <a-form-model-item label="订单图片" :labelCol="labelCol" :wrapperCol="wrapperCol">
              <j-image-upload isMultiple  v-model="model.images" ></j-image-upload>
            </a-form-model-item>
          </a-col>
          <a-col :span="24">
            <a-form-model-item label="入库图片" :labelCol="labelCol" :wrapperCol="wrapperCol" help="请选择至少一张图片作为异常图片">
              <j-image-upload isMultiple  v-model="model.factoryImages" ></j-image-upload>
            </a-form-model-item>
          </a-col>


          <a-col :span="24">
            <a-form-model-item label="处理方式" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="dealType">
              <a-radio-group v-model:value="model.dealType">
                <a-radio value="1">转异常</a-radio>
                <a-radio value="2">继续洗</a-radio>
              </a-radio-group>
            </a-form-model-item>
          </a-col>
          <a-col :span="24">

            <a-form-model-item :label="this.model.dealType==2?'备注':'异常描述'" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="note">
              <a-input placeholder="请输入订单备注" v-model="model.note"  />
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
    name: 'ShoeExceptionTagForm',
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
        date:{},
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

           dealType: [
              { required: true, message: '请选择处理方式!'},
           ],
           note: [
              { required: true, message: '请输入!'},
           ],
        },
        url: {
          add: "/shoeExceptionTag/add",
          edit: "/shoeExceptionTag/edit",
          queryById: "/shoeExceptionTag/shoeExceptionTag/queryById"
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
        this.model = Object.assign({
          images:[],
          factoryImages:[]
        }, record);
        this.model.dealType="1"
        this.getImages(record);
        this.visible = true;
      },
      getImages(record){
        httpAction("/shoeExceptionTag/getImages?no="+record.no,null,"get").then((res)=>{
          if (res.success){
            this.model.images=res.result.orderList
            this.model.factoryImages=res.result.factoryList
            console.log("111",this.model)

          }
        })
      },
      submitForm () {
        const that = this;
        // 触发表单验证
        this.$refs.form.validate(valid => {
          if (valid) {
            that.confirmLoading = true;
            let httpurl = '';
            let method = '';
            if(!this.model.exceptionTagId){
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