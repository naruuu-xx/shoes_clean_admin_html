<template>
  <a-spin :spinning="confirmLoading">
    <j-form-container :disabled="formDisabled">
      <a-form-model ref="form" :model="model" :rules="validatorRules" slot="detail">
        <a-row>
          <!--          <a-col :span="24">-->
          <!--            <a-form-model-item label=" 配送员ID" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="courierId">-->
          <!--              <a-input-number v-model="model.courierId" placeholder="请输入 配送员ID" style="width: 100%" />-->
          <!--            </a-form-model-item>-->
          <!--          </a-col>-->
          <a-col :span="24">
            <a-form-model-item label=" 星期几" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="week">
              <j-multi-select-tag type="checkbox" v-model="model.week" dictCode="shoe_schedule_week"
                                  placeholder="请选择 星期几" v-if="'新增' === title"/>
              <j-dict-select-tag type="radio" v-model="model.week" dictCode="shoe_schedule_week"
                                 placeholder="请选择 星期几" v-else-if="'编辑' === title"/>
            </a-form-model-item>
          </a-col>
          <a-col :span="24">
            <a-form-model-item label=" 开始时间" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="startTime">
              <j-time placeholder="请选择 开始时间" v-model="model.startTime" style="width: 100%"/>
            </a-form-model-item>
          </a-col>
          <a-col :span="24">
            <a-form-model-item label=" 结束时间" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="endTime">
              <j-time placeholder="请选择 结束时间" v-model="model.endTime" style="width: 100%"/>
            </a-form-model-item>
          </a-col>
<!--          <a-col :span="24">-->
<!--            <a-form-model-item label=" 状态" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="status">-->
<!--              <j-dict-select-tag type="radio" v-model="model.status" dictCode="shoe_schedule_status"-->
<!--                                 placeholder="请选择 状态:0=关闭,1=开启"/>-->
<!--            </a-form-model-item>-->
<!--          </a-col>-->
        </a-row>
      </a-form-model>
    </j-form-container>
  </a-spin>
</template>

<script>

import {httpAction, getAction} from '@/api/manage'
import {validateDuplicateValue} from '@/utils/util'

export default {
  name: 'ShoeScheduleForm',
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
        scheduleId: [
          {required: true, message: '请输入 ID!'},
        ],
        courierId: [
          {required: true, message: '请输入 配送员ID!'},
        ],
        week: [
          {required: true, message: '请输入 星期几!'},
        ],
        startTime: [
          {required: true, message: '请输入 开始时间!'},
        ],
        endTime: [
          {required: true, message: '请输入 结束时间!'},
        ],
        status: [
          {required: false, message: '请输入 状态:0=关闭,1=开启!'},
        ],
      },
      url: {
        add: "/shoeSchedule/shoeSchedule/add",
        edit: "/shoeSchedule/shoeSchedule/edit",
        queryById: "/shoeSchedule/shoeSchedule/queryById"
      },
      scheduleList: [],
      title: "",
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
  },
  methods: {
    add(courierId, scheduleList, title) {
      this.edit(this.modelDefault);
      this.model.courierId = courierId;
      this.scheduleList = scheduleList;
      this.title = title;
    },
    edit(record, scheduleList, title) {
      this.model = Object.assign({}, record);
      this.visible = true;
      this.scheduleList = scheduleList;
      this.title = title;
    },
    submitForm() {
      const that = this;
      // 触发表单验证
      this.$refs.form.validate(valid => {
        if (valid) {
          let startTime = parseInt((this.model.startTime).replace(":", ""));
          let endTime = parseInt((this.model).endTime.replace(":", ""));

          if (startTime >= endTime) {
            that.$message.warning("开始时间不能大于等于结束时间");
          } else {
            that.confirmLoading = true;
            let httpurl = '';
            let method = '';
            if (!this.model.scheduleId) {
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

        }

      })
    },
  }
}
</script>