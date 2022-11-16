<template>
  <a-spin :spinning="confirmLoading">
    <j-form-container :disabled="formDisabled">
      <a-form-model ref="form" :model="model" :rules="validatorRules" slot="detail">
        <div class="diyDiv">
          <a-row>

            <a-col :span="24">
              <a-form-model-item label="优惠券名称" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="name">
                <a-input v-model="model.name" placeholder="请输入优惠券名称" style="width: 200px" ></a-input>
              </a-form-model-item>
            </a-col>
            <a-col :span="24">
              <a-form-model-item label="优惠券面额" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="reduce">
                <a-input-number :min="0" v-model="model.reduce" placeholder="请输入面额" style="width: 100px" />
              </a-form-model-item>
            </a-col>
            <a-col :span="24">
              <a-form-model-item label="使用门槛" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="min">
                <a-radio-group v-model:value="threshold">
                  <a-radio value="1">无门槛</a-radio>
                  <a-radio value="2">满&nbsp;<a-input-number :min="0" v-model="model.min" style="width: 70px"></a-input-number>&nbsp;元可用</a-radio>
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
                      @change="handleChange"
                    >
                    </a-select>
                  </a-radio>
                </a-radio-group>
              </a-form-model-item>
            </a-col>
            <a-col :span="24">
              <a-form-model-item label="使用期限" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="expireType">
  <!--              <a-input-number v-model="model.expireType" placeholder="请输入过期类型:1=领取后生效,2=固定时间" style="width: 100%" />-->
                <a-radio-group v-model:value="model.expireType">
                  <a-radio value="1">根据领取时间<br>
                    领取&nbsp;<a-input-number :min="0" v-model="model.expireDay" style="width: 70px" placeholder="天数"></a-input-number>&nbsp;天后失效
                  </a-radio>
                  <a-radio value="2">自行设定时间<br>
                    <j-date-time-d-i-y placeholder="开始时间" :show-time="true" date-format="YYYY-MM-DD HH:mm:ss" class="query-group-cust" v-model="startAndEndTime"/>
                  </a-radio>
                </a-radio-group>
              </a-form-model-item>
            </a-col>

            <a-col :span="24">
              <a-form-model-item label="用户类型" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="obj">
                <a-radio-group v-model:value="model.obj">
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
              <a-form-model-item label="发放方式" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="way">
                <a-radio-group v-model:value="model.way">
                  <a-radio value="0">自行领取</a-radio>
                  <a-radio value="1">系统发放</a-radio>
                  <a-radio value="2">卡包</a-radio>
                </a-radio-group>
              </a-form-model-item>
            </a-col>

            <a-col :span="24">
              <a-form-model-item label="用户领取次数" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="receiveCount">
  <!--              <a-input-number :min="1" v-model="model.receiveCount" style="width: 70px"></a-input-number>-->
                <a-radio-group v-model:value="selectedReceiveCount">
                  <a-radio value="1">不限次</a-radio>
                  <a-radio value="2">一次</a-radio>
                </a-radio-group>
              </a-form-model-item>
            </a-col>

  <!--          <a-col :span="24">-->
  <!--            <a-form-model-item label="状态:0=停止发放,1=正常发放" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="status">-->
  <!--              <a-input-number v-model="model.status" placeholder="请输入状态:0=停止发放,1=正常发放" style="width: 100%" />-->
  <!--            </a-form-model-item>-->
  <!--          </a-col>-->
            <a-col :span="24">
              <a-form-model-item label="使用规则" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="rules">
                <a-textarea v-model="model.rules" rows="4" placeholder="请输入使用规则" />
              </a-form-model-item>
            </a-col>
  <!--          <a-col :span="24">-->
  <!--            <a-form-model-item label="权重" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="weight">-->
  <!--              <a-input-number v-model="model.weight" placeholder="请输入权重" style="width: 100%" />-->
  <!--            </a-form-model-item>-->
  <!--          </a-col>-->
            <a-col :span="24">
              <a-form-model-item label="发放状态" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="status">
                <a-radio-group v-model:value="model.status">
                  <a-radio value="0">启用</a-radio>
                  <a-radio value="1">停用</a-radio>
                </a-radio-group>
              </a-form-model-item>
            </a-col>
          </a-row>
        </div>
      </a-form-model>
    </j-form-container>
  </a-spin>
</template>

