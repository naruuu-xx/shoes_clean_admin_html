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
            <a-radio-group v-model:value="type" @change="radioChange">
              <a-radio value="0" style="margin-right: 60px">优惠券</a-radio>
              <a-radio value="1">卡包</a-radio>
            </a-radio-group>
          </a-form-model-item>
        </a-col>
      </a-row>
      <a-row type="flex" justify="space-around">
        <a-col :span="24">
          <a-form-model-item v-if="" :label="type === '0' ? '选择优惠券' : '选择卡包' " :labelCol="labelCol" :wrapperCol="wrapperCol" prop="couponType">
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
            <a-button @click="handleSubmit">确认</a-button>
          </a-col>
          <a-col :span="6"></a-col>
        </a-col>
      </a-row>
    </div>
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
      userIds:undefined
    }
  },
  created() {
  },
  methods: {
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
      } else if (this.note === null || this.note == "") {
        this.$message.warning("请输入派发原因！");
      } else {

        let url = ''
        let form = {}
        if(this.userIds) {
          // 手动派券
          url = "/shoes/shoeUser/sendCouponOrCardBagToAll"
          form = {
            type: this.type,
            id: this.selectOption,
            userIds: this.userIds,
            note: this.note
          }
        } else {
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