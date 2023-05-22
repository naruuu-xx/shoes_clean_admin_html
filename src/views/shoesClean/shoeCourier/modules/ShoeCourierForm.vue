<template>
  <a-spin :spinning="confirmLoading">
    <j-form-container :disabled="formDisabled">
      <a-form-model ref="form" :model="model" :rules="validatorRules" slot="detail">
        <a-row>
          <a-col :span="24">
            <a-form-model-item label=" 姓名" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="name">
              <a-input v-model="model.name" placeholder="请输入 姓名" autocomplete="off"></a-input>
            </a-form-model-item>
          </a-col>
          <a-col :span="24">
            <a-form-model-item label=" 手机号" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="phone">
              <a-input v-model="model.phone" placeholder="请输入 手机号" autocomplete="off"></a-input>
            </a-form-model-item>
          </a-col>
<!--          <a-col :span="24">-->
<!--            <a-form-model-item label=" 身份证" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="idcard">-->
<!--              <a-input v-model="model.idcard" placeholder="请输入 身份证" autocomplete="off"></a-input>-->
<!--            </a-form-model-item>-->
<!--          </a-col>-->
          <a-col :span="24">
            <a-form-model-item label=" 密码" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="password" v-if="this.model.courierId === null || this.model.courierId === undefined">
              <a-input-password v-model="model.password" placeholder="请输入 密码" autocomplete="off"/>
            </a-form-model-item>
          </a-col>
          <a-col :span="24">
            <a-form-model-item label=" 绑定机柜编码" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="lockerCodeList">
              <!-- <a-select v-model="model.lockerCodeList" mode="multiple">
                <a-select-option v-for="i in lockerList" :value="i.lockerCode" :key="i.lockerCode">{{i.name}}</a-select-option>
              </a-select> -->
              <xf-select
                  style="width: 100%"
                  isInternalData
                  mode="multiple"
                  v-model="model.lockerCodeList"
                  :url='`/shoes/shoeLogistics/lockerOrSiteList?type=locker`'
                  :rawList="[{label:'zdian1',value:'100005'}]"
                >
                </xf-select>
            </a-form-model-item>
          </a-col>
          <a-col :span="24">
            <a-form-model-item label="登录状态" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="status">
              <j-dict-select-tag type="radio" v-model="model.status" dictCode="shoe_courier_status" placeholder="请选择登录状态" />
            </a-form-model-item>
          </a-col>
          <a-col :span="24">
            <a-form-model-item label="银行卡号" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="cardNo">
              <a-input v-model="model.cardNo" placeholder="请输入银行卡号" autocomplete="off"/>
            </a-form-model-item>
          </a-col>
          <a-col :span="24">
            <a-form-model-item label="持卡人" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="cardName">
              <a-input v-model="model.cardName" placeholder="请输入持卡人" autocomplete="off"/>
            </a-form-model-item>
          </a-col>

          <a-col :span="24">
            <a-form-model-item label="开户行" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="openBank">
              <a-input v-model="model.openBank" placeholder="请输入开户行" autocomplete="off"/>
            </a-form-model-item>
          </a-col>
          <a-col :span="24">
            <a-form-model-item label="开户行地址" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="bankAddress">
              <a-input v-model="model.bankAddress" placeholder="请输入开户行地址" autocomplete="off"/>
            </a-form-model-item>
          </a-col>
          <a-col :span="24">
            <a-form-model-item label="接单状态" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="orderStatus">
              <j-dict-select-tag type="radio" v-model="model.orderStatus" dictCode="shoe_courier_order_status" placeholder="请选择接单状态" />
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
  import XfSelect from '@/components/Xf/XfSelect'

  export default {
    name: 'ShoeCourierForm',
    components: {
      XfSelect
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
           name: [
              { required: true, message: '请输入 姓名!'},
           ],
           phone: [
              { required: true, message: '请输入 手机号!'},
              { pattern: /^1[3456789]\d{9}$/, message: '请输入正确的手机号码!'},
              { validator: this.validateCheckPhone},
           ],
           idcard: [
              { required: false, message: '请输入 身份证!'},
              {validator: this.validateIdCard}
           ],
           password: [
              { required: true, message: '请输入 密码!'},
              { pattern: /^.{6,16}$/, message: '请输入6到16位任意字符!'},
           ],
           status: [
              { required: true, message: '请选择 状态'},
           ],
           delFlag: [
              { required: true, message: '请选择 删除状态!'},
           ],
          lockerCodeList: [
              { required: true, message: '请选择快递柜!'},
           ],
          cardNo: [
            { required: true, message: '请输入银行卡号' },
          ],
          cardName: [
            { required: true, message: '请输入持卡人' }
          ],
          openBank: [
            { required: true, message: '请输入开户行' }
          ],
          bankAddress: [
            { required: true, message: '请输入开户行地址' }
          ],
          orderStatus: [
            { required: true, message: '请选择接单状态'},
          ],
        },
        url: {
          add: "/shoeCourier/shoeCourier/add",
          edit: "/shoeCourier/shoeCourier/edit",
          queryById: "/shoeCourier/shoeCourier/queryById"
        },
        lockerList:[],
      }
    },
    computed: {
      formDisabled(){
        return this.disabled
      },
    },
    created () {
      this.getLockerList();
       //备份model原始值
      this.modelDefault = JSON.parse(JSON.stringify(this.model));
    },
    methods: {
      validateCheckPhone(rule, value, callback) {
        let phone = value
        if(phone.length == 11) {
          getAction('/shoeCourier/shoeCourier/checkPhone',{
            type: this.model.courierId ? 2 : 1,
            phone
          }).then(res => {
            if(res.success) {
              if(res.result.errMsg) {
                callback(res.result.errMsg);
              } else {
                callback();
              }
            } else {
              callback("接口出错,请联系管理员!");
            }
          })
        } else {
          callback("手机号码格式不正确!");
        }
      },
      validateIdCard(rule, value, callback) {
        if(!value || new RegExp(/^([1-6][1-9]|50)\d{4}(18|19|20)\d{2}((0[1-9])|10|11|12)(([0-2][1-9])|10|20|30|31)\d{3}[0-9Xx]$/
        ).test(value) || new RegExp(/^([1-6][1-9]|50)\d{4}\d{2}((0[1-9])|10|11|12)(([0-2][1-9])|10|20|30|31)\d{3}$/).test(value)){
          callback();
        }
        else{
          callback("您输入的身份证格式不正确!");
        }
      },
      add () {
        // this.edit(this.modelDefault);
        this.model = {
          status: 1
        }
      },
      edit (record) {
        this.model = Object.assign({}, record);
        this.model.lockerCode = record.lockerCode;
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
            if(!this.model.courierId){
              httpurl+=this.url.add;
              method = 'post';
            }else{
              httpurl+=this.url.edit;
               method = 'put';
            }
            that.setModel();
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
      getLockerList(){
        httpAction("/shoes/shoeLocker/lockerList", null, "get").then((res) => {
          if (res.success) {
            this.lockerList = res.result;
          }
        })
      },
      setModel(){
        const that = this;
        let lockerIdList = [];
        for(let i = 0; i < that.lockerList.length; i++){
          if(that.model.lockerCodeList.indexOf(that.lockerList[i].lockerCode) !== -1){
            lockerIdList.push(that.lockerList[i].lockerId);
          }
        }
        that.model.lockerIdList = lockerIdList;
      }
    }
  }
</script>