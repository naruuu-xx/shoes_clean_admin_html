<template>
  <j-modal
    :title="title"
    :width="500"
    :visible="visible"
    switchFullscreen
    @cancel="handleCancel"
    cancelText="关闭"
    :footer="null"
    wrapClassName="full-modal">
    <div>
      <a-row type="flex" justify="space-around" v-if="!userIds">
        <a-col :span="24">
          <div style="text-align: center;margin-bottom: 24px;color: #000000">用户昵称：{{nickname}}&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;手机号：{{phone}}</div>
        </a-col>
      </a-row>
      <a-row type="flex" justify="space-around">
        <a-col :span="24">
          <a-form-model-item label="派送类型" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="type">
            <a-radio-group v-model="type" @change="radioChange">
              <a-radio value="0" style="margin-right: 30px">优惠券</a-radio>
              <a-radio value="1" style="margin-right: 30px">卡包</a-radio>
              <a-radio value="2">鞋蜂卡</a-radio>
            </a-radio-group>
          </a-form-model-item>
        </a-col>
      </a-row>
      <a-row type="flex" justify="space-around">
        <a-col :span="24">
          <a-form-model-item :label="typeText" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="couponType">
            <XfSelect
                :list="weekList"
                @change="checkedSelect"
                @changeList="changeSelect"
                v-model="selectOption"
                :url='`/shoes/shoeUser/getCouponOrCardBagOrTimecard?type=${type}`'
                style="width: 100%;"
              >
              </XfSelect>
          </a-form-model-item>

        </a-col>
      </a-row>
      <a-row type="flex" justify="space-around">
        <a-col :span="24">
          <a-form-model-item label="派发原因" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="note">
            <a-input v-model="note" placeholder="请输入派发原因"></a-input>
          </a-form-model-item>
        </a-col>
      </a-row>
      <a-row>
        <a-col :span="24">
          <a-col :span="6"></a-col>
          <a-col :span="6">
            <a-button @click="handleCancel">取消</a-button>
          </a-col>
          <a-col :span="6">
            <a-button @click="handleSubmit" :loading="loading">确认</a-button>
          </a-col>
          <a-col :span="6"></a-col>
        </a-col>
      </a-row>
    </div>
    <a-modal
      :title="false"
      :visible="visibleModal"
      @ok="handleOk"
      @cancel="visibleModal = false"
      :confirmLoading="confirmLoading"
      :maskClosable="false"
    >
      <p style="text-align: center;">目前派发对象为<span style="color:red;font-size: 34px;">全体用户</span>,是否确认派发?</p>
    </a-modal>
  </j-modal>
</template>

<script>
  import XfSelect from '@/components/Xf/XfSelect'
import {getAction, httpAction} from "../../../../api/manage";

export default {
  name: "DistributeCouponModal",
  components:{
    XfSelect
  },
  data() {
    return {
      weekList:[],
      selectList:[], // 下拉选择的数组
      spinning:false,
      visible: false,
      title: '优惠券派送',
      note: '',
      couponTypeLabel: '选择优惠券',
      labelCol: {
        xs: { span: 24 },
        sm: { span: 5 },
      },
      wrapperCol: {
        xs: { span: 24 },
        sm: { span: 16 },
      },
      model: {},
      data: {},
      options: [],
      nickname: "",
      phone: "",
      type: "0",
      selectOption: "",
      record: null,
      validatorRules: {
        couponType: [{require: true, message: '请选择优惠券或卡包'}],
        note: [{require: true, message: '请输入派发原因'}]
      },
      userIds:undefined,
      visibleModal:false,
      loading:false,
      confirmLoading: false
    }
  },
  created() {
  },
  computed:{
    typeText() {
      return ['优惠券','卡包','鞋蜂卡'][this.type]
    }
  },
  methods: {
    handleOk() {
      this.confirmLoading = true
      let url = "/shoes/shoeUser/sendCouponOrCardBagToAll"
      let form = {
            type: this.type,
            id: this.selectOption,
            userIds: this.userIds,
            note: this.note
          }
      httpAction(url, form, "post").then((res) => {
          if (res.success) {
            this.$message.success(res.message);
            this.handleCancel()
          } else {
            this.$message.warning(res.message);
          }
        }).finally(res => {
          this.visibleModal = false
          this.confirmLoading = false
          this.loading = false
        })
    },
    changeSelect(data) {
      this.weekList = data.records.map(item => ({
        label: item.name,
        value: item.id
      }));
    },
    checkedSelect(val) {
      console.log(val,'checkedSelect',this.selectOption);
    },
    filterOption(input, option) {
      return (
        option.componentOptions.children[0].text.toLowerCase().indexOf(input.toLowerCase()) >= 0
      );
    },
    show(record,userIds) {
      this.visible = true;
      if(userIds) {
        this.userIds = userIds
      } else {
        this.nickname = record.nickname;
        this.phone = record.phone;
        this.note = record.note;
        this.record = record;
      }

    },
    handleCancel() {
      this.nickname = "";
      this.phone = "";
      this.note = "";
      this.type = "0";
      this.selectOption = "";
      this.userIds = undefined
      this.visible = false;
    },
    handleSubmit() {
      if (this.selectOption === null || this.selectOption === "") {
        this.$message.warning("请选择优惠券或卡包！");
        return;
      }
      if (this.note === null || this.note === "" || this.note ==undefined) {
        this.$message.warning("请输入派发原因！");
        return;
      } else {

        let url = ''
        let form = {}
        
        if(this.userIds) {
          // 手动派券
          
          if(!this.userIds.length) {
            return this.visibleModal = true
          } else {
            this.loading = true
            url = "/shoes/shoeUser/sendCouponOrCardBagToAll"
            form = {
              type: this.type,
              id: this.selectOption,
              userIds: this.userIds,
              note: this.note
            }
          }
        } else {
          this.loading = true
          // 当个派券
          url = "/shoes/shoeUser/distribute"
          let userId = this.record.userId;
          form = {
            "userId": userId,
            "distributeType": this.type,
            "couponOrCardBagId": this.selectOption,
            "note": this.note
          }
        }

        httpAction(url, form, "post").then((res) => {
          if (res.success) {
            this.$message.success(res.message);
            this.handleCancel()
          } else {
            this.$message.warning(res.message);
          }
        }).finally(res => {
          this.loading = false
        })
      }
    },
    radioChange(){
      this.selectOption = "";
    },
  }
}
</script>

<style scoped>

</style>