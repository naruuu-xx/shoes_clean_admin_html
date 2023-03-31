<template>
  <a-spin :spinning="confirmLoading">
    <j-form-container>
      <a-form-model ref="form" :model="model" :rules="validatorRules" slot="detail">
        <div>
          <a-row>

            <a-col :span="24">
              <a-form-model-item label="卡包名称" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="name">
                <a-input v-model="model.name" placeholder="请输入卡包名称" style="width: 200px" :maxLength="50" :disabled="editDisabled"></a-input>
              </a-form-model-item>
            </a-col>

            <a-col :span="24" >
              <a-form-model-item :labelCol="labelCol" :wrapperCol="wrapperCol" label="优惠卷选择">
                <a-button class="editable-add-btn" @click="handleAdd" :disabled="editDisabled">
                  新增
                </a-button>
                <a-table bordered :data-source="model.cardCouponList" :columns="columns" :pagination="paginations">
                  <template slot="couponId" slot-scope="text,index, record" prop="couponId">
                    <a-select :text="text" @change="onCellChange(record, 'couponId', $event)" v-if="!editDisabled">
                      <a-select-option v-for="i in couponList" :value="i.couponId" :key="i.couponId" >{{i.name}}</a-select-option>
                    </a-select>
                  </template>
                  <template slot="name" slot-scope="text,index, record" prop="name">
                    <template v-if="editDisabled">{{text}}</template>
                  </template>
                  <template slot = "num" slot-scope="text,index, record" prop="num">
                    <a-input-number defaultValue="1" :min="1" :step="1" :text="text" placeholder="请输入数量" style="width: 100px" @change="onCellChange(record,'num',$event)" v-if="!editDisabled"/>
                    <template v-else>{{text}}</template>
                  </template>
                  <template slot="operation" slot-scope="text, record">
                    <a-popconfirm title="确定要删除么？" @confirm="() => onDelete(record)">
                      <a href="javascript:;">删除</a>
                    </a-popconfirm>
                  </template>
                </a-table>
              </a-form-model-item>
            </a-col>

            <a-col :span="24">
              <a-form-model-item label="活动时间" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="startAndEndTime">
<!--                <a-range-picker format="YYYY-MM-DD HH:mm" v-model="model.startAndEndTime" :disabled="editDisabled"/>-->
                <j-date-time-d-i-y placeholder="开始时间" :show-time="true" date-format="YYYY-MM-DD HH:mm:ss" class="query-group-cust" v-model="model.startAndEndTime"/>
              </a-form-model-item>
            </a-col>

            <a-col :span="24">
              <a-form-model-item label="卡包数量" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="num">
                <a-input-number :min="1" :step="1" v-model="model.num" placeholder="请输入数量" style="width: 100px"/>
              </a-form-model-item>
            </a-col>

            <a-col :span="24">
              <a-form-model-item label="同一用户领取次数" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="receiveCount">
                <a-input-number :min="1" :step="1" v-model="model.receiveCount" placeholder="请输入次数" style="width: 100px" :disabled="editDisabled"/>
              </a-form-model-item>
            </a-col>

            <a-col :span="24">
              <a-form-model-item label="背景图" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="image">
                <j-image-upload v-model="model.image" :isMultiple="false" text="上传" :disabled="editDisabled"></j-image-upload>
              </a-form-model-item>
            </a-col>

            <a-col :span="24">
              <a-form-model-item label="领取成功回复内容" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="successMessage">
                <a-input v-model="model.successMessage" placeholder="请输入内容"  :maxLength="255" :disabled="editDisabled"></a-input>
              </a-form-model-item>
            </a-col>

            <a-col :span="24">
              <a-form-model-item label="重复领取回复内容" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="repeatMessage">
                <a-input v-model="model.repeatMessage" placeholder="请输入内容"  :maxLength="255" :disabled="editDisabled"></a-input>
              </a-form-model-item>
            </a-col>

            <a-col :span="24">
              <a-form-model-item label="卡包已被领取完回复内容" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="failMessage">
                <a-input v-model="model.failMessage" placeholder="请输入内容"  :maxLength="255" :disabled="editDisabled"></a-input>
              </a-form-model-item>
            </a-col>

            <a-col :span="24">
              <a-form-model-item label="未到领取时间回复内容" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="timeBeforeMessage">
                <a-input v-model="model.timeBeforeMessage" placeholder="请输入内容"  :maxLength="255" :disabled="editDisabled"></a-input>
              </a-form-model-item>
            </a-col>

            <a-col :span="24">
              <a-form-model-item label="领取时间结束回复内容" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="timeAfterMessage">
                <a-input v-model="model.timeAfterMessage" placeholder="请输入内容"  :maxLength="255" :disabled="editDisabled"></a-input>
              </a-form-model-item>
            </a-col>
          </a-row>
        </div>
      </a-form-model>
    </j-form-container>
  </a-spin>
</template>

<script>

import { httpAction, getAction } from '@/api/manage';
import JDateTimeDIY from "./JDateTimeDIY";

