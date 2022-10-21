<template>
  <a-spin :spinning="confirmLoading">
    <j-form-container :disabled="formDisabled">
      <a-form-model ref="form" :model="model" :rules="validatorRules" slot="detail">
        <a-row>
          <a-col :span="24">
            <a-form-model-item label="订单ID" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="orderId">
              <a-input-number v-model="model.orderId" placeholder="请输入订单ID" style="width: 100%" />
            </a-form-model-item>
          </a-col>
          <a-col :span="24">
            <a-form-model-item label="父订单ID" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="orderPId">
              <a-input-number v-model="model.orderPId" placeholder="请输入父订单ID" style="width: 100%" />
            </a-form-model-item>
          </a-col>
          <a-col :span="24">
            <a-form-model-item label="订单编号" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="no">
              <a-input v-model="model.no" placeholder="请输入订单编号"  ></a-input>
            </a-form-model-item>
          </a-col>
          <a-col :span="24">
            <a-form-model-item label="用户ID" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="userId">
              <a-input-number v-model="model.userId" placeholder="请输入用户ID" style="width: 100%" />
            </a-form-model-item>
          </a-col>
          <a-col :span="24">
            <a-form-model-item label="商品ID" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="goodsId">
              <a-input-number v-model="model.goodsId" placeholder="请输入商品ID" style="width: 100%" />
            </a-form-model-item>
          </a-col>
          <a-col :span="24">
            <a-form-model-item label="规格ID" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="skuId">
              <a-input-number v-model="model.skuId" placeholder="请输入规格ID" style="width: 100%" />
            </a-form-model-item>
          </a-col>
          <a-col :span="24">
            <a-form-model-item label="商品名称" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="title">
              <a-input v-model="model.title" placeholder="请输入商品名称"  ></a-input>
            </a-form-model-item>
          </a-col>
          <a-col :span="24">
            <a-form-model-item label="规格名称" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="skuTitle">
              <a-input v-model="model.skuTitle" placeholder="请输入规格名称"  ></a-input>
            </a-form-model-item>
          </a-col>
          <a-col :span="24">
            <a-form-model-item label="商品图片" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="image">
              <a-input v-model="model.image" placeholder="请输入商品图片"  ></a-input>
            </a-form-model-item>
          </a-col>
          <a-col :span="24">
            <a-form-model-item label="洗护前照片" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="orderImages">
              <a-textarea v-model="model.orderImages" rows="4" placeholder="请输入洗护前照片" />
            </a-form-model-item>
          </a-col>
          <a-col :span="24">
            <a-form-model-item label="订单备注" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="note">
              <a-input v-model="model.note" placeholder="请输入订单备注"  ></a-input>
            </a-form-model-item>
          </a-col>
          <a-col :span="24">
            <a-form-model-item label="期望上门取件时间" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="expect">
              <a-input v-model="model.expect" placeholder="请输入期望上门取件时间"  ></a-input>
            </a-form-model-item>
          </a-col>
          <a-col :span="24">
            <a-form-model-item label="姓名" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="name">
              <a-input v-model="model.name" placeholder="请输入姓名"  ></a-input>
            </a-form-model-item>
          </a-col>
          <a-col :span="24">
            <a-form-model-item label="号码" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="phone">
              <a-input v-model="model.phone" placeholder="请输入号码"  ></a-input>
            </a-form-model-item>
          </a-col>
          <a-col :span="24">
            <a-form-model-item label="总金额" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="totalPrice">
              <a-input-number v-model="model.totalPrice" placeholder="请输入总金额" style="width: 100%" />
            </a-form-model-item>
          </a-col>
          <a-col :span="24">
            <a-form-model-item label="应付金额" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="price">
              <a-input-number v-model="model.price" placeholder="请输入应付金额" style="width: 100%" />
            </a-form-model-item>
          </a-col>
          <a-col :span="24">
            <a-form-model-item label="实付金额" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="actualPrice">
              <a-input-number v-model="model.actualPrice" placeholder="请输入实付金额" style="width: 100%" />
            </a-form-model-item>
          </a-col>
          <a-col :span="24">
            <a-form-model-item label="商品金额" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="goodsPrice">
              <a-input-number v-model="model.goodsPrice" placeholder="请输入商品金额" style="width: 100%" />
            </a-form-model-item>
          </a-col>
          <a-col :span="24">
            <a-form-model-item label="配送费用" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="courierPrice">
              <a-input-number v-model="model.courierPrice" placeholder="请输入配送费用" style="width: 100%" />
            </a-form-model-item>
          </a-col>
          <a-col :span="24">
            <a-form-model-item label="优惠抵扣金额" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="couponPrice">
              <a-input-number v-model="model.couponPrice" placeholder="请输入优惠抵扣金额" style="width: 100%" />
            </a-form-model-item>
          </a-col>
          <a-col :span="24">
            <a-form-model-item label="订单状态：0=待付款，1=洗护中，2=待取件，3=已完成，4=已取消，5=退款中，6=已退款，7=异常" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="status">
              <a-input v-model="model.status" placeholder="请输入订单状态：0=待付款，1=洗护中，2=待取件，3=已完成，4=已取消，5=退款中，6=已退款，7=异常"  ></a-input>
            </a-form-model-item>
          </a-col>
          <a-col :span="24">
            <a-form-model-item label="机柜ID（下单）" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="beforeLockerId">
              <a-input-number v-model="model.beforeLockerId" placeholder="请输入机柜ID（下单）" style="width: 100%" />
            </a-form-model-item>
          </a-col>
          <a-col :span="24">
            <a-form-model-item label="机柜格子编号（下单）" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="beforeGridNo">
              <a-input-number v-model="model.beforeGridNo" placeholder="请输入机柜格子编号（下单）" style="width: 100%" />
            </a-form-model-item>
          </a-col>
          <a-col :span="24">
            <a-form-model-item label="机柜ID（配送）" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="afterLockerId">
              <a-input-number v-model="model.afterLockerId" placeholder="请输入机柜ID（配送）" style="width: 100%" />
            </a-form-model-item>
          </a-col>
          <a-col :span="24">
            <a-form-model-item label="机柜格子编号（配送）" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="afterGridNo">
              <a-input-number v-model="model.afterGridNo" placeholder="请输入机柜格子编号（配送）" style="width: 100%" />
            </a-form-model-item>
          </a-col>
          <a-col :span="24">
            <a-form-model-item label="工厂编码" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="orgCode">
              <a-input v-model="model.orgCode" placeholder="请输入工厂编码"  ></a-input>
            </a-form-model-item>
          </a-col>
          <a-col :span="24">
            <a-form-model-item label="袋子编码" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="bagCode">
              <a-input v-model="model.bagCode" placeholder="请输入袋子编码"  ></a-input>
            </a-form-model-item>
          </a-col>
          <a-col :span="24">
            <a-form-model-item label="异常历史:0=无,1=有" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="hasException">
              <a-input-number v-model="model.hasException" placeholder="请输入异常历史:0=无,1=有" style="width: 100%" />
            </a-form-model-item>
          </a-col>
          <a-col :span="24">
            <a-form-model-item label="订单类型:self=站点自寄,service=上门取件" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="type">
              <a-input v-model="model.type" placeholder="请输入订单类型:self=站点自寄,service=上门取件"  ></a-input>
            </a-form-model-item>
          </a-col>
          <a-col :span="24">
            <a-form-model-item label="自提取件码" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="code">
              <a-input v-model="model.code" placeholder="请输入自提取件码"  ></a-input>
            </a-form-model-item>
          </a-col>
          <a-col :span="24">
            <a-form-model-item label="取消时间" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="cancelTime">
              <j-date placeholder="请选择取消时间"  v-model="model.cancelTime" :show-time="true" date-format="YYYY-MM-DD HH:mm:ss" style="width: 100%" />
            </a-form-model-item>
          </a-col>
          <a-col :span="24">
            <a-form-model-item label="付款时间" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="payTime">
              <j-date placeholder="请选择付款时间"  v-model="model.payTime" :show-time="true" date-format="YYYY-MM-DD HH:mm:ss" style="width: 100%" />
            </a-form-model-item>
          </a-col>
          <a-col :span="24">
            <a-form-model-item label="完成时间" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="finishTime">
              <j-date placeholder="请选择完成时间"  v-model="model.finishTime" :show-time="true" date-format="YYYY-MM-DD HH:mm:ss" style="width: 100%" />
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
    name: 'ShoeOrderForm',
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
           orderId: [
              { required: true, message: '请输入订单ID!'},
           ],
           orderPId: [
              { required: true, message: '请输入父订单ID!'},
           ],
           no: [
              { required: true, message: '请输入订单编号!'},
           ],
           userId: [
              { required: true, message: '请输入用户ID!'},
           ],
           goodsId: [
              { required: true, message: '请输入商品ID!'},
           ],
           skuId: [
              { required: true, message: '请输入规格ID!'},
           ],
           title: [
              { required: true, message: '请输入商品名称!'},
           ],
           skuTitle: [
              { required: true, message: '请输入规格名称!'},
           ],
           image: [
              { required: true, message: '请输入商品图片!'},
           ],
           orderImages: [
              { required: true, message: '请输入洗护前照片!'},
           ],
           name: [
              { required: true, message: '请输入姓名!'},
           ],
           phone: [
              { required: true, message: '请输入号码!'},
           ],
           totalPrice: [
              { required: true, message: '请输入总金额!'},
           ],
           price: [
              { required: true, message: '请输入应付金额!'},
           ],
           actualPrice: [
              { required: true, message: '请输入实付金额!'},
           ],
           goodsPrice: [
              { required: true, message: '请输入商品金额!'},
           ],
           courierPrice: [
              { required: true, message: '请输入配送费用!'},
           ],
           couponPrice: [
              { required: true, message: '请输入优惠抵扣金额!'},
           ],
           status: [
              { required: true, message: '请输入订单状态：0=待付款，1=洗护中，2=待取件，3=已完成，4=已取消，5=退款中，6=已退款，7=异常!'},
           ],
           beforeLockerId: [
              { required: true, message: '请输入机柜ID（下单）!'},
           ],
           beforeGridNo: [
              { required: true, message: '请输入机柜格子编号（下单）!'},
           ],
           afterLockerId: [
              { required: true, message: '请输入机柜ID（配送）!'},
           ],
           afterGridNo: [
              { required: true, message: '请输入机柜格子编号（配送）!'},
           ],
           orgCode: [
              { required: true, message: '请输入工厂编码!'},
           ],
           hasException: [
              { required: true, message: '请输入异常历史:0=无,1=有!'},
           ],
           type: [
              { required: true, message: '请输入订单类型:self=站点自寄,service=上门取件!'},
           ],
        },
        url: {
          add: "/ShoeOrder/shoeOrder/add",
          edit: "/ShoeOrder/shoeOrder/edit",
          queryById: "/ShoeOrder/shoeOrder/queryById"
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