<script>

  import { httpAction, getAction } from '@/api/manage'
  import { validateDuplicateValue } from '@/utils/util'
  import JDateTimeDIY from "./JDateTimeDIY";

  export default {
    name: 'ShoeCouponForm',
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
           type: [
              { required: true, message: '请输入优惠券类型:1=满减!'},
           ],
          reduce: [
            { required: true, message: '请输入面额!'},
          ],
           min: [
              // { required: true, message: '请输入最低使用金额!'},
              { required: false, message: '请输入最低使用金额!'},
           ],
           obj: [
              { required: true, message: '请输入适用对象:new=仅新用户,old=仅老用户,all=全部!'},
           ],
           way: [
              { required: true, message: '请输入发放方式:0=自行领取，1=系统发放!'},
           ],
           expireType: [
              { required: false, message: '请输入过期类型:1=领取后生效,2=固定时间!'},
           ],
           range: [
              { required: false, message: '请输入适用范围:1=通用,2=指定商品!'},
           ],
           num: [
              { required: false, message: '请输入发放数量（-1为不限）!'},
           ],
           receiveNum: [
              { required: true, message: '请输入已领数量!'},
           ],
           useNum: [
              { required: true, message: '请输入已使用数量!'},
           ],
           status: [
              { required: true, message: '请输入状态:0=停止发放,1=正常发放!'},
           ],
           weight: [
              { required: true, message: '请输入权重!'},
           ],
           addUserId: [
              { required: true, message: '请输入添加人id!'},
           ],
           editUserId: [
              { required: true, message: '请输入最后修改人id（首次添加为添加人id）!'},
           ],
        },
        url: {
          add: "/ShoeCoupon/shoeCoupon/add",
          edit: "/ShoeCoupon/shoeCoupon/edit",
          queryById: "/ShoeCoupon/shoeCoupon/queryById"
        },
        threshold: "1",
        goodsOptions: [],
        startAndEndTime: "",
        numRadio: "1",
        selectedGoods: [],
        selectedReceiveCount: "2",
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
        //弹窗出现的时候请求接口，获取商品列表
        httpAction("/ShoeCoupon/shoeCoupon/getGoodsTypeAndTitleList", null, "get").then((res) => {
          let result = res.result;
          this.goodsOptions = res.result.map((item,index,arr)=>{
            let c = {label:item.title, value:item.goodsId}
            return c;
          })
        })
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

            // if(!this.model.id){
            //   httpurl+=this.url.add;
            //   method = 'post';
            // }else{
            //   httpurl+=this.url.edit;
            //    method = 'put';
            // }

            httpurl+=this.url.add;
            method = 'post';

            //数据处理判断
            //满减金额
            let threshold = this.threshold;
            if (threshold === "1") {
              // this.model.min = 0;
              this.model = Object.assign(this.model, {"min": 0});
            } else if (threshold === "2") {
              if (this.model.num === "" || this.model.num === null || this.model.num === undefined) {
                this.$message.warning("请填写最低使用金额")
                return false;
              }
            }

            //使用范围
            let range = this.model.range;
            if (range === "1") {
              // this.model.rangeConfig = null;
              this.model = Object.assign(this.model, {"rangeConfig": null});
            } else if (range === "2") {
              // if (this.model.rangeConfig === "" || this.model.rangeConfig === null || this.model.rangeConfig === undefined) {
              if (this.selectedGoods.length < 1) {
                this.$message.warning("请选择商品")
                that.confirmLoading = false;
                return false;
              } else {
                this.model.rangeConfig = this.selectedGoods.toString();
              }

            }

            //使用期限
            let expireType = this.model.expireType;
            if (expireType === "1") {
              if (this.model.expireDay === "" || this.model.expireDay === null || this.model.expireDay === undefined) {
                this.$message.warning("请输入天数")
                that.confirmLoading = false;
                return false;
              }
            } else if (expireType === "2") {
              let startAndEndTime = this.startAndEndTime;
              if (startAndEndTime.length <= 0) {
                this.$message.warning("请选择日期和时间")
                that.confirmLoading = false;
                return false;
              } else {
                let startTime = startAndEndTime[0] + ":00";
                let endTime = startAndEndTime[1] + ":00";
                // this.model.startTime = startTime;
                // this.model.endTime = endTime;
                this.model = Object.assign(this.model, {"startTime": startTime, "endTime": endTime});
              }
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

            //用户可领取优惠券次数的判断
            let receiveCount = this.selectedReceiveCount;
            if (receiveCount === "1") {
              this.model.receiveCount = "-1";
            } else if (receiveCount === "2") {
              this.model.receiveCount = "1";
            }

            // console.log("==========the last line of defense==========");
            // console.log(this.model);

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
            // that.confirmLoading = false;
          }

        })
      },
      handleChange(){
        console.log("有改变")
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