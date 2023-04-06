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
          <a-col :span="24" v-if="!model.distributorId">
<!--            <a-form-model-item label="推广人绑定用户id" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="userId">-->
<!--&lt;!&ndash;              <a-input-number v-model="model.userId" placeholder="请输入推广人绑定用户id" style="width: 100%" />&ndash;&gt;-->

<!--              <a-select-->
<!--                show-search-->
<!--                label-in-value-->
<!--                :value="value"-->
<!--                placeholder="请输入昵称或手机号"-->
<!--                style="width: 100%"-->
<!--                :filter-option="false"-->
<!--                :not-found-content="fetching ? undefined : null"-->
<!--                :showArrow="false"-->
<!--                @search="fetchUser"-->
<!--                @change="handleChange"-->
<!--              >-->
<!--                <a-spin v-if="fetching" slot="notFoundContent" size="small" />-->
<!--                <a-select-option v-for="item in userList" :key="item.userId">-->
<!--                  {{ item.wxInfo }}-->
<!--                </a-select-option>-->
<!--              </a-select>-->

<!--            </a-form-model-item>-->
            <a-form-model-item label="绑定小程序账号" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="userId">
              <XfSelect
                :list="weekList"
                @change="checkedSelect"
                @changeList="changeSelect"
                v-model="model.userId"
                :url='`/shoes/shoeUser/getUserListBytype?type=distributor`'
              >
              </XfSelect>
            </a-form-model-item>
          </a-col>
          <a-col :span="24" v-if="model.distributorId">
            <a-form-model-item label="推广人绑定用户id" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="userId">
              <a-input v-model="model.wxInfo" :disabled="true"></a-input>
            </a-form-model-item>
          </a-col>
          <a-col :span="24" v-if="!model.distributorId">
            <a-form-model-item label="状态" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="status">
              <a-radio-group v-model:value="model.status">
                <a-radio value="1">启用</a-radio>
                <a-radio value="0">禁用</a-radio>
              </a-radio-group>
            </a-form-model-item>
          </a-col>
          <a-col :span="24">
            <a-form-model-item label=" 收益比例" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="percentage">
              <a-input v-model="model.percentage" :min="0" :max="100" :step="1" placeholder="请输入0-100的整数" autocomplete="off" suffix="%"></a-input>
            </a-form-model-item>
          </a-col>
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
  import debounce from '@/utils/debounce'
  import XfSelect from "@comp/Xf/XfSelect";

  export default {
    name: 'ShoeDistributorForm',
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
      //下拉搜索框需要的变量
      // this.lastFetchId = 0;
      // this.fetchUser = debounce(this.fetchUser, 800);
      return {
        weekList:[],
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
            { required: true, message: '请输入名称!'},
          ],
          userId: [
            { required: true, message: '请输入昵称或手机号!' }
          ],
          status: [
            { required: true, message: '请选择状态!'},
          ],
          percentage: [
            { required: true, message: '请输入0-100之间的整数!'},
            { pattern: /^([0-9]{0,2}|100)$/, message: '请输入0-100之间的整数!'},
          ],
          cardNo: [
            { required: true, message: '请输入银行卡号!'},
          ],
          cardName: [
            { required: true, message: '请输入持卡人!'},
          ],
          openBank: [
            { required: true, message: '请输入开户行!'},
          ],
          bank: [
            { required: true, message: '请输入开户行地址!'},
          ],
        },
        url: {
          add: "/shoeDistributor/shoeDistributor/add",
          edit: "/shoeDistributor/shoeDistributor/edit",
          queryById: "/shoeDistributor/shoeDistributor/queryById"
        },
        //下拉搜索框需要的变量
        userList: [],
        fetching: false,
        lastFetchId: 0,
        value: [],
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
      changeSelect(data) {
        this.weekList = data.records.map(item => ({
          label: item.nickname+'('+item.phone+')',
          value: +item.userId
        }));
      },
      checkedSelect(val) {
      },
      add () {
        this.modelDefault.status = '1';
        this.edit(this.modelDefault);
      },
      edit (record) {
        this.model = Object.assign({}, record);

        if (this.model.distributorId) {
          let percentage = record.percentage;

          this.model.percentage = (percentage * 100).toFixed(0);
        }

        this.visible = true;
      },
      fetchUser (value) {
        debounce(() => {
          this.lastFetchId += 1;

          this.userList = [];

          this.fetching = true;

          httpAction("/shoes/shoeUser/queryWXUserList?searchWord="+value, null, "get").then((res) => {
            this.userList = res.result;
            this.fetching = false;
          })
        }, 1000);
      },
      handleChange (value) {
        Object.assign(this.model, {userId: value.key});
        Object.assign(this, {
          value,
          userList: [],
          fetching: false,
        });
      },
      submitForm () {
        const that = this;
        // 触发表单验证
        this.$refs.form.validate(valid => {
          if (valid) {
            that.confirmLoading = true;
            let httpurl = '';
            let method = '';
            if(!this.model.distributorId){
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