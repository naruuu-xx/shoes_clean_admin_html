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
            <a-form-model-item label="绑定小程序账号" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="miniprogramUserIds">
              <XfSelect
                style="width: 100%"
                :list="weekList"
                @change="checkedSelect"
                @changeList="changeSelect"
                v-model="model.miniprogramUserIds"
                :url='`/shoes/shoeUser/getUserListBytype?type=customer`'
                mode="multiple"
              >
              </XfSelect>
            </a-form-model-item>
          </a-col>
          <a-col :span="24">
            <a-form-model-item label="配送方式" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="courierType">
              <a-radio-group v-model="model.courierType" disabled>
                <a-radio value="logistics">物流平台</a-radio>
                <a-radio value="expressage">快递配送</a-radio>
              </a-radio-group>
            </a-form-model-item>
          </a-col>
          <a-col :span="24">
            <a-form-model-item label="最低下单鞋数" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="miniNum">
              <a-input-number v-model="model.miniNum" placeholder="最低下单鞋子数" @change="v => model.miniNum = isNaN(parseInt(v)) ? 1 : parseInt(v)" :min="1"/>
            </a-form-model-item>
          </a-col>
          <a-col :span="24">
            <a-form-model-item label="状态" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="status">
              <a-radio-group v-model="model.status">
                <a-radio value="1">启用</a-radio>
                <a-radio value="0">禁用</a-radio>
              </a-radio-group>
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
        courierType: "expressage",
        customerId: "",
        miniNum: 1,
        miniprogramUserIds: [],
        name: "",
        phone: "",
        status: ""
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
        miniprogramUserIds: [{required: true, message: '请选择绑定小程序!'}],
        status: [{required: true, message: '请选择状态!'}],
        miniNum: [{required: true, message: '请输入最低下单鞋数'}],
      },
      url: {
        add: '/shoes/shoeCustomer/add',
        edit: '/shoes/shoeCustomer/edit',
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
    
  },
  mounted() {

  },
  methods: {
    reset() {
      this.visible = false
      this.model = {
        courierType: "expressage",
        customerId: "",
        miniNum: 1,
        miniprogramUserIds: [],
        name: "",
        phone: "",
        status: ""
      }
    },
    changeSelect(data) {
      this.weekList = data.records.map(item => ({
        label: `${item.nickname}(${item.phone})`,
        value: +item.userId
      }));
    },
    checkedSelect(val) {
    },
    edit(record) {
      let customerUserVos = record.customerUserVos.map(item => ({
        label: `${item.nickName}(${item.phone})`,
        value: +item.userId,
      }))
      this.weekList.push(...customerUserVos)
      let miniprogramUserIds = customerUserVos.map(item => item.value)
      
      this.model = Object.assign({},this.model, record,{miniprogramUserIds,customerUserVos});
      this.visible = true
    },
    submitForm() {
      // 触发表单验证
      this.$refs.form.validate((valid) => {
        if (valid) {
          console.log(999,this.model);
          this.confirmLoading = true
          let httpurl = ''
          let method = ''
          if (!this.model.customerId) {
            httpurl += this.url.add
            method = 'post'
          } else {
            httpurl += this.url.edit
            method = 'put'
          }

          let form = {
            ...this.model,
            miniprogramUserIds:this.model.miniprogramUserIds.join()
          };

          httpAction(httpurl, form, method).then((res) => {
            if (res.success) {
              this.$message.success(res.message)
              this.$emit('ok')
              this.reset()
            } else {
              this.$message.warning(res.message)
            }
          }).finally(() => {
            this.confirmLoading = false
          })
        }
      })
    },

  },
}
</script>
<style lang="less" scoped>

</style>