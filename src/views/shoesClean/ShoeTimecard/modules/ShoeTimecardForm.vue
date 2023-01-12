<template>
  <a-spin :spinning="confirmLoading">
    <j-form-container :disabled="formDisabled">
      <a-form-model ref="form" :model="model" :rules="validatorRules" slot="detail">
        <a-row>
          <a-col :span="24">
            <a-form-model-item label="次卡名称" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="name">
              <a-input v-model="model.name" placeholder="请输入次卡名称"></a-input>
            </a-form-model-item>
          </a-col>
          <a-col :span="24">
            <a-form-model-item label="卡面" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="image">
              <j-image-upload v-model="model.image" text="上传"></j-image-upload>
            </a-form-model-item>
          </a-col>
          <a-col :span="24">
            <a-form-model-item label="商品选择" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="goodList" required>
              <a-button type="primary" @click="onAddGood">新增</a-button>
            </a-form-model-item>
          </a-col>
          <div v-for="(good, idx) in goodList" :key="`good${idx}`">
            <div class="good">
              <div class="good-label">
                商品{{ idx + 1 }}：
                <a-select style="width: 120px" v-model="good.goods_id">
                  <a-select-option :value="item.id" v-for="(item, index) in goods" :key="index">
                    {{ item.name }}
                  </a-select-option>
                </a-select>
              </div>
              <div class="good-label">
                鞋子总数：<a-input-number v-model="good.num" placeholder="请输入有效天数" :min="1" />
              </div>
              <div class="good-label">
                最低下单数：<a-input-number v-model="good.minimum" placeholder="请输入有效天数" :min="1" />
              </div>
              <div class="good-label">
                <a-button type="danger" @click="onDeleteGood(idx)" v-if="goodList.length > 1">删除</a-button>
              </div>
            </div>
          </div>

          <a-col :span="24">
            <a-form-model-item
              label=""
              :labelCol="{
                xs: { span: 0 },
                sm: { span: 0 },
              }"
              :wrapperCol="{
                xs: { span: 24 },
                sm: { span: 24 },
              }"
              prop="useType"
            >
            <span class="required">最后一次下单是否需要满足最低下单鞋子数</span><span
                style="color: #349fff; font-size: 10px"
                @click="visibleTip = true"
                >(查看说明)</span
              >：
              <a-radio-group v-model="model.useType">
                <a-radio value="0">是</a-radio>
                <a-radio value="1">否</a-radio>
              </a-radio-group>
            </a-form-model-item>
          </a-col>
          <a-col :span="24">
            <a-form-model-item label="使用期限" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="expireDay">
              领取<a-input-number v-model="model.expireDay" placeholder="输入天数" :min="1" />天后失效
            </a-form-model-item>
          </a-col>
          <a-col :span="24">
            <a-form-model-item label="分类折扣" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="classifyDiscountList">
              <a-button type="primary" @click="onAddClassify">新增</a-button>
            </a-form-model-item>
          </a-col>
          <div v-for="(classify, idx) in classifyDiscountList" :key="`classify${idx}`">
            <div class="good">
              <div class="good-label">
                商品分类{{ idx + 1 }}：
                <a-select style="width: 120px" v-model="classify.goodClassify">
                  <a-select-option :value="item.id" v-for="(item, index) in ClassifyList" :key="index">
                    {{ item.name }}
                  </a-select-option>
                </a-select>
              </div>
              <div class="good-label">
                折数:<a-input-number v-model="classify.discount" placeholder="请输入有效天数" :min="0.1" />
              </div>
              <div class="good-label"><a-button type="danger" @click="onDeleteClassify(idx)">删除</a-button></div>
            </div>
          </div>
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
            <a-form-model-item label="是否售卖" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="isShow">
              <a-col :span="6">
                <a-radio-group v-model="model.isShow">
                  <a-radio value="0">否</a-radio>
                  <a-radio value="1">是</a-radio>
                </a-radio-group>
              </a-col>
              <a-col :span="6"> 原价 <a-input-number v-model="model.originalPrice" placeholder="输入原价" :min="0" /> </a-col>
              <a-col :span="8">
                优惠价 <a-input-number v-model="model.preferentialPrice" placeholder="输入优惠价" :min="0" />
              </a-col>
            </a-form-model-item>
          </a-col>
          <a-col :span="24">
            <a-form-model-item label="使用规则" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="rules">
              <a-textarea v-model="model.rules" rows="4" placeholder="请输入使用规则" />
            </a-form-model-item>
          </a-col>
          <a-col :span="24">
            <a-form-model-item label="权重" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="weight">
              <a-input-number v-model="model.weight" placeholder="输入0-99 越大越靠前" :min="0" />
            </a-form-model-item>
          </a-col>
          <template v-if="model.id">
            <a-col :span="24">
            <a-form-model-item label="添加人" :labelCol="labelCol" :wrapperCol="wrapperCol">
              添加人
            </a-form-model-item>
          </a-col>
          <a-col :span="24">
            <a-form-model-item label="最后操作人" :labelCol="labelCol" :wrapperCol="wrapperCol">
              最后操作人
            </a-form-model-item>
          </a-col>
          </template>
        </a-row>
      </a-form-model>
    </j-form-container>
    <a-modal v-model="visibleTip" title="使用说明" :footer="null">
      假设总鞋子数为10双，最低下单鞋子数为3双，当用户已经用掉了5双鞋子下单后，<br/>1、选择是的话，最后一次下单用户必须下5双鞋子，只能下单一次；<br/>2、选择否的话，用户可以先下3双的单，再下2双的单，可以下单两次；
    </a-modal>
  </a-spin>
</template>

