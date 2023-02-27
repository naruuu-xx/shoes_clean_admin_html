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
      <a-row type="flex" justify="space-around">
        <a-col :span="24">
          <div style="text-align: center;margin-bottom: 24px;color: #000000">用户昵称：{{nickname}}&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;手机号：{{phone}}</div>
        </a-col>
      </a-row>
      <a-row type="flex" justify="space-around">
        <a-col :span="20">
          <a-form-model-item label="派送类型" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="type">
            <a-radio-group v-model:value="type" @change="radioChange">
              <a-radio value="0" style="margin-right: 60px">优惠券</a-radio>
              <a-radio value="1">卡包</a-radio>
            </a-radio-group>
          </a-form-model-item>
        </a-col>
      </a-row>
      <a-row type="flex" justify="space-around">
        <a-col :span="20">
          <a-form-model-item v-if="type === '0'" label="选择优惠券" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="couponType">
            <a-select
              v-model:value="selectOption"
              show-search
              placeholder="选择优惠券"
              style="width: 200px"
              option-filter-prop="children"
              :filter-option="filterOption"
            >
              <a-select-option v-for="item in couponList" :value="item.couponId" :key="item.couponId">{{item.name}}</a-select-option>
            </a-select>
            <!-- <XfSelect
                :list="weekList.records"
                labelKey="weekValue"
                valueKey="weekKey"
                :pageSize="weekList.size"
                :page="weekList.current"
                :total="weekList.total"
                :spinning="spinning"
                @change="selectTimeZone"
                @changePage="selectTimeZonePage"
                @handleSearch="handleSearch"
                v-model="selectOption"
              >
              </XfSelect> -->
          </a-form-model-item>
          <a-form-model-item v-else-if="type === '1'" label="选择卡包" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="couponType">
            <a-select
              v-model:value="selectOption"
              show-search
              placeholder="选择卡包"
              style="width: 200px"
              option-filter-prop="children"
              :filter-option="filterOption"
            >
              <a-select-option v-for="item in cardBagList" :value="item.cardBagId" :key="item.cardBagId">{{item.name}}</a-select-option>
            </a-select>
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
      weekList:{
        records:[{
          weekValue:'1',
          weekKey:'2'
        }],
        size:1,
        current:1,
        total:1
      },
      spinning:false,
      visible: false,
      title: '优惠券派送',
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
      couponList: "",
      cardBagList: "",
      record: null,
      validatorRules: {
        couponType: [{require: true, message: '请选择优惠券或卡包'}]
    }
    }
  },
  created() {
  },
  methods: {
    selectTimeZonePage(val) {
      console.log(val,1);
    },
    selectTimeZone(val) {
      console.log(val,2);
    },
    handleSearch(val) {
      console.log(val,3);
    },
    filterOption(input, option) {
      return (
        option.componentOptions.children[0].text.toLowerCase().indexOf(input.toLowerCase()) >= 0
      );
    },
    show(record) {
      this.visible = true;
      this.nickname = record.nickname;
      this.phone = record.phone;
      this.record = record;
      //默认是优惠券列表
      this.queryAllCouponList();
    },
    handleCancel() {
      this.nickname = "";
      this.phone = "";
      this.type = "0";
      this.couponList = "";
      this.cardBagList = "";
      this.selectOption = "";
      this.visible = false;
    },
    handleSubmit() {
      if (this.selectOption === null || this.selectOption === "") {
        this.$message.warning("请选择优惠券或卡包！");
      } else {
        let userId = this.record.userId;
        console.log(userId);

        let data = {
          "userId": userId,
          "distributeType": this.type,
          "couponOrCardBagId": this.selectOption
        };

        httpAction("/shoes/shoeUser/distribute", data, "post").then((res) => {
          if (res.success) {
            this.$message.success(res.message);
            this.nickname = "";
            this.phone = "";
            this.type = "0";
            this.couponList = "";
            this.cardBagList = "";
            this.selectOption = "";
            this.visible = false;
            this.$emit("ok");
          } else {
            this.$message.warning(res.message);
          }
        })
      }
    },
    radioChange(){
      //根据所选的单选值，请求不同的接口
      if (this.type === '0') {
        this.selectOption = "";
        this.cardBagList = "";
        this.queryAllCouponList();
      } else if (this.type === '1') {
        this.selectOption = "";
        this.couponList = "";
        this.queryAllCardBag();
      }
    },
    queryAllCouponList(){
      getAction("/ShoeCoupon/shoeCoupon/queryAllCouponList", null).then((res) => {
        if (res.success) {
          this.couponList = res.result;
        }
      })
    },
    queryAllCardBag(){
      getAction("/shoes/ShoeCardBag/queryAllCardBagList", null).then((res) => {
        if (res.success) {
          this.cardBagList = res.result;
        }
      })
    }
  }
}
</script>

<style scoped>

</style>