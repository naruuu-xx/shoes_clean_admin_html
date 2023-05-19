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
            <a-form-model-item label="手机号" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="phone">
              <a-input v-model="model.phone" placeholder="请输入手机号"  ></a-input>
            </a-form-model-item>
          </a-col>
          <a-col :span="24">
            <a-form-model-item label="身份" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="level">
              <a-select v-model="model.level"  >
                  <a-select-option value = "1" >代理人</a-select-option>
                  <a-select-option value = "2" >投资人</a-select-option>
                  <a-select-option value="3">合伙人</a-select-option>
              </a-select>
            </a-form-model-item>
          </a-col>
<!--          <a-col :span="24">-->
<!--            <a-form-model-item label="绑定小程序账号" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="userId">-->
<!--              <a-select-->
<!--                show-search-->
<!--                placeholder="选择或搜索需要绑定的用户"-->
<!--                option-filter-prop="children"-->
<!--                style="width: 200px"-->
<!--                :filter-option="filterOption"-->
<!--                v-model="model.userId"-->
<!--                :disabled="(!(model.investorsId === null || model.investorsId === ''))"-->
<!--              >-->
<!--                <a-select-option  v-for="i in shoeUserList" :value="i.userId" :key="i.nickname">-->
<!--                  {{i.nickname}}-->
<!--                </a-select-option>-->
<!--              </a-select>-->
<!--            </a-form-model-item>-->
<!--          </a-col>-->
          <a-col :span="24" >
            <a-form-model-item label="绑定小程序账号" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="userId">
              <XfSelect
                :list="weekList"
                @change="checkedSelect"
                @changeList="changeSelect"
                v-model="model.userId"
                :disabled="(!(model.investorsId === null || model.investorsId === ''))"
                :url='`/shoes/shoeUser/getUserListBytype?type=investors`'
              >
              </XfSelect>
            </a-form-model-item>
          </a-col>
          <a-col :span="24">
            <a-form-model-item
              label="绑定上级" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="investorsPId"
              v-if="model.level === '2'">
              <a-select
                show-search
                placeholder="选择或搜索需要绑定的用户"
                option-filter-prop="children"
                style="width: 200px"
                :filter-option="filterOption"
                v-model="model.investorsPId"
              >
                <a-select-option  v-for="i in agentList" :value="i.investorsId" :key="i.nickname">
                  {{i.nickname}}
                </a-select-option>
              </a-select>
            </a-form-model-item>
          </a-col>
