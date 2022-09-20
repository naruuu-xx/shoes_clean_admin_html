<template>
  <a-spin :spinning="confirmLoading">
    <j-form-container :disabled="formDisabled">
      <a-form-model ref="form" :model="model" :rules="validatorRules" slot="detail">
        <a-row>
<!--          <a-col :span="24">-->
<!--            <a-form-model-item label="ID" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="goodsId">-->
<!--              <a-input-number v-model="model.goodsId" placeholder="请输入ID" style="width: 100%" />-->
<!--            </a-form-model-item>-->
<!--          </a-col>-->
<!--          <a-col :span="24">-->
<!--            <template v-if="!model.goodsId">-->
<!--              <a-form-model-item label="类型" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="type" >-->
<!--                <a-select v-model="model.type">-->
<!--                  <a-select-option  value="repair" >修复</a-select-option>-->
<!--                </a-select>-->
<!--              </a-form-model-item>-->
<!--            </template>-->
<!--          </a-col>-->
          <a-col :span="24">
            <a-form-model-item label="商品名称" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="title">
              <a-input v-model="model.title" placeholder="请输入商品名称"  ></a-input>
            </a-form-model-item>
          </a-col>
          <a-col :span="24">
            <a-form-model-item label="主图" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="images">
<!--              <a-textarea v-model="model.images" rows="4" placeholder="请输入主图" />-->
              <j-image-upload text="上传" v-model="model.images" is-multiple="true" ></j-image-upload>
            </a-form-model-item>
          </a-col>
          <a-col :span="24">
            <a-form-model-item label="描述" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="describe">
              <a-input v-model="model.describe" placeholder="请输入描述"  ></a-input>
            </a-form-model-item>
          </a-col>
          <a-col :span="24">
            <a-form-model-item label="详情" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="content">
<!--              <a-textarea v-model="model.content" rows="4" placeholder="请输入详情" />-->
              <JEditor v-model="model.content" placeholder="请输入详情" :init="init"></JEditor>
            </a-form-model-item>

          </a-col>
<!--          <a-col :span="24">-->
<!--            <a-form-model-item label="销量" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="sale">-->
<!--              <a-input-number v-model="model.sale" placeholder="请输入销量" style="width: 100%" />-->
<!--            </a-form-model-item>-->
<!--          </a-col>-->
<!--          <a-col :span="24">-->
<!--            <a-form-model-item label="浏览量" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="pv">-->
<!--              <a-input-number v-model="model.pv" placeholder="请输入浏览量" style="width: 100%" />-->
<!--            </a-form-model-item>-->
<!--          </a-col>-->
          <a-col :span="24">
            <a-form-model-item label="权重" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="weight">
              <a-input-number v-model="model.weight" placeholder="请输入权重" style="width: 100%" />
            </a-form-model-item>
          </a-col>
          <a-col :span="24">
            <a-form-model-item label="状态" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="status">
<!--              <a-input-number v-model="model.status" placeholder="请输入状态:0=下架,1=上架" style="width: 100%" />-->
              <j-switch v-model="model.status"  ></j-switch>
            </a-form-model-item>
          </a-col>
<!--          <a-col :span="24">-->
<!--            <a-form-model-item label="删除状态:0=正常,1=删除" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="delFlag">-->
<!--              <a-input-number v-model="model.delFlag" placeholder="请输入删除状态:0=正常,1=删除" style="width: 100%" />-->
<!--            </a-form-model-item>-->
<!--          </a-col>-->
<!--          <a-col :span="24">-->
<!--            <a-form-model-item label="删除时间" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="deleteTime">-->
<!--              <j-date placeholder="请选择删除时间" v-model="model.deleteTime"  style="width: 100%" />-->
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
  import JImageUpload from '@/components/jeecg/JImageUpload'

  export default {
    name: 'ShoeGoodsForm',
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
           goodsId: [
              { required: true, message: '请输入ID!'},
           ],
           type: [
              { required: true, message: '请选择类型!'},
           ],
           title: [
              { required: true, message: '请输入商品名称!'},
           ],
           content: [
              { required: true, message: '请输入详情!'},
           ],
           weight: [
              { required: true, message: '请输入权重!'},
           ],
           status: [
              { required: true, message: '请输入状态:0=下架,1=上架!'},
           ],
        },
        url: {
          add: "/shoes/shoeGoods/add",
          edit: "/shoes/shoeGoods/edit",
          queryById: "/shoes/shoeGoods/queryById"
        },
        typeList:[],

      }
    },
    computed: {
      formDisabled(){
        return this.disabled
      },
    },
    created () {
      this.getTypeList();
       //备份model原始值
      this.model.type="repair";
      this.modelDefault = JSON.parse(JSON.stringify(this.model));
    },
    methods: {
      add () {
        this.modelDefault.type="repair";
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
            if(!this.model.goodsId){
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
      getTypeList() {
        httpAction("/shoes/shoeGoods/typeList", null, "get").then((res) => {
          if (res.success) {
            this.typeList = res.result;

          }
        })
      }
    },
  }
</script>