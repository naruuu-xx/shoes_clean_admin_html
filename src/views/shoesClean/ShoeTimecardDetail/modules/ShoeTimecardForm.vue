<template>
  <a-spin :spinning="confirmLoading">
    <j-form-container :disabled="formDisabled">
      <a-form-model ref="form" :model="model" :rules="validatorRules" slot="detail">
        <a-row>
          <a-col :span="24">
            <a-form-model-item label="次卡名称" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="name">
              <a-input v-model="model.name" placeholder="请输入次卡名称"  ></a-input>
            </a-form-model-item>
          </a-col>
          <a-col :span="24">
            <a-form-model-item label="卡面" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="image">
              <j-image-upload v-model="model.image" :isMultiple="true" text="上传"></j-image-upload>
            </a-form-model-item>
          </a-col>
          <a-col :span="24">
            <a-form-model-item label="商品选择" :labelCol="labelCol" :wrapperCol="wrapperCol">
              <a-button type="primary" @click="onAddGood">新增</a-button>
            </a-form-model-item>
          </a-col>
          <div v-for="(good,idx) in goodList" :key="idx">
            <div class="good">
              <div class="good-label">商品{{idx+1}}：
                <a-select style="width: 120px" v-model="good.goods_id">
                  <a-select-option :value="item.id" v-for="(item,index) in goods" :key="index">
                    {{item.name}}
                  </a-select-option>
                </a-select>
              </div>
              <div class="good-label">鞋子总数：<a-input-number v-model="good.num" placeholder="请输入有效天数" :min="1" /></div>
              <div class="good-label">最低下单数：<a-input-number v-model="good.minimum" placeholder="请输入有效天数" :min="1"/></div>
              <div class="good-label"><a-button type="danger" @click="onDeleteGood(idx)">删除</a-button></div>
            </div>
          </div>
          
          <a-col :span="24">
            <a-form-model-item label="" :labelCol="{
          xs: { span: 0 },
          sm: { span: 0 },
        }" :wrapperCol="{
          xs: { span: 24 },
          sm: { span: 24 },
        }" prop="useType">
        最后一次下单是否需要满足最低下单鞋子数<span style="color: #349fff;font-size: 10px" @click="visibleTip = true">(查看说明)</span>：
              <a-radio-group v-model="model.useType">
                <a-radio value="0">是</a-radio>
                <a-radio value="1">否</a-radio>
              </a-radio-group>
            </a-form-model-item>
          </a-col>
          <a-col :span="24">
            <a-form-model-item label="有效天数" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="expireDay">
              <a-input-number v-model="model.expireDay" placeholder="请输入有效天数" :min="1" />
            </a-form-model-item>
          </a-col>
          <a-col :span="24">
            <a-form-model-item label="是否免运费/配送费" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="type">
              <a-radio-group v-model="model.type">
                <a-radio value="0">不减免</a-radio>
                <a-radio value="1">免配送费</a-radio>
                <a-radio value="2">免配送费或运费</a-radio>
              </a-radio-group>
            </a-form-model-item>
          </a-col>
          <a-col :span="24">
            <a-form-model-item label="使用说明" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="rules">
              <a-textarea v-model="model.rules" rows="4" placeholder="请输入使用说明" />
            </a-form-model-item>
          </a-col>
        </a-row>
      </a-form-model>
    </j-form-container>
    <a-modal v-model="visibleTip" title="使用说明" :footer="null">
      {{ tipsContent }}
    </a-modal>
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
              { required: true, message: '请输入最后一次下单是否需要满足最低下单鞋子数!'},
           ],
           type: [
              { required: true, message: '请输入运费减免类型'},
           ],
           sale: [
              { required: true, message: '请输入销量!'},
           ],
           rules: [
              { required: true, message: '请输入使用说明!'},
           ],
        },
        url: {
          add: "/shoeTimecard/shoeTimecard/add",
          edit: "/shoeTimecard/shoeTimecard/edit",
          queryById: "/shoeTimecard/shoeTimecard/queryById"
        },
        goodList:[
          {
            goods_id:1,
            num:1,
            minimum:1
          }
        ],
        goods:[
          {
            name:'商品1',
            id:1,
          },
          {
            name:'商品2',
            id:2,
          },
          {
            name:'商品3',
            id:3,
          },
        ],
        visibleTip:false,
        tipsContent: 'jxsakxjaksjxka'
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
      // 点击新增产品
      onAddGood() {
        this.goodList.push({
          goods_id:'',
          num:1,
          minimum:1
        })
      },
      // 删除产品
      onDeleteGood(idx) {
        this.goodList.splice(idx,1)
      },
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
        console.log('goodList',this.goodList)
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
<style lang="less" scoped>
.good {
  display: flex;
  width: 100%;
  margin-left: 48px;
  margin-bottom: 24px;
  &-label {
    margin-left:32px;
  }
}
</style>