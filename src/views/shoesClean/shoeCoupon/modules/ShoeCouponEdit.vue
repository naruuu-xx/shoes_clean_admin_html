<template>
  <j-modal
    :title="title"
    :width="width"
    :visible="visible"
    switchFullscreen
    @ok="submitForm"
    :okButtonProps="{ class:{'jee-hidden': disableSubmit} }"
    @cancel="handleCancel"
    cancelText="关闭">

    <a-spin :spinning="confirmLoading">
      <j-form-container :disabled="formDisabled">
        <a-form-model ref="form" :model="model" :rules="validatorRules" slot="detail">
          <div class="diyDiv">
            <a-row>
              <a-col :span="24">
                <a-form-model-item label="发放方式" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="way">
                  <a-radio-group v-model:value="model.way" :disabled="true">
                    <a-radio value="0">自行领取</a-radio>
                    <a-radio value="1">平台发放</a-radio>
                    <a-radio value="2">卡包</a-radio>
                  </a-radio-group>
                </a-form-model-item>
              </a-col>
              <a-col :span="24">
                <a-form-model-item label="优惠券名称" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="name">
                  <a-input v-model="model.name" placeholder="请输入优惠券名称" style="width: 200px" ></a-input>
                </a-form-model-item>
              </a-col>
              <a-col :span="24">
                <a-form-model-item label="优惠券面额" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="reduce">
                  <a-input-number :min="0" v-model="reduce" placeholder="请输入面额" style="width: 100px" />
                </a-form-model-item>
              </a-col>
              <a-col :span="24">
                <a-form-model-item label="使用门槛" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="min">
                  <a-radio-group v-model:value="threshold">
                    <a-radio value="1">无门槛</a-radio>
                    <a-radio value="2">满&nbsp;<a-input-number :min="0" v-model="min" style="width: 70px" ></a-input-number>&nbsp;元可用</a-radio>
                  </a-radio-group>
                </a-form-model-item>
              </a-col>
              <a-col :span="24">
                <a-form-model-item label="适用范围" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="range">
                  <a-radio-group v-model:value="model.range">
                    <a-radio value="1">通用</a-radio>
                    <a-radio value="2">指定商品&nbsp;
                      <a-select
                        v-model:value="selectedGoods"
                        mode="multiple"
                        style="width: 400px;"
                        placeholder="请选择"
                        :options="goodsOptions"
                        option-filter-prop="children"
                        :filter-option="filterOption"
                      >
                      </a-select>
                    </a-radio>
                  </a-radio-group>
                </a-form-model-item>
              </a-col>
              <a-col :span="24">
                <a-form-model-item label="使用期限" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="expireType">
                  <a-radio-group v-model:value="model.expireType">
                    <a-radio value="1">根据领取时间<br>
                      领取&nbsp;<a-input-number :min="0" v-model="model.expireDay" style="width: 70px" placeholder="天数" ></a-input-number>&nbsp;天后失效
                    </a-radio>
                    <a-radio value="2">自行设定时间<br>
                      <a-range-picker placeholder="开始时间" :show-time="true" date-format="YYYY-MM-DD HH:mm:ss" class="query-group-cust" v-model="startAndEndTime"/>
                    </a-radio>
                  </a-radio-group>
                </a-form-model-item>
              </a-col>

              <a-col :span="24">
                <a-form-model-item label="用户类型" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="obj">
                  <a-radio-group v-model:value="model.obj" :disabled="true">
                    <a-radio value="new">仅新用户</a-radio>
                    <a-radio value="old">仅老用户</a-radio>
                    <a-radio value="all">全部</a-radio>
                  </a-radio-group>
                </a-form-model-item>
              </a-col>

              <a-col :span="24">
                <a-form-model-item label="发放数量" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="num">
                  <a-radio-group v-model:value="numRadio">
                    <a-radio value="1">不限量</a-radio>
                    <a-radio value="2">限&nbsp;<a-input-number :min="0" v-model="model.num" style="width: 70px"></a-input-number>&nbsp;张</a-radio>
                  </a-radio-group>
                </a-form-model-item>
              </a-col>

              <a-col :span="24">
                <a-form-model-item label="用户领取次数" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="receiveCount">
                  <a-radio-group v-model:value="selectedReceiveCount">
                    <a-radio value="1">不限次</a-radio>
                    <a-radio value="2">一次</a-radio>
                  </a-radio-group>
                </a-form-model-item>
              </a-col>
              <a-col :span="24">
                <a-form-model-item label="权重" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="weight">
                  <a-input-number v-model="model.weight" placeholder="请输入权重" style="width: 100%" />
                </a-form-model-item>
              </a-col>
              <a-col :span="24">
                <a-form-model-item label="发放状态" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="status">
                  <a-radio-group v-model:value="model.status">
                    <a-radio value="0">停用</a-radio>
                    <a-radio value="1">启用</a-radio>
                  </a-radio-group>
                </a-form-model-item>
              </a-col>
              <a-col :span="24">
                <a-form-model-item label="备注" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="note">
                  <a-textarea v-model="model.note" rows="4" placeholder="请输入备注" />
                </a-form-model-item>
              </a-col>

            </a-row>
          </div>
        </a-form-model>
      </j-form-container>
    </a-spin>
  </j-modal>
