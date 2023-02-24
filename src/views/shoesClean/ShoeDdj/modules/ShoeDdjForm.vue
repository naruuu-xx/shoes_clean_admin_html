<template>
  <a-spin :spinning="confirmLoading">
    <j-form-container :disabled="formDisabled">
      <a-form-model ref="form" :model="model" :rules="validatorRules" slot="detail">
        <a-row>
          <a-col :span="24">
            <a-form-model-item label=" id" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="ddjId">
              <a-input-number v-model="model.ddjId" placeholder="请输入 id" style="width: 100%" />
            </a-form-model-item>
          </a-col>
          <a-col :span="24">
            <a-form-model-item label="电话" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="phone">
              <a-input v-model="model.phone" placeholder="请输入电话"  ></a-input>
            </a-form-model-item>
          </a-col>
          <a-col :span="24">
            <a-form-model-item label="姓名" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="name">
              <a-input v-model="model.name" placeholder="请输入姓名"  ></a-input>
            </a-form-model-item>
          </a-col>
          <a-col :span="24">
            <a-form-model-item label="鞋子数量" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="num">
              <a-input-number v-model="model.num" placeholder="请输入鞋子数量" style="width: 100%" />
            </a-form-model-item>
          </a-col>
          <a-col :span="24">
            <a-form-model-item label="省" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="province">
              <a-input v-model="model.province" placeholder="请输入省"  ></a-input>
            </a-form-model-item>
          </a-col>
          <a-col :span="24">
            <a-form-model-item label="市" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="city">
              <a-input v-model="model.city" placeholder="请输入市"  ></a-input>
            </a-form-model-item>
          </a-col>
          <a-col :span="24">
            <a-form-model-item label="区" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="area">
              <a-input v-model="model.area" placeholder="请输入区"  ></a-input>
            </a-form-model-item>
          </a-col>
          <a-col :span="24">
            <a-form-model-item label="详细地址" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="address">
              <a-input v-model="model.address" placeholder="请输入详细地址"  ></a-input>
            </a-form-model-item>
          </a-col>
          <a-col :span="24">
            <a-form-model-item label="套餐内容" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="title">
              <a-input v-model="model.title" placeholder="请输入套餐内容"  ></a-input>
            </a-form-model-item>
          </a-col>
          <a-col :span="24">
            <a-form-model-item label="核销码" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="code">
              <a-input v-model="model.code" placeholder="请输入核销码"  ></a-input>
            </a-form-model-item>
          </a-col>
          <a-col :span="24">
            <a-form-model-item label="期望时间" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="pickupTime">
              <a-input v-model="model.pickupTime" placeholder="请输入期望时间"  ></a-input>
            </a-form-model-item>
          </a-col>
          <a-col :span="24">
            <a-form-model-item label="快递单号" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="kuaidinum">
              <a-input v-model="model.kuaidinum" placeholder="请输入快递单号"  ></a-input>
            </a-form-model-item>
          </a-col>
          <a-col :span="24">
            <a-form-model-item label="是否延迟下单 0=否，1=市" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="delay">
              <a-input-number v-model="model.delay" placeholder="请输入是否延迟下单 0=否，1=市" style="width: 100%" />
            </a-form-model-item>
          </a-col>
          <a-col :span="24">
            <a-form-model-item label="状态:0=未下快递单，1=已下快递单，2=快递下单失败" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="status">
              <a-input-number v-model="model.status" placeholder="请输入状态:0=未下快递单，1=已下快递单，2=快递下单失败" style="width: 100%" />
            </a-form-model-item>
          </a-col>
          <a-col :span="24">
            <a-form-model-item label="下快递时间" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="orderTime">
              <j-date placeholder="请选择下快递时间" v-model="model.orderTime"  style="width: 100%" />
            </a-form-model-item>
          </a-col>
          <a-col :span="24">
            <a-form-model-item label="操作人" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="sysUserId">
              <a-input v-model="model.sysUserId" placeholder="请输入操作人"  ></a-input>
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
    name: 'ShoeDdjForm',
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
           ddjId: [
              { required: true, message: '请输入 id!'},
           ],
           phone: [
              { required: true, message: '请输入电话!'},
           ],
           name: [
              { required: true, message: '请输入姓名!'},
           ],
           num: [
              { required: true, message: '请输入鞋子数量!'},
           ],
           province: [
              { required: true, message: '请输入省!'},
           ],
           city: [
              { required: true, message: '请输入市!'},
           ],
           area: [
              { required: true, message: '请输入区!'},
           ],
           address: [
              { required: true, message: '请输入详细地址!'},
           ],
           title: [
              { required: true, message: '请输入套餐内容!'},
           ],
           status: [
              { required: true, message: '请输入状态:0=未下快递单，1=已下快递单，2=快递下单失败!'},
           ],
        },
        url: {
          add: "/ShoeDdj/shoeDdj/add",
          edit: "/ShoeDdj/shoeDdj/edit",
          queryById: "/ShoeDdj/shoeDdj/queryById"
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