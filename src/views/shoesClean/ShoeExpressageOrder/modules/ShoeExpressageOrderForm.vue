<template>
  <a-spin :spinning="confirmLoading">
    <j-form-container :disabled="formDisabled">
      <a-form-model ref="form" :model="model" :rules="validatorRules" slot="detail">
        <a-row>
          <a-col :span="24">
            <a-form-model-item label="快递订单ID" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="expressageOrderId">
              <a-input-number v-model="model.expressageOrderId" placeholder="请输入快递订单ID" style="width: 100%" />
            </a-form-model-item>
          </a-col>
          <a-col :span="24">
            <a-form-model-item label="快递100订单ID" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="kuaidi100OrderId">
              <a-input v-model="model.kuaidi100OrderId" placeholder="请输入快递100订单ID"  ></a-input>
            </a-form-model-item>
          </a-col>
          <a-col :span="24">
            <a-form-model-item label="关联父订单ID" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="orderPId">
              <a-input-number v-model="model.orderPId" placeholder="请输入关联父订单ID" style="width: 100%" />
            </a-form-model-item>
          </a-col>
          <a-col :span="24">
            <a-form-model-item label="场景：1=用户寄出，2=工厂寄出" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="scene">
              <a-input-number v-model="model.scene" placeholder="请输入场景：1=用户寄出，2=工厂寄出" style="width: 100%" />
            </a-form-model-item>
          </a-col>
          <a-col :span="24">
            <a-form-model-item label="状态:0=下单中，1=下单成功，2=下单失败，3=已取消" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="status">
              <a-input-number v-model="model.status" placeholder="请输入状态:0=下单中，1=下单成功，2=下单失败，3=已取消" style="width: 100%" />
            </a-form-model-item>
          </a-col>
          <a-col :span="24">
            <a-form-model-item label="是否发生过下单失败：0=否，1=是" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="hasFail">
              <a-input-number v-model="model.hasFail" placeholder="请输入是否发生过下单失败：0=否，1=是" style="width: 100%" />
            </a-form-model-item>
          </a-col>
          <a-col :span="24">
            <a-form-model-item label="快递公司名称" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="kuaidiName">
              <a-input v-model="model.kuaidiName" placeholder="请输入快递公司名称"  ></a-input>
            </a-form-model-item>
          </a-col>
          <a-col :span="24">
            <a-form-model-item label="快递公司编码" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="kuaidicom">
              <a-input v-model="model.kuaidicom" placeholder="请输入快递公司编码"  ></a-input>
            </a-form-model-item>
          </a-col>
          <a-col :span="24">
            <a-form-model-item label="收件人名姓名" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="recManName">
              <a-input v-model="model.recManName" placeholder="请输入收件人名姓名"  ></a-input>
            </a-form-model-item>
          </a-col>
          <a-col :span="24">
            <a-form-model-item label="收件人的手机号" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="recManMobile">
              <a-input v-model="model.recManMobile" placeholder="请输入收件人的手机号"  ></a-input>
            </a-form-model-item>
          </a-col>
          <a-col :span="24">
            <a-form-model-item label="收件人所在完整地址" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="recManPrintAddr">
              <a-input v-model="model.recManPrintAddr" placeholder="请输入收件人所在完整地址"  ></a-input>
            </a-form-model-item>
          </a-col>
          <a-col :span="24">
            <a-form-model-item label="寄件人姓名" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="sendManName">
              <a-input v-model="model.sendManName" placeholder="请输入寄件人姓名"  ></a-input>
            </a-form-model-item>
          </a-col>
          <a-col :span="24">
            <a-form-model-item label="寄件人的手机号" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="sendManMobile">
              <a-input v-model="model.sendManMobile" placeholder="请输入寄件人的手机号"  ></a-input>
            </a-form-model-item>
          </a-col>
          <a-col :span="24">
            <a-form-model-item label="寄件人所在的完整地址" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="sendManPrintAddr">
              <a-input v-model="model.sendManPrintAddr" placeholder="请输入寄件人所在的完整地址"  ></a-input>
            </a-form-model-item>
          </a-col>
          <a-col :span="24">
            <a-form-model-item label="下单返回结果" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="res">
              <a-input v-model="model.res" placeholder="请输入下单返回结果"  ></a-input>
            </a-form-model-item>
          </a-col>
          <a-col :span="24">
            <a-form-model-item label="快递单号" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="kuaidinum">
              <a-input v-model="model.kuaidinum" placeholder="请输入快递单号"  ></a-input>
            </a-form-model-item>
          </a-col>
          <a-col :span="24">
            <a-form-model-item label="计费重量，单位：kg" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="weight">
              <a-input v-model="model.weight" placeholder="请输入计费重量，单位：kg"  ></a-input>
            </a-form-model-item>
          </a-col>
          <a-col :span="24">
            <a-form-model-item label="标准运费，单位：元" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="defprice">
              <a-input-number v-model="model.defprice" placeholder="请输入标准运费，单位：元" style="width: 100%" />
            </a-form-model-item>
          </a-col>
          <a-col :span="24">
            <a-form-model-item label="折后运费，单位：元" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="freight">
              <a-input-number v-model="model.freight" placeholder="请输入折后运费，单位：元" style="width: 100%" />
            </a-form-model-item>
          </a-col>
          <a-col :span="24">
            <a-form-model-item label="面单类型：0=不打印，1=设备打印，2=生成图片短链回调" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="expressSheetType">
              <a-input-number v-model="model.expressSheetType" placeholder="请输入面单类型：0=不打印，1=设备打印，2=生成图片短链回调" style="width: 100%" />
            </a-form-model-item>
          </a-col>
          <a-col :span="24">
            <a-form-model-item label="面单" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="expressSheet">
              <a-input v-model="model.expressSheet" placeholder="请输入面单"  ></a-input>
            </a-form-model-item>
          </a-col>
          <a-col :span="24">
            <a-form-model-item label="备注" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="note">
              <a-input v-model="model.note" placeholder="请输入备注"  ></a-input>
            </a-form-model-item>
          </a-col>
          <a-col :span="24">
            <a-form-model-item label="成功时间" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="successTime">
              <j-date placeholder="请选择成功时间" v-model="model.successTime"  style="width: 100%" />
            </a-form-model-item>
          </a-col>
          <a-col :span="24">
            <a-form-model-item label="失败时间" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="failTime">
              <j-date placeholder="请选择失败时间" v-model="model.failTime"  style="width: 100%" />
            </a-form-model-item>
          </a-col>
          <a-col :span="24">
            <a-form-model-item label="取消时间" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="cancelTime">
              <j-date placeholder="请选择取消时间" v-model="model.cancelTime"  style="width: 100%" />
            </a-form-model-item>
          </a-col>
          <a-col :span="24">
            <a-form-model-item label="快递100回调任务id" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="taskId">
              <a-input v-model="model.taskId" placeholder="请输入快递100回调任务id"  ></a-input>
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
    name: 'ShoeExpressageOrderForm',
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
           expressageOrderId: [
              { required: true, message: '请输入快递订单ID!'},
           ],
           kuaidi100OrderId: [
              { required: true, message: '请输入快递100订单ID!'},
           ],
           orderPId: [
              { required: true, message: '请输入关联父订单ID!'},
           ],
           scene: [
              { required: true, message: '请输入场景：1=用户寄出，2=工厂寄出!'},
           ],
           status: [
              { required: true, message: '请输入状态:0=下单中，1=下单成功，2=下单失败，3=已取消!'},
           ],
           hasFail: [
              { required: true, message: '请输入是否发生过下单失败：0=否，1=是!'},
           ],
           kuaidiName: [
              { required: true, message: '请输入快递公司名称!'},
           ],
           kuaidicom: [
              { required: true, message: '请输入快递公司编码!'},
           ],
           recManName: [
              { required: true, message: '请输入收件人名姓名!'},
           ],
           recManMobile: [
              { required: true, message: '请输入收件人的手机号!'},
           ],
           recManPrintAddr: [
              { required: true, message: '请输入收件人所在完整地址!'},
           ],
           sendManName: [
              { required: true, message: '请输入寄件人姓名!'},
           ],
           sendManMobile: [
              { required: true, message: '请输入寄件人的手机号!'},
           ],
           sendManPrintAddr: [
              { required: true, message: '请输入寄件人所在的完整地址!'},
           ],
           res: [
              { required: true, message: '请输入下单返回结果!'},
           ],
           weight: [
              { required: true, message: '请输入计费重量，单位：kg!'},
           ],
           defprice: [
              { required: true, message: '请输入标准运费，单位：元!'},
           ],
           freight: [
              { required: true, message: '请输入折后运费，单位：元!'},
           ],
           expressSheetType: [
              { required: true, message: '请输入面单类型：0=不打印，1=设备打印，2=生成图片短链回调!'},
           ],
        },
        url: {
          add: "/shoeExpressageOrder/shoeExpressageOrder/add",
          edit: "/shoeExpressageOrder/shoeExpressageOrder/edit",
          queryById: "/shoeExpressageOrder/shoeExpressageOrder/queryById"
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