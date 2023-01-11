<template>
  <a-spin :spinning="confirmLoading">
    <j-form-container :disabled="formDisabled">
      <a-form-model ref="form" :model="model" :rules="validatorRules" slot="detail">
        <a-row>
          <a-col :span="24">
            <a-form-model-item label="次卡ID" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="timecardId">
              <a-input-number v-model="model.timecardId" placeholder="请输入次卡ID" style="width: 100%" />
            </a-form-model-item>
          </a-col>
          <a-col :span="24">
            <a-form-model-item label="次卡名称" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="name">
              <a-input v-model="model.name" placeholder="请输入次卡名称"  ></a-input>
            </a-form-model-item>
          </a-col>
          <a-col :span="24">
            <a-form-model-item label="图片" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="image">
              <a-input v-model="model.image" placeholder="请输入图片"  ></a-input>
            </a-form-model-item>
          </a-col>
          <a-col :span="24">
            <a-form-model-item label="可洗鞋数" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="num">
              <a-input-number v-model="model.num" placeholder="请输入可洗鞋数" style="width: 100%" />
            </a-form-model-item>
          </a-col>
          <a-col :span="24">
            <a-form-model-item label="有效天数" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="expireDay">
              <a-input-number v-model="model.expireDay" placeholder="请输入有效天数" style="width: 100%" />
            </a-form-model-item>
          </a-col>
          <a-col :span="24">
            <a-form-model-item label="适用商品配置：{{"goods_id": 1, "num":13,"minimum":},{"goods_id": 2, "num":10,"minimum":3}" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="rangeConfig">
              <a-input v-model="model.rangeConfig" placeholder="请输入适用商品配置：{{"goods_id": 1, "num":13,"minimum":},{"goods_id": 2, "num":10,"minimum":3}"  ></a-input>
            </a-form-model-item>
          </a-col>
          <a-col :span="24">
            <a-form-model-item label="最后一次下单是否需要满足最低下单鞋子数：0=否，1=是" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="useType">
              <a-input-number v-model="model.useType" placeholder="请输入最后一次下单是否需要满足最低下单鞋子数：0=否，1=是" style="width: 100%" />
            </a-form-model-item>
          </a-col>
          <a-col :span="24">
            <a-form-model-item label="运费减免类型：0=不减免，1=免配送费，2=免配送费或运费" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="type">
              <a-input-number v-model="model.type" placeholder="请输入运费减免类型：0=不减免，1=免配送费，2=免配送费或运费" style="width: 100%" />
            </a-form-model-item>
          </a-col>
          <a-col :span="24">
            <a-form-model-item label="销量" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="sale">
              <a-input-number v-model="model.sale" placeholder="请输入销量" style="width: 100%" />
            </a-form-model-item>
          </a-col>
          <a-col :span="24">
            <a-form-model-item label="状态：0=下架，1=上架,(默认上架，后台不做该功能)" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="status">
              <a-input-number v-model="model.status" placeholder="请输入状态：0=下架，1=上架,(默认上架，后台不做该功能)" style="width: 100%" />
            </a-form-model-item>
          </a-col>
          <a-col :span="24">
            <a-form-model-item label="开放小程序购买，0=否，1=是" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="isShow">
              <a-input-number v-model="model.isShow" placeholder="请输入开放小程序购买，0=否，1=是" style="width: 100%" />
            </a-form-model-item>
          </a-col>
          <a-col :span="24">
            <a-form-model-item label="权重" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="weight">
              <a-input-number v-model="model.weight" placeholder="请输入权重" style="width: 100%" />
            </a-form-model-item>
          </a-col>
          <a-col :span="24">
            <a-form-model-item label="备注" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="note">
              <a-input v-model="model.note" placeholder="请输入备注"  ></a-input>
            </a-form-model-item>
          </a-col>
          <a-col :span="24">
            <a-form-model-item label="使用说明" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="rules">
              <a-textarea v-model="model.rules" rows="4" placeholder="请输入使用说明" />
            </a-form-model-item>
          </a-col>
          <a-col :span="24">
            <a-form-model-item label="软删除标识：0=正常，1=删除" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="delFlag">
              <a-input-number v-model="model.delFlag" placeholder="请输入软删除标识：0=正常，1=删除" style="width: 100%" />
            </a-form-model-item>
          </a-col>
          <a-col :span="24">
            <a-form-model-item label="删除时间" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="deleteTime">
              <j-date placeholder="请选择删除时间" v-model="model.deleteTime"  style="width: 100%" />
            </a-form-model-item>
          </a-col>
          <a-col :span="24">
            <a-form-model-item label="添加人ID" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="addUserId">
              <a-input v-model="model.addUserId" placeholder="请输入添加人ID"  ></a-input>
            </a-form-model-item>
          </a-col>
          <a-col :span="24">
            <a-form-model-item label="最后修改人ID（首次添加为添加人id）" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="editUserId">
              <a-input v-model="model.editUserId" placeholder="请输入最后修改人ID（首次添加为添加人id）"  ></a-input>
            </a-form-model-item>
          </a-col>
        </a-row>
      </a-form-model>
    </j-form-container>
  </a-spin>
</template>

<script>

  import { httpAction, getAction } from '@api/manage'
  import { validateDuplicateValue } from '@/utils/util'

  export default {
    name: 'ShoeTimecardForm',
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
           timecardId: [
              { required: true, message: '请输入次卡ID!'},
           ],
           name: [
              { required: true, message: '请输入次卡名称!'},
           ],
           image: [
              { required: true, message: '请输入图片!'},
           ],
           num: [
              { required: true, message: '请输入可洗鞋数!'},
           ],
           expireDay: [
              { required: true, message: '请输入有效天数!'},
           ],
           rangeConfig: [
              { required: true, message: '请输入适用商品配置：{{"goods_id": 1, "num":13,"minimum":},{"goods_id": 2, "num":10,"minimum":3}!'},
           ],
           useType: [
              { required: true, message: '请输入最后一次下单是否需要满足最低下单鞋子数：0=否，1=是!'},
           ],
           type: [
              { required: true, message: '请输入运费减免类型：0=不减免，1=免配送费，2=免配送费或运费!'},
           ],
           sale: [
              { required: true, message: '请输入销量!'},
           ],
           status: [
              { required: true, message: '请输入状态：0=下架，1=上架,(默认上架，后台不做该功能)!'},
           ],
           isShow: [
              { required: true, message: '请输入开放小程序购买，0=否，1=是!'},
           ],
           weight: [
              { required: true, message: '请输入权重!'},
           ],
           rules: [
              { required: true, message: '请输入使用说明!'},
           ],
           delFlag: [
              { required: true, message: '请输入软删除标识：0=正常，1=删除!'},
           ],
           addUserId: [
              { required: true, message: '请输入添加人ID!'},
           ],
           editUserId: [
              { required: true, message: '请输入最后修改人ID（首次添加为添加人id）!'},
           ],
        },
        url: {
          add: "/shoeTimecard/shoeTimecard/add",
          edit: "/shoeTimecard/shoeTimecard/edit",
          queryById: "/shoeTimecard/shoeTimecard/queryById"
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