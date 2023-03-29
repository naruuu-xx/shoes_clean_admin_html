<template>
  <a-spin :spinning="confirmLoading">
    <j-form-container :disabled="formDisabled">
      <a-form-model ref="form" :model="model" :rules="validatorRules" slot="detail">
        <a-row>
          <a-col :span="24">
            <a-form-model-item label="姓名" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="name">
              <a-input v-model.trim="model.name" placeholder="请输入姓名"></a-input>
            </a-form-model-item>
          </a-col>
          <a-col :span="24">
            <a-form-model-item label="手机号" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="phone">
              <a-input v-model.trim="model.phone" placeholder="请输入手机号"></a-input>
            </a-form-model-item>
          </a-col>
          <a-col :span="24">
            <a-form-model-item label="绑定小程序账号" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="appletIds">
              <XfSelect
                style="width: 100%"
                :list="weekList"
                @change="checkedSelect"
                @changeList="changeSelect"
                v-model="model.appletIds"
                :url='`/shoes/shoeUser/getCouponOrCardBag?type=0`'
                mode="multiple"
              >
              </XfSelect>
            </a-form-model-item>
          </a-col>
          <a-col :span="24">
            <a-form-model-item label="配送方式" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="type">
              <a-radio-group v-model="model.type">
                <a-radio :value="0">物流平台</a-radio>
                <a-radio :value="1">快递配送</a-radio>
              </a-radio-group>
            </a-form-model-item>
          </a-col>
          <a-col :span="24">
            <a-form-model-item label="最低下单鞋数" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="type">
              <a-input-number v-model="model.minimum" placeholder="最低下单鞋子数" @change="v => model.minimum = parseInt(v)" :min="1"/>
            </a-form-model-item>
          </a-col>
        </a-row>
      </a-form-model>
      
    </j-form-container>
  </a-spin>
</template>

<script>
import {httpAction, getAction} from '@api/manage'
import XfSelect from '@/components/Xf/XfSelect'
export default {
  name: 'ShoeTimecardForm',
  components: {
    XfSelect
  },
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
        classifyDiscountList: '',
        image: "https://shoes-clean.oss-cn-shenzhen.aliyuncs.com/icon/2.0/card-bg.png"
      },
      labelCol: {
        xs: {span: 24},
        sm: {span: 5},
      },
      wrapperCol: {
        xs: {span: 24},
        sm: {span: 16},
      },
      confirmLoading: false,
      validatorRules: {
        name: [{required: true, message: '请输入姓名!'}],
        phone: [{required: true, message: '请输入手机号!'},{pattern: /^1[3456789]\d{9}$/, message: '请输入正确的手机号码!'}],
        num: [{required: true, message: '请输入可洗鞋数!'}]
      },
      url: {
        add: '/shoeTimecard/add',
        edit: '/shoeTimecard/edit',
      },
      weekList:[],
    }
  },
  computed: {
    formDisabled() {
      return this.disabled
    },
  },
  watch: {
  },
  created() {
    this.model.appletIds = [80, 81, 104 ]
  },
  mounted() {

  },
  methods: {
    changeSelect(data) {
      this.weekList = data.records.map(item => ({
        label: item.name,
        value: +item.id
      }));
    },
    checkedSelect(val) {
    },
    edit(record) {
      this.model = Object.assign({}, record);
      this.visible = true
    },
    submitForm() {
      console.log(99,this.model);
      const that = this;
      // 触发表单验证
      this.$refs.form.validate((valid) => {
        if (valid) {
          that.confirmLoading = true
          let httpurl = ''
          let method = ''
          if (!this.model.timecardId) {
            httpurl += this.url.add
            method = 'post'
          } else {
            httpurl += this.url.edit
            method = 'put'
          }

          let num = this.goodList.reduce((pre, item) => {
            return pre + item.num;
          }, 0);

          let form = {
            num
          };

          httpAction(httpurl, Object.assign({}, this.model, form), method).then((res) => {
            if (res.success) {
              that.$message.success(res.message)
              that.$emit('ok')
            } else {
              that.$message.warning(res.message)
            }
          }).finally(() => {
            that.confirmLoading = false
          })
          // that.confirmLoading = false
        }
      })
    },

  },
}
</script>
<style lang="less" scoped>

</style>