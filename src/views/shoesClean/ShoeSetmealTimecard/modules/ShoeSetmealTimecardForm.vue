<template>
  <a-spin :spinning="confirmLoading">
    <j-form-container :disabled="formDisabled">
      <a-form-model ref="form" :model="model" :rules="validatorRules" slot="detail">
        <a-row>

          <template >
            <a-col :span="24">
              <a-form-model-item label="平台" :labelCol="labelCol" :wrapperCol="wrapperCol"
                                 :prop="model.id ? '' : 'platform'">
                <div v-if="model.id ">222</div>
                <a-select style="width: 120px" v-model="model.platform" :disabled="model.setmealTimecardId">
                  <a-select-option :value="item.id" v-for="(item,index) in platformList" :key="index">
                    {{ item.name }}
                  </a-select-option>
                </a-select>
              </a-form-model-item>
            </a-col>
          </template>







          <a-col :span="24">
            <a-form-model-item label="套餐名称" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="setmeal">
              <a-input v-model="model.setmeal" placeholder="请输入套餐名称"></a-input>
            </a-form-model-item>
          </a-col>
          <a-col :span="24">
            <a-form-model-item label="匹配关键词" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="keyword">
              <a-input v-model="model.keyword" placeholder="请输入匹配关键词"></a-input>
            </a-form-model-item>
          </a-col>
          <a-col :span="24">
            <a-form-model-item label="鞋蜂卡" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="timecardId">
              <a-select v-model="model.timecardId">
                <a-select-option :value="item.timecardId" v-for="(item,index) in timecardList" :key="index">
                  {{ item.name }}
                </a-select-option>
              </a-select>
            </a-form-model-item>
          </a-col>
          <template v-if="model.setmealTimecardId!=null">
            <a-col :span="24">
              <a-form-model-item label="添加人" :labelCol="labelCol" :wrapperCol="wrapperCol">
                {{ model.addUserName }}
              </a-form-model-item>
            </a-col>
            <a-col :span="24">
              <a-form-model-item label="最后操作人" :labelCol="labelCol" :wrapperCol="wrapperCol">
                {{ model.editUserName }}
              </a-form-model-item>
            </a-col>
          </template>

        </a-row>
      </a-form-model>
    </j-form-container>
  </a-spin>
</template>

<script>

import {httpAction, getAction} from '@/api/manage'
import {validateDuplicateValue} from '@/utils/util'

export default {
  name: 'ShoeSetmealTimecardForm',
  components: {},
  props: {
    //表单禁用
    disabled: {
      type: Boolean,
      default: false,
      required: false
    }
  },
  data() {
    return {
      model: {},
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
        platform: [
          {required: true, message: '请输入平台!'},
        ],
        setmeal: [
          {required: true, message: '请输入套餐内容!'},
        ],
        keyword: [
          {required: true, message: '请输入匹配关键词!'},
        ],
        timecardId: [
          {required: true, message: '请输入次卡!'},
        ],

      },
      url: {
        add: "/shoeSetmealTimecard/add",
        edit: "/shoeSetmealTimecard/edit",
        queryById: "/shoeSetmealTimecard/queryById"
      },
      platformList: [
        {
          name: '洁小兔',
          id: 1,
        },
      ],
      timecardList: []
    }
  },
  computed: {
    formDisabled() {
      return this.disabled
    },
  },
  created() {
    //备份model原始值
    this.modelDefault = JSON.parse(JSON.stringify(this.model));
    this.selectTimecard();
  },
  methods: {
    selectTimecard() {
      httpAction("shoeSetmealTimecard/getTimecardList", null, "get").then((res) => {
        if (res) {
          this.timecardList = res.result;
        }
      })
    },
    add() {
      this.selectTimecard();
    },
    edit(record) {
      httpAction("shoeSetmealTimecard/selectSetmealTimecardById?id=" + record.setmealTimecardId, null, "get").then((res) => {
        if (res) {
          this.model = res.result;
        }
      })

      //this.model = Object.assign({}, record);
      // this.model.id = 1
      this.visible = true;
    },
    submitForm() {
      const that = this;
      // 触发表单验证
      this.$refs.form.validate(valid => {
        if (valid) {
          that.confirmLoading = true;
          let httpurl = '';
          let method = '';
          if (!this.model.setmealTimecardId) {
            httpurl += this.url.add;
            method = 'post';
          } else {
            httpurl += this.url.edit;
            method = 'put';
          }
          httpAction(httpurl, this.model, method).then((res) => {
            if (res.success) {
              that.$message.success(res.message);
              that.$emit('ok');
            } else {
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