</template>

<script>
  import moment from 'moment';
  import { httpAction, getAction } from '@/api/manage'
  import { validateDuplicateValue } from '@/utils/util'
  import JDateTimeDIY from "./JDateTimeDIY";

  export default {
    name: 'ShoeCouponEdit',
    components: {
      JDateTimeDIY
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
        title:'编辑优惠券',
        width:1200,
        visible: false,
        disableSubmit: false,
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
           couponId: [
              { required: true, message: '请输入优惠券id!'},
           ],
           name: [
              { required: true, message: '请输入优惠券名称!'},
           ],
           num: [
              { required: false, message: '请输入发放数量（-1为不限）!'},
           ],
           status: [
              { required: true, message: '请输入状态:0=停止发放,1=正常发放!'},
           ],
           weight: [
              { required: true, message: '请输入权重!'},
           ],
        },
        url: {
          add: "/ShoeCoupon/shoeCoupon/add",
          edit: "/ShoeCoupon/shoeCoupon/edit",
          queryById: "/ShoeCoupon/shoeCoupon/queryById"
        },
        threshold: "",
        goodsOptions: "",
        startAndEndTime: [],
        numRadio: "",
        selectedGoods: [],
        selectedReceiveCount: "",
        min: "",
        reduce: "",
        numShouldDisabled: false,
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
        this.threshold = "1";
        this.numRadio = "1";
        // this.model.range = "1";
        this.model = {
          "range": "1",
          "expireType": "1",
          "obj": "new",
          "numRadio": "1",
          "min": 0,
          "expireDay": 0,
          "num": 0,
          "way": "0",
          "receiveCount": "2",
          "status": "0"
        };
        
      },
      edit (record) {
        //弹窗出现的时候请求接口，获取商品列表
        httpAction("/ShoeCoupon/shoeCoupon/getGoodsTypeAndTitleList", null, "get").then((res) => {
          let result = res.result;
          this.goodsOptions = res.result.map((item,index,arr)=>{
            let c = {label:item.title, value:item.goodsId}
            return c;
          })
        })
        this.model = Object.assign({}, record);
        this.reduce = (this.model.reduce * 0.01).toFixed(2);
        this.min = (this.model.min * 0.01).toFixed(2);
        this.model.way = this.model.way.toString();
        this.model.expireType = this.model.expireType.toString();
        this.model.range = this.model.range.toString();
        this.model.status = this.model.status.toString();
        this.startAndEndTime = this.model.startTime ? [moment(this.model.startTime),moment(this.model.endTime)] : []
        this.visible = true;

        //单选框的判断赋值.
        //使用门槛
        let min = this.model.min;
        if (min > 0) {
          this.threshold = "2";
        } else {
         this.threshold = "1";
        }

        //发放数量
        let num = this.model.num;
        if (num < 0) {
          this.numRadio = "1";
        } else {
          this.numRadio = "2";
        }

        //用户可领取优惠券次数的判断
        let receiveCount = this.model.receiveCount;
        if (receiveCount < 0) {
          this.selectedReceiveCount = "1";
        } else {
          this.selectedReceiveCount = "2";
        }

        let range = this.model.range;
        if (range === "1") {
          this.goodsOptions = "通用";
        } else if (range === "2") {
          this.goodsOptions = this.model.rangeConfig;
        }

        //判断发放方式是 ”自行领取“ and ”平台发放“or”卡包“
        let way = this.model.way;
        if ("0" === way) {
          this.numShouldDisabled = false;
        } else {
          this.numShouldDisabled = true;
        }
      },
      submitForm () {
        const that = this;

        that.confirmLoading = true;
        let httpurl = '';
        let method = '';

        // if(!this.model.id){
        //   httpurl+=this.url.add;
        //   method = 'post';
        // }else{
        //   httpurl+=this.url.edit;
        //    method = 'put';
        // }

        httpurl+=this.url.edit;
        method = 'put';

        //处理金额
        this.model.reduce = this.reduce * 100;

        //使用范围
        let range = this.model.range;
        if (range === "1") {
          this.model = Object.assign(this.model, {"rangeConfig": null});
        }

        //发放数量
        let numRadio = this.numRadio;
        if (numRadio === "1") {
          // this.model.num = -1;
          this.model = Object.assign(this.model, {"num": -1});
        } else if (numRadio === "2") {
          if (this.model.num === "" || this.model.num === null || this.model.num === undefined) {
            this.$message.warning("请输入发放数量");
            that.confirmLoading = false;
            return false;
          }
        }

        // console.log("==========the last line of defense==========");
        // console.log(this.model);

        httpAction(httpurl,this.model,method).then((res)=>{
          if(res.success){
            that.$message.success(res.message);
            this.visible = false;
            that.$emit('ok');
          }else{
            that.$message.warning(res.message);
          }
        }).finally(() => {
          that.confirmLoading = false;
        })
        // that.confirmLoading = false;

      },
      handleChange(){
        console.log("有改变")
      },
      close(){
        this.visible = false;
      },
      handleCancel() {
        this.close();
      }
    }
  }
</script>
<style>
.diyDiv{
  width: 100%;
  height: 660px;
  overflow-y: scroll;
}
</style>