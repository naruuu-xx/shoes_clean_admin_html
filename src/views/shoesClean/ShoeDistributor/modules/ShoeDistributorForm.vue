<template>
  <a-spin :spinning="confirmLoading">
    <j-form-container :disabled="formDisabled">
      <a-form-model ref="form" :model="model" :rules="validatorRules" slot="detail">
        <a-row>
          <a-col :span="24">
            <a-form-model-item label="姓名" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="name">
              <a-input v-model="model.name" placeholder="请输入姓名"  ></a-input>
            </a-form-model-item>
          </a-col>
          <a-col :span="24">
            <a-form-model-item label="推广人绑定用户id" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="userId">
              <a-input-number v-model="model.userId" placeholder="请输入推广人绑定用户id" style="width: 100%" />
            </a-form-model-item>
          </a-col>
          <a-col :span="24">
            <a-form-model-item label="状态" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="status">
              <a-input-number v-model="model.status" placeholder="请输入状态（0=禁用，1=启用）" style="width: 100%" />
            </a-form-model-item>
          </a-col>

<!--          <a-col :span="24">-->
<!--            <a-form-model-item label="佣金比例" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="percentage">-->
<!--              <a-input-number v-model="model.percentage" placeholder="请输入佣金比例" style="width: 100%" />-->
<!--            </a-form-model-item>-->
<!--          </a-col>-->

          <a-col :span="24">
            <a-form-model-item label="银行卡号" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="cardNo">
              <a-input v-model="model.cardNo" placeholder="请输入银行卡号"  ></a-input>
            </a-form-model-item>
          </a-col>
          <a-col :span="24">
            <a-form-model-item label="持卡人" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="cardName">
              <a-input v-model="model.cardName" placeholder="请输入持卡人"  ></a-input>
            </a-form-model-item>
          </a-col>
          <a-col :span="24">
            <a-form-model-item label="开户行" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="openBank">
              <a-input v-model="model.openBank" placeholder="请输入开户行"  ></a-input>
            </a-form-model-item>
          </a-col>
          <a-col :span="24">
            <a-form-model-item label="开户行地址" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="bank">
              <a-input v-model="model.bank" placeholder="请输入开户行地址"  ></a-input>
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
    name: 'ShoeDistributorForm',
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
           distributorId: [
              { required: true, message: '请输入推广人id!'},
           ],
           pDistributorId: [
              { required: true, message: '请输入上级推广人id!'},
           ],
           leave: [
              { required: true, message: '请输入层级（推广人专属），1=一级，2=二级!'},
           ],
           name: [
              { required: true, message: '请输入名称!'},
           ],
           source: [
              { required: true, message: '请输入来源：1=后台添加，2=一级推广人邀请，3=二级升一级!'},
           ],
           qrcode: [
              { required: true, message: '请输入推广码!'},
           ],
           isDistribute: [
              { required: true, message: '请输入是否参与分佣，0=否，1=是!'},
           ],
           teamNum: [
              { required: true, message: '请输入团队人数!'},
           ],
           num: [
              { required: true, message: '请输入推广总人数!'},
           ],
           note: [
              { required: true, message: '请输入推广人备注!'},
           ],
           income: [
              { required: true, message: '请输入总收入!'},
           ],
           amount: [
              { required: true, message: '请输入账户余额!'},
           ],
           withdrawalingAmount: [
              { required: true, message: '请输入提现中金额!'},
           ],
           status: [
              { required: true, message: '请输入状态（0=禁用，1=启用）!'},
           ],
           addUserId: [
              { required: true, message: '请输入添加人!'},
           ],
           editUserId: [
              { required: true, message: '请输入最后修改人!'},
           ],
           delFlag: [
              { required: true, message: '请输入是否删除（0=正常，1=删除）!'},
           ],
        },
        url: {
          add: "/shoeDistributor/shoeDistributor/add",
          edit: "/shoeDistributor/shoeDistributor/edit",
          queryById: "/shoeDistributor/shoeDistributor/queryById"
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