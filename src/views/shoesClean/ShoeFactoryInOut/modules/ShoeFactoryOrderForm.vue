<template>
  <a-spin :spinning="confirmLoading">
    <j-form-container :disabled="formDisabled">
      <a-form-model ref="form" :model="model" :rules="validatorRules" slot="detail">
        <a-row>
          <a-col :span="24">
            <a-form-model-item label="ID" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="factoryOrderId">
              <a-input-number v-model="model.factoryOrderId" placeholder="请输入ID" style="width: 100%" />
            </a-form-model-item>
          </a-col>
          <a-col :span="24">
            <a-form-model-item label="来源：1=鞋蜂小程序，2=其他" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="source">
              <a-input-number v-model="model.source" placeholder="请输入来源：1=鞋蜂小程序，2=其他" style="width: 100%" />
            </a-form-model-item>
          </a-col>
          <a-col :span="24">
            <a-form-model-item label="工厂编码" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="orgCode">
              <a-input v-model="model.orgCode" placeholder="请输入工厂编码"  ></a-input>
            </a-form-model-item>
          </a-col>
          <a-col :span="24">
            <a-form-model-item label="订单id" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="orderId">
              <a-input-number v-model="model.orderId" placeholder="请输入订单id" style="width: 100%" />
            </a-form-model-item>
          </a-col>
          <a-col :span="24">
            <a-form-model-item label="订单编号" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="no">
              <a-input v-model="model.no" placeholder="请输入订单编号"  ></a-input>
            </a-form-model-item>
          </a-col>
          <a-col :span="24">
            <a-form-model-item label="商品id" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="goodsId">
              <a-input-number v-model="model.goodsId" placeholder="请输入商品id" style="width: 100%" />
            </a-form-model-item>
          </a-col>
          <a-col :span="24">
            <a-form-model-item label="规格id" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="skuId">
              <a-input-number v-model="model.skuId" placeholder="请输入规格id" style="width: 100%" />
            </a-form-model-item>
          </a-col>
          <a-col :span="24">
            <a-form-model-item label="商品标题" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="title">
              <a-input v-model="model.title" placeholder="请输入商品标题"  ></a-input>
            </a-form-model-item>
          </a-col>
          <a-col :span="24">
            <a-form-model-item label="规格" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="skuTitle">
              <a-input v-model="model.skuTitle" placeholder="请输入规格"  ></a-input>
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
            <a-form-model-item label="状态:1=已入库，2=已出库" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="status">
              <a-input-number v-model="model.status" placeholder="请输入状态:1=已入库，2=已出库" style="width: 100%" />
            </a-form-model-item>
          </a-col>
          <a-col :span="24">
            <a-form-model-item label="入库时间" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="factoryInTime">
              <j-date placeholder="请选择入库时间" v-model="model.factoryInTime"  style="width: 100%" />
            </a-form-model-item>
          </a-col>
          <a-col :span="24">
            <a-form-model-item label="出库时间" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="factoryOutTime">
              <j-date placeholder="请选择出库时间" v-model="model.factoryOutTime"  style="width: 100%" />
            </a-form-model-item>
          </a-col>
          <a-col :span="24">
            <a-form-model-item label="操作人ID" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="dealUserId">
              <a-input v-model="model.dealUserId" placeholder="请输入操作人ID"  ></a-input>
            </a-form-model-item>
          </a-col>
          <a-col :span="24">
            <a-form-model-item label="操作人名字" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="dealUsername">
              <a-input v-model="model.dealUsername" placeholder="请输入操作人名字"  ></a-input>
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
    name: 'ShoeFactoryOrderForm',
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
           factoryOrderId: [
              { required: true, message: '请输入ID!'},
           ],
           source: [
              { required: true, message: '请输入来源：1=鞋蜂小程序，2=其他!'},
           ],
           orderId: [
              { required: true, message: '请输入订单id!'},
           ],
           no: [
              { required: true, message: '请输入订单编号!'},
           ],
           goodsId: [
              { required: true, message: '请输入商品id!'},
           ],
           skuId: [
              { required: true, message: '请输入规格id!'},
           ],
           title: [
              { required: true, message: '请输入商品标题!'},
           ],
           skuTitle: [
              { required: true, message: '请输入规格!'},
           ],
           phone: [
              { required: true, message: '请输入电话!'},
           ],
           name: [
              { required: true, message: '请输入姓名!'},
           ],
           status: [
              { required: true, message: '请输入状态:1=已入库，2=已出库!'},
           ],
           dealUserId: [
              { required: true, message: '请输入操作人ID!'},
           ],
           dealUsername: [
              { required: true, message: '请输入操作人名字!'},
           ],
        },
        url: {
          add: "/ShoeFactoryOrder/shoeFactoryOrder/add",
          edit: "/ShoeFactoryOrder/shoeFactoryOrder/edit",
          queryById: "/ShoeFactoryOrder/shoeFactoryOrder/queryById"
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