<template>
  <a-spin :spinning="confirmLoading">
    <j-form-container :disabled="formDisabled">
      <a-form-model ref="form" :model="model" :rules="validatorRules" slot="detail">
        <a-row>
          <a-col :span="24">
            <a-form-model-item label="套餐兑换次卡记录id" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="setmealTimecardExchangeId">
              <a-input-number v-model="model.setmealTimecardExchangeId" placeholder="请输入套餐兑换次卡记录id" style="width: 100%" />
            </a-form-model-item>
          </a-col>
          <a-col :span="24">
            <a-form-model-item label="平台：1=福州小洁" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="platform">
              <a-input-number v-model="model.platform" placeholder="请输入平台：1=福州小洁" style="width: 100%" />
            </a-form-model-item>
          </a-col>
          <a-col :span="24">
            <a-form-model-item label="第三方平台订单号（防重使用）" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="platformOrderId">
              <a-input v-model="model.platformOrderId" placeholder="请输入第三方平台订单号（防重使用）"  ></a-input>
            </a-form-model-item>
          </a-col>
          <a-col :span="24">
            <a-form-model-item label="套餐内容" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="setmeal">
              <a-input v-model="model.setmeal" placeholder="请输入套餐内容"  ></a-input>
            </a-form-model-item>
          </a-col>
          <a-col :span="24">
            <a-form-model-item label="套餐标识" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="keyword">
              <a-input v-model="model.keyword" placeholder="请输入套餐标识"  ></a-input>
            </a-form-model-item>
          </a-col>
          <a-col :span="24">
            <a-form-model-item label="套餐数量" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="num">
              <a-input-number v-model="model.num" placeholder="请输入套餐数量" style="width: 100%" />
            </a-form-model-item>
          </a-col>
          <a-col :span="24">
            <a-form-model-item label="用户手机号码" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="phone">
              <a-input v-model="model.phone" placeholder="请输入用户手机号码"  ></a-input>
            </a-form-model-item>
          </a-col>
          <a-col :span="24">
            <a-form-model-item label="用户类型：1=新用户，2=老用户" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="type">
              <a-input-number v-model="model.type" placeholder="请输入用户类型：1=新用户，2=老用户" style="width: 100%" />
            </a-form-model-item>
          </a-col>
          <a-col :span="24">
            <a-form-model-item label="兑换次卡ID" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="timecardId">
              <a-input-number v-model="model.timecardId" placeholder="请输入兑换次卡ID" style="width: 100%" />
            </a-form-model-item>
          </a-col>
          <a-col :span="24">
            <a-form-model-item label="兑换次卡数量" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="timecardNum">
              <a-input-number v-model="model.timecardNum" placeholder="请输入兑换次卡数量" style="width: 100%" />
            </a-form-model-item>
          </a-col>
          <a-col :span="24">
            <a-form-model-item label="状态：0=未兑换，1=已兑换" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="status">
              <a-input-number v-model="model.status" placeholder="请输入状态：0=未兑换，1=已兑换" style="width: 100%" />
            </a-form-model-item>
          </a-col>
          <a-col :span="24">
            <a-form-model-item label="兑换时间" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="exchangeTime">
              <j-date placeholder="请选择兑换时间" v-model="model.exchangeTime"  style="width: 100%" />
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
    name: 'ShoeSetmealTimecardExchangeForm',
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
           setmealTimecardExchangeId: [
              { required: true, message: '请输入套餐兑换次卡记录id!'},
           ],
           platform: [
              { required: true, message: '请输入平台：1=福州小洁!'},
           ],
           setmeal: [
              { required: true, message: '请输入套餐内容!'},
           ],
           keyword: [
              { required: true, message: '请输入套餐标识!'},
           ],
           num: [
              { required: true, message: '请输入套餐数量!'},
           ],
           phone: [
              { required: true, message: '请输入用户手机号码!'},
           ],
           type: [
              { required: true, message: '请输入用户类型：1=新用户，2=老用户!'},
           ],
           timecardId: [
              { required: true, message: '请输入兑换次卡ID!'},
           ],
           timecardNum: [
              { required: true, message: '请输入兑换次卡数量!'},
           ],
           status: [
              { required: true, message: '请输入状态：0=未兑换，1=已兑换!'},
           ],
        },
        url: {
          add: "/shoeSetmealTimecardExchange/shoeSetmealTimecardExchange/add",
          edit: "/shoeSetmealTimecardExchange/shoeSetmealTimecardExchange/edit",
          queryById: "/shoeSetmealTimecardExchange/shoeSetmealTimecardExchange/queryById"
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