<!--          <a-col :span="24">-->
<!--            <a-form-model-item label="绑定机柜" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="lockerId" >-->
<!--              <a-select-->
<!--                mode="multiple"-->
<!--                show-search-->
<!--                placeholder="选择或搜索需要绑定的用户"-->
<!--                option-filter-prop="children"-->
<!--                style="width: 200px"-->
<!--                :filter-option="filterOption"-->
<!--                v-model="model.lockerIds"-->
<!--              >-->
<!--                <a-select-option  v-for="i in lockerList" :value="i.lockerId" :key="i.lockerId">-->
<!--                  {{i.name}}-->
<!--                </a-select-option>-->
<!--              </a-select>-->
<!--            </a-form-model-item>-->
<!--          </a-col>-->
          <a-col :span="24">
            <a-form-model-item label="绑定机柜" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="investorsLockerDtoList" required>
              <a-button type="primary" @click="onAddLocker">新增</a-button>
            </a-form-model-item>
          </a-col>
          <div v-for="(shoeInvestorsLockerDto, idx) in investorsLockerDtoList" :key="`locker${idx}`">
            <div class="locker">
              <div class="locker-label">
                机柜{{ idx + 1 }}：
                <a-select style="width: 120px" v-model="investorsLockerDtoList[idx].lockerId">
                  <a-select-option :value="item.lockerId" v-for="(item, index) in lockerList" :key="index"
                                   :disabled="disabledLocker(item.lockerId)">
                    {{ item.name }}
                  </a-select-option>
                </a-select>
              </div>
              <div class="locker-label">
                收益比例(%)：
                <a-input-number v-model="shoeInvestorsLockerDto.percentage" placeholder="收益比例(%)" />
              </div>
              <div class="locker-label">
                <a-button type="danger" @click="onDeleteLocker(idx)" v-if="investorsLockerDtoList.length > 1">删除</a-button>
              </div>
            </div>
          </div>
          <a-col :span="24" >
            <a-form-model-item label="银行卡号" :labelCol="labelCol" :wrapperCol="wrapperCol"  prop="cardNo">
              <a-input v-model="model.cardNo" placeholder="请输入银行卡号"  ></a-input>
            </a-form-model-item>
          </a-col>

          <a-col :span="24">
            <a-form-model-item label="持卡人" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="cardName">
              <a-input v-model="model.cardName" placeholder="请输入持卡人"  ></a-input>
            </a-form-model-item>
          </a-col>
          <a-col :span="24">
            <a-form-model-item label="开户行" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="bank">
              <a-input v-model="model.bank" placeholder="请输入开户行"  ></a-input>
            </a-form-model-item>
          </a-col>

          <a-col :span="24">
            <a-form-model-item label="开户行地址" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="openBank">
              <a-input v-model="model.openBank" placeholder="请输入开户行地址"  ></a-input>
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
  import router from "@/router";
  import XfSelect from "@comp/Xf/XfSelect";

  export default {
    name: 'ShoeInvestorsForm',
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
        weekList:[],
        model:{
          investorsId:'',
          cardNo:'',
          cardName:'',
          bank:'',
          openBank:'',
          investorsLockerDtoList:'',
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
              { required: true, message: '请输入姓名!'},
           ],
           phone: [
              { required: true, message: '请输入手机号!'},
             { pattern: /^1[3456789]\d{9}$/, message: '请输入正确的手机号码!'},
           ],
          cardNo: [
            { required: true, message: '请输入银行卡号!'},
          ],
          cardName: [
            { required: true, message: '请输入持卡人!'},
          ],
          bank: [
            { required: true, message: '请输入开户行!'},
          ],
          openBank: [
            { required: true, message: '请输入开户行地址!'},
          ],
           level: [
              { required: true, message: '请选择身份!'},
           ],
           userId: [
              { required: true, message: '请选择绑定小程序用户id!'},
           ],
          investorsPId:[
            { required: false, message: '请选择绑定上级!'},
          ]
        },
        url: {
          add: "/shoes/shoeInvestors/add",
          edit: "/shoes/shoeInvestors/edit",
          queryById: "/shoes/shoeInvestors/queryById"
        },
        levelTextList:[],
        shoeUserList:[],
        lockerList:[],
        agentList:[],
        investorsLockerDtoList:[],
      }
    },
    watch:{
      "model.level":{
        handler(val){
          this.validatorRules= {
            name: [
              { required: true, message: '请输入姓名!'},
            ],
            phone: [
              { required: true, message: '请输入手机号!'},
              { pattern: /^1[3456789]\d{9}$/, message: '请输入正确的手机号码!'},
            ],
            cardNo: [
              { required: true, message: '请输入银行卡号!'},
            ],
            cardName: [
              { required:  true, message: '请输入持卡人!'},
            ],
            bank: [
              { required:  true, message: '请输入开户行!'},
            ],
            openBank: [
              { required:  true, message: '请输入开户行地址!'},
            ],
            level: [
              { required: true, message: '请选择身份!'},
            ],
            userId: [
              { required: true, message: '请选择绑定小程序用户id!'},
            ],
            investorsPId:[
              { required: false, message: '请选择绑定上级!'},
            ]
          }
        },
        immediate:true
      },
      investorsLockerDtoList: {
        handler(val) {
          this.model.investorsLockerDtoList = val
        },
        deep: true,
        immediate: true,
      },
    },
    computed: {
      formDisabled(){
        return this.disabled
      },
    },
    created () {
       //备份model原始值

      this.getLockerList();
      this.getAgentList();

      this.modelDefault = JSON.parse(JSON.stringify(this.model));
    },
    methods: {
      filterOption(input, option) {
        return (
          option.componentOptions.children[0].text.toLowerCase().indexOf(input.toLowerCase()) >= 0
        );
      },
      add () {
        this.edit(this.modelDefault);
      },
      changeSelect(data) {
        this.weekList = data.records.map(item => ({
          label: item.nickname+'('+item.phone+')',
          value: +item.userId
        }));
      },
      checkedSelect(val) {
      },
      edit (record) {
        this.model = Object.assign({}, record,this.model);
        this.investorsLockerDtoList = record.investorsLockerDtoList;
        this.model.investorsId=record.investorsId;
        this.getBank();
        this.getLockerList();
       this.getShoeUserList(record.userId);

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
            if(!this.model.investorsId){
              httpurl+=this.url.add;
              method = 'post';
            }else{
              httpurl+=this.url.edit;
               method = 'put';
              this.model.income = parseInt(this.model.income)*100;
              this.model.amount = parseInt(this.model.amount)*100;
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
      getShoeUserList(userId){
        httpAction("/shoes/shoeUser/getUser?userId="+userId,"", "get").then((res)=>{
          if(res){
            this.model.userId=res.result.userId;
            this.weekList.push({label:res.result.nickname+"("+res.result.phone+")"
              ,value:res.result.userId});
          }
        })
      },
      getBank(){
        httpAction("/shoes/shoeInvestors/getBank?id="+this.model.investorsId,"","get").then((res)=>{
          if(res){
            this.model.cardNo = res.result.cardNo;
            this.model.bank = res.result.bank;
            this.model.openBank = res.result.openBank;
            this.model.cardName = res.result.cardName;

          }
        })
      },
      getLockerList(){
        httpAction("/shoes/shoeLocker/investorsShoeLockerList?investorsId="+this.model.investorsId,"","get").then((res)=>{
          if(res){
            this.lockerList = res.result;
          }
        })
      },
      getAgentList(){
        httpAction("/shoes/shoeInvestors/agentList", null, "get").then((res)=>{
          if(res){
            this.agentList = res.result;

          }
        })
      },

      disabledLocker(id) {
        console.log("===========",id)
        return this.investorsLockerDtoList.map(item => +item.lockerId).includes(+id)
      },
      // 点击新增产品
      onAddLocker() {
        this.investorsLockerDtoList.push({
          lockerId: '',
          percentage: 0,
        })
      },
      // 删除产品
      onDeleteLocker(idx) {
        this.investorsLockerDtoList.splice(idx, 1)
      },
    }
  }
</script>


<style lang="less" scoped>
.locker {
  display: flex;
  width: calc(100% - 48px);
  margin-left: 48px;
  margin-bottom: 24px;

  &-label {
    margin-left: 32px;
  }
}

.required::before {
  display: inline-block;
  margin-right: 4px;
  color: #f5222d;
  font-size: 14px;
  font-family: SimSun, sans-serif;
  line-height: 1;
  content: '*';
}
</style>