export default {
  name: 'ShoeCardBagForm',
  components: {
    JDateTimeDIY
  },
  data () {
    return {
      confirmLoading: false,
      editDisabled: false,
      paginations:{
        pageSize: 999
      },
      model:{
        cardBagId:"",
        name:"",
        startAndEndTime:[],
        startTime:null,
        endTime:null,
        num: 1,
        receiveCount: 1,
        image:"",
        successMessage: "",
        repeatMessage: "",
        failMessage:"",
        timeBeforeMessage:"",
        timeAfterMessage:"",
        cardCouponList:[],
      },
      labelCol: {
        xs: { span: 24 },
        sm: { span: 5 },
      },
      wrapperCol: {
        xs: { span: 24 },
        sm: { span: 16 },
      },
      validatorRules: {
        name: [
          { required: true, message: '请输入卡包名称!'},
        ],
        startAndEndTime: [
          { required: true, message: '请输入时间!'},
        ],
        num: [
          { required: true, message: '请输入数量!'},
        ],
        receiveCount: [
          { required: true, message: '请输入次数!'},
        ],
        image: [
          { required: true, message: '请选择背景图!'},
        ],
        successMessage: [
          { required: true, message: '请输入消息!'},
        ],
        repeatMessage: [
          { required: true, message: '请输入消息!'},
        ],
        failMessage: [
          { required: true, message: '请输入消息!'},
        ],
        timeBeforeMessage: [
          { required: true, message: '请输入消息!'},
        ],
        timeAfterMessage: [
          { required: true, message: '请输入消息!'},
        ],
      },
      columns : [
        {
          title: '优惠卷名称',
          dataIndex: 'couponId',
          align:"center",
          scopedSlots: { customRender: 'couponId' }
        },
        {
          title: '优惠卷名称',
          dataIndex: 'name',
          align:"center",
          scopedSlots: { customRender: 'name' }
        },
        {
          title: '数量',
          dataIndex: 'num',
          align:"center",
          scopedSlots: { customRender: 'num' },

        },
        {
          title: '操作',
          dataIndex: 'operation',
          align:"center",
          scopedSlots: { customRender: 'operation' },
        },
      ],
      couponList: [],
      url: {
        add: "/shoes/ShoeCardBag/add",
        edit: "/shoes/ShoeCardBag/edit",
      }
    }
  },
  created(){},
  mounted(){
    this.getCouponList();
  },
  methods: {
    add () {
      //隐藏名称
      this.columns = this.columns.filter(col => col.dataIndex !== "name");
      this.editDisabled = false;
      this.setDefaultModel();
    },
    edit (record) {
      this.model = Object.assign({}, record);
      this.model.startAndEndTime = [this.model.startTime, this.model.endTime];
      //隐藏下拉列表,操作
      this.columns = this.columns.filter(col => col.dataIndex !== "couponId");
      this.columns = this.columns.filter(col => col.dataIndex !== "operation");
      this.editDisabled = true;
    },
    submitForm () {
      const that = this;
      // 触发表单验证
      this.$refs.form.validate(valid => {
        if (valid && that.cardCouponListCheck()) {
          let httpurl = '';
          if(that.model.cardBagId){
            httpurl = that.url.edit;
          }else{
            httpurl = that.url.add;
            that.model.startTime = that.model.startAndEndTime[0].format("YYYY-MM-DD HH:mm:ss");
            that.model.endTime = that.model.startAndEndTime[1].format("YYYY-MM-DD HH:mm:ss");
          }
          httpAction(httpurl, this.model,"post").then((res)=>{
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
      });
    },
    //校验优惠券列表
    cardCouponListCheck(){
      const that = this;

      //编辑时
      if(that.model.cardBagId){
        return true;
      }
      if(!that.model.cardCouponList || that.model.cardCouponList.length == 0){
        that.$message.warning("请选择优惠卷!");
        return false;
      }
      for(let i = 0; i < that.model.cardCouponList.length; i++){
        if(!that.model.cardCouponList[i].couponId){
          that.$message.warning("请选择优惠卷（第" + (i+1) + "行)!");
          return false;
        }
        if(!that.model.cardCouponList[i].num){
          that.$message.warning("请输入数量（第" + (i+1) + "行)!");
          return false;
        }
      }
      return true;
    },
    handleAdd() {
      const dataSource  = this.model.cardCouponList;

      const newData = {
        couponId : '' ,
        num: 1,
      };
      this.model.cardCouponList = [...dataSource, newData];
    },
    onDelete(record) {
      const dataSource = [...this.model.cardCouponList];
      this.model.cardCouponList = dataSource.filter(item => item.couponId !== record.couponId);
    },
    onCellChange(record, dataIndex, value) {
      const dataSource = [... this.model.cardCouponList];

      const target = dataSource[record];
      if (target) {
        target[dataIndex] = value;
        this.model.cardCouponList = dataSource;
      }
    },
    getCouponList(){
      httpAction("/shoes/ShoeCardBag/queryCouponList", "", "get").then((res) => {
        if (res.success) {
          this.couponList = res.result;
        }
      })
    },
    setDefaultModel(){
      const that = this;
      that.model.image = "https://shoes-clean.oss-cn-shenzhen.aliyuncs.com/upload/20221118/微信图片_20221118145346_1668754455901.png";
      that.model.successMessage = "领取成功，快去看看吧";
      that.model.repeatMessage = "已经领取过啦，不能在领了";
      that.model.failMessage = "都被抢光啦，下次早点来吧";
      that.model.timeBeforeMessage = "活动还没开始呢，晚点再来吧";
      that.model.timeAfterMessage = "活动已经结束了，下次再来吧";
    }
  }
}
</script>
<style>
</style>