<template>
  <a-spin :spinning="confirmLoading">
    <j-form-container :disabled="formDisabled">
      <a-form-model ref="form" :model="model" :rules="validatorRules" slot="detail">
        <a-row>
          <a-col :span="24">
            <a-form-model-item label="名称" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="name">
              <a-input v-model="model.name" placeholder="请输入名称"  ></a-input>
            </a-form-model-item>
          </a-col>
          <a-col :span="24">
            <a-form-model-item label="轮播类型" :labelCol="labelCol" :wrapperCol="wrapperCol"  prop="type">
              <a-radio-group v-model:value="model.type">
                <a-radio value="1">顶部轮播(750px*600px)</a-radio>
                <a-radio value="2">中间轮播(690px*192px)</a-radio>
              </a-radio-group>
            </a-form-model-item>
          </a-col>
          <a-col :span="24">
            <a-form-model-item label="轮播图" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="image">
              <j-image-upload isMultiple  v-model="model.image" ></j-image-upload>
            </a-form-model-item>
          </a-col>
          <a-col :span="24">
            <a-form-model-item label="跳转地址" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="url">
              <a-input v-model="model.url" placeholder="请输入跳转地址"  ></a-input>
            </a-form-model-item>
          </a-col>
          <a-col :span="24">
            <a-form-model-item label="状态" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="status">
              <j-switch v-model="model.status"  ></j-switch>
<!--              <switch v-model="model.status"></switch>-->
            </a-form-model-item>
          </a-col>
          <a-col :span="24">
            <a-form-model-item label="权重" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="weight">
              <a-input-number v-model="model.weight" placeholder="请输入权重" style="width: 100%" />
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
    name: 'ShoeBannerForm',
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
            status:{
              options: [1,0],
            },
          type:"1"

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
              { required: true, message: '请输入名称!'},
           ],
          type: [
            { required: true, message: '请选择轮播类型!'},
          ],
           image: [
              { required: true, message: '请输入轮播图!'},
           ],
           url: [
              { required: false, message: '请输入跳转地址!'},
           ],
           status: [
              { required: true, message: '请输入状态:0=关闭,1=开启!'},
           ],
           weight: [
              { required: true, message: '请输入权重!'},
              { pattern: /^-?\d+\.?\d*$/, message: '请输入数字!'},
           ],
        },
        url: {
          add: "/shoes/shoeBanner/add",
          edit: "/shoes/shoeBanner/edit",
          queryById: "/shoes/shoeBanner/queryById"
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
        this.model.status = '0';
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
            if(!this.model.bannerId){
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