<script>
import { httpAction, getAction } from '@api/manage'
import { validateDuplicateValue } from '@/utils/util'
import { filter } from 'vuedraggable'
import { every } from 'lodash'
import Vue from 'vue'
// 验证商品选择
let validateGood = (rule, value, callback) => {
  if (!value.length) {
    callback('请添加适用商品！')
  } else {
    let n = value.every((item) => {
      return item.goods_id && item.num && item.minimum
    })
    if (!n) {
      // this.$refs.ruleForm.validateField('checkPass');
      callback('请补充商品信息！')
    }
    callback()
  }
}
// 验证分类折扣选择
let validateClassifyDiscount = (rule, value, callback) => {
  let n = value.every((item) => {
      return item.goodClassify && item.discount
    })
    if (!n) {
      // this.$refs.ruleForm.validateField('checkPass');
      callback('请补充分类折扣信息！')
    }
    callback()
}

export default {
  name: 'ShoeTimecardForm',
  components: {},
  props: {
    //表单禁用
    disabled: {
      type: Boolean,
      default: false,
      required: false,
    },
  },
  data() {
    return {
      model: {
        goodList: '',
        classifyDiscountList: ''
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
        timecardId: [{ required: true, message: '请输入次卡ID!' }],
        name: [{ required: true, message: '请输入次卡名称!' }],
        image: [{ required: true, message: '请输入图片!' }],
        num: [{ required: true, message: '请输入可洗鞋数!' }],
        expireDay: [{ required: true, message: '请输入有效天数!' }],
        rangeConfig: [
          {
            required: true,
            message: '请输入适用商品配置：{{"goods_id": 1, "num":13,"minimum":},{"goods_id": 2, "num":10,"minimum":3}!',
          },
        ],
        useType: [{ required: true, message: '请输入最后一次下单是否需要满足最低下单鞋子数!' }],
        type: [{ required: true, message: '请输入运费减免类型' }],
        sale: [{ required: true, message: '请输入销量!' }],
        rules: [{ required: true, message: '请输入使用规则!' }],
        weight: [{ required: true, message: '请输入权重!' }],
        isShow: [{ required: true, message: '是否售卖!' }],
        goodList: [{ validator: validateGood, trigger: 'change' }],
        classifyDiscountList: [{ validator: validateClassifyDiscount, trigger: 'change' }],
      },
      url: {
        add: '/shoeTimecard/shoeTimecard/add',
        edit: '/shoeTimecard/shoeTimecard/edit',
        queryById: '/shoeTimecard/shoeTimecard/queryById',
      },
      goodList: [
        {
          goods_id: 1,
          num: 1,
          minimum: 1,
        },
      ],
      goods: [
        {
          name: '商品1',
          id: 1,
        },
        {
          name: '商品2',
          id: 2,
        },
        {
          name: '商品3',
          id: 3,
        },
      ],
      ClassifyList: [
        {
          name: '分类1',
          id: 1,
        },
        {
          name: '分类2',
          id: 2,
        },
      ],
      visibleTip: false,
      tipsContent: "假设总鞋子数为10双，最低下单鞋子数为3双，当用户已经用掉了5双鞋子下单后，<br/>1、选择是的话，最后一次下单用户必须下5双鞋子，只能下单一次；<br/>2、选择否的话，用户可以先下3双的单，再下2双的单，可以下单两次；",
      // 分类折扣
      classifyDiscountList: [],
    }
  },
  computed: {
    formDisabled() {
      return this.disabled
    },
  },
  watch: {
    goodList: {
      handler(val) {
        this.model.goodList = val
      },
      deep: true,
      immediate: true,
    },
    classifyDiscountList: {
      handler(val) {
        this.model.classifyDiscountList = val
      },
      deep: true,
      immediate: true,
    },
  },
  created() {
    //备份model原始值
    this.modelDefault = JSON.parse(JSON.stringify(this.model))
  },
  mounted() {
    this.validatorRules.isShow.push({ validator: this.validateSell, trigger: 'change' })
  },
  methods: {
    // 验证是否售卖
validateSell(rule, value, callback){
  if(value == 1) {
    if (!this.model.originalPrice) {
      callback('原价不能为空！')
    }
    if (!this.model.preferentialPrice) {
      callback('优惠价不能为空！')
    }
  } else {
    callback()
  }
  
},
    // 点击新增产品
    onAddGood() {
      this.goodList.push({
        goods_id: '',
        num: 1,
        minimum: 1,
      })
    },
    // 点击新增分类折扣
    onAddClassify() {
      this.classifyDiscountList.push({
        goodClassify: '',
        discount: 0.1,
      })
    },
    // 删除产品
    onDeleteGood(idx) {
      this.goodList.splice(idx, 1)
    },
    // 删除分类
    onDeleteClassify(idx) {
      this.classifyDiscountList.splice(idx, 1)
    },

    add() {
      this.edit(this.modelDefault)
    },
    edit(record) {
      this.model = Object.assign({}, record)
      this.visible = true
    },
    submitForm() {
      const that = this
      // 触发表单验证
      console.log('goodList', this.goodList)
      this.$refs.form.validate((valid) => {
        if (valid) {
          that.confirmLoading = true
          let httpurl = ''
          let method = ''
          if (!this.model.id) {
            httpurl += this.url.add
            method = 'post'
          } else {
            httpurl += this.url.edit
            method = 'put'
          }
          httpAction(httpurl, this.model, method)
            .then((res) => {
              if (res.success) {
                that.$message.success(res.message)
                that.$emit('ok')
              } else {
                that.$message.warning(res.message)
              }
            })
            .finally(() => {
              that.confirmLoading = false
            })
        }
      })
    },
  },
}
</script>
<style lang="less" scoped>
.good {
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