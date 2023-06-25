<template>
  <a-spin :spinning="confirmLoading">
    <j-form-container :disabled="formDisabled">
      <a-form-model ref="form" :model="model" :rules="validatorRules" slot="detail">
        <a-row>
          <a-col :span="24">
            <a-form-model-item label="分类名称" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="name">
              <a-input v-model="model.name" placeholder="请输入分类名称"  ></a-input>
            </a-form-model-item>
          </a-col>
          <a-col :span="24">
            <a-form-model-item label="权重" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="weight">
              <a-input-number v-model="model.weight" placeholder="请输入权重" style="width: 100%" />
            </a-form-model-item>
          </a-col>
          <a-col :span="24" v-if="model.categoryPId == 2&&model.level==2">
            <a-form-model-item label="是否展示首页" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="isShow" >
              <a-radio-group v-model:value="model.isShow">
                <a-radio value="0">否</a-radio>
                <a-radio value="1">是</a-radio>
              </a-radio-group>
            </a-form-model-item>
          </a-col>
          <a-col :span="24">
            <a-form-model-item label="描述" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="describe">
              <a-input v-model="model.describe" placeholder="请输入描述" />
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
    name: 'ShoeGoodsCategoryForm',
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
        model:{isShow:'0'
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
              { required: true, message: '请输入分类名称!'},
           ],
          isShow: [
            { required: true, message: '请选择是否展示首页!'},
          ],
          describe: [
            { required: true, message: '请输入描述!'},
          ],
           weight: [
              { required: true, message: '请输入权重!'},
              { pattern: /^-?\d+\.?\d*$/, message: '请输入数字!'},
           ],
        },
        url: {
          list:'/shoes/shoeGoodsCategory/list',
          add: "/shoes/shoeGoodsCategory/add",
          edit: "/shoes/shoeGoodsCategory/edit",
          queryById: "/shoes/shoeGoodsCategory/queryById"
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
        this.model.categoryPId = 2
        this.model.level = 2
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
              this.model.categoryId = this.model.id;
            }else{
              httpurl+=this.url.edit;
               method = 'put';
              this.model.categoryId = this.model.id;
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