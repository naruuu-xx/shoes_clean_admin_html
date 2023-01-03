  <template>
  <a-spin :spinning="confirmLoading">
    <j-form-container :disabled="formDisabled">
      <a-form-model ref="form" :model="model" :rules="validatorRules" slot="detail">
        <a-row>
          <a-col :span="24">
            <a-form-model-item label="配送提现id " :labelCol="labelCol" :wrapperCol="wrapperCol" prop="courierWithdrawalId">
              <a-input-number v-model="model.courierWithdrawalId" placeholder="请输入配送提现id " style="width: 100%" />
            </a-form-model-item>
          </a-col>
          <a-col :span="24">
            <a-form-model-item label="配送员id" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="courierId">
              <a-input-number v-model="model.courierId" placeholder="请输入配送员id" style="width: 100%" />
            </a-form-model-item>
          </a-col>
          <a-col :span="24">
            <a-form-model-item label="提现金额" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="amount">
              <a-input-number v-model="model.amount" placeholder="请输入提现金额" style="width: 100%" />
            </a-form-model-item>
          </a-col>
          <a-col :span="24">
            <a-form-model-item label="类型:1=银行" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="type">
              <a-input-number v-model="model.type" placeholder="请输入类型:1=银行" style="width: 100%" />
            </a-form-model-item>
          </a-col>
          <a-col :span="24">
            <a-form-model-item label="状态:0=审核中，1=提现中，2=审核失败，3=已提现" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="status">
              <a-input v-model="model.status" placeholder="请输入状态:0=审核中，1=提现中，2=审核失败，3=已提现"  ></a-input>
            </a-form-model-item>
          </a-col>
          <a-col :span="24">
            <a-form-model-item label="备注" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="note">
              <a-input v-model="model.note" placeholder="请输入备注"  ></a-input>
            </a-form-model-item>
          </a-col>
          <a-col :span="24">
            <a-form-model-item label="卡号" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="cardNo">
              <a-input v-model="model.cardNo" placeholder="请输入卡号"  ></a-input>
            </a-form-model-item>
          </a-col>
          <a-col :span="24">
            <a-form-model-item label="开户行" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="openBank">
              <a-input v-model="model.openBank" placeholder="请输入开户行"  ></a-input>
            </a-form-model-item>
          </a-col>
          <a-col :span="24">
            <a-form-model-item label="持卡人" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="cardName">
              <a-input v-model="model.cardName" placeholder="请输入持卡人"  ></a-input>
            </a-form-model-item>
          </a-col>
          <a-col :span="24">
            <a-form-model-item label="银行地址" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="bankAddress">
              <a-input v-model="model.bankAddress" placeholder="请输入银行地址"  ></a-input>
            </a-form-model-item>
          </a-col>
          <a-col :span="24">
            <a-form-model-item label="审核时间" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="auditTime">
              <j-date placeholder="请选择审核时间" v-model="model.auditTime"  style="width: 100%" />
            </a-form-model-item>
          </a-col>
          <a-col :span="24">
            <a-form-model-item label="转账时间" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="transferTime">
              <j-date placeholder="请选择转账时间" v-model="model.transferTime"  style="width: 100%" />
            </a-form-model-item>
          </a-col>
          <a-col :span="24">
            <a-form-model-item label="审核人id" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="auditUserId">
              <a-input v-model="model.auditUserId" placeholder="请输入审核人id"  ></a-input>
            </a-form-model-item>
          </a-col>
          <a-col :span="24">
            <a-form-model-item label="审核人" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="auditName">
              <a-input v-model="model.auditName" placeholder="请输入审核人"  ></a-input>
            </a-form-model-item>
          </a-col>
          <a-col :span="24">
            <a-form-model-item label="确认转账人id" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="transferUserId">
              <a-input v-model="model.transferUserId" placeholder="请输入确认转账人id"  ></a-input>
            </a-form-model-item>
          </a-col>
          <a-col :span="24">
            <a-form-model-item label="确认转账人" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="transferName">
              <a-input v-model="model.transferName" placeholder="请输入确认转账人"  ></a-input>
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
    name: 'ShoeCourierWithdrawalForm',
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
           courierWithdrawalId: [
              { required: true, message: '请输入配送提现id !'},
           ],
           courierId: [
              { required: true, message: '请输入配送员id!'},
           ],
           amount: [
              { required: true, message: '请输入提现金额!'},
           ],
           type: [
              { required: true, message: '请输入类型:1=银行!'},
           ],
           status: [
              { required: true, message: '请输入状态:0=审核中，1=提现中，2=审核失败，3=已提现!'},
           ],
           cardNo: [
              { required: true, message: '请输入卡号!'},
           ],
           openBank: [
              { required: true, message: '请输入开户行!'},
           ],
           cardName: [
              { required: true, message: '请输入持卡人!'},
           ],
           bankAddress: [
              { required: true, message: '请输入银行地址!'},
           ],
        },
        url: {
          add: "/ShoeCourierWithdrawal/shoeCourierWithdrawal/add",
          edit: "/ShoeCourierWithdrawal/shoeCourierWithdrawal/edit",
          queryById: "/ShoeCourierWithdrawal/shoeCourierWithdrawal/queryById"
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