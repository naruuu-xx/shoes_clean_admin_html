<template>
  <a-modal
    :title="title"
    :width="800"
    :ok=false
    :visible="visible"
    :confirmLoading="confirmLoading"
    :okButtonProps="{ props: {disabled: disableSubmit} }"
    @ok="handleOk"
    @cancel="handleCancel"
    cancelText="关闭">

    <a-spin :spinning="confirmLoading">
      <a-form-model ref="form" :model="model" :rules="validatorRules">
        <a-form-model-item
          :labelCol="labelCol"
          :wrapperCol="wrapperCol"
          label="名称"
          prop="departName"
          :hidden="false"
          hasFeedback>
          <a-input id="departName" placeholder="请输入名称" v-model="model.departName"/>
        </a-form-model-item>
<!--        <a-form-model-item :labelCol="labelCol" :wrapperCol="wrapperCol" label="工厂特定编码" prop="code" :hidden="seen">-->
<!--          <a-input placeholder="请输入工厂特定编码（区分袋子所属工厂）" v-model="model.code"/>-->
<!--        </a-form-model-item>-->
        <a-form-model-item :labelCol="labelCol" :wrapperCol="wrapperCol" :hidden="seen" label="区域" hasFeedback>
          <a-tree-select
            style="width:100%"
            :dropdownStyle="{maxHeight:'200px',overflow:'auto'}"
            :treeData="departTree"
            v-model="model.parentId"
            placeholder="请选择区域"
            :disabled="condition">
          </a-tree-select>
        </a-form-model-item>
        <a-form-model-item :labelCol="labelCol" :wrapperCol="wrapperCol"  label="类型" prop="orgCategory">
          <a-radio-group v-model="model.orgCategory">
            <a-radio :value="'1'">运营城市</a-radio>
            <a-radio :value="'2'">工厂</a-radio>
            <a-radio :value="'3'">运营城市和工厂</a-radio>
          </a-radio-group>
        </a-form-model-item>

        <a-form-model-item
          :labelCol="labelCol"
          :wrapperCol="wrapperCol"
          prop="mobile"
          label="电话">
          <a-input placeholder="请输入电话" v-model="model.mobile"/>
        </a-form-model-item>
        <!--        <a-form-model-item-->
        <!--          :labelCol="labelCol"-->
        <!--          :wrapperCol="wrapperCol"-->
        <!--          label="传真">-->
        <!--          <a-input placeholder="请输入传真" v-model="model.fax"/>-->
        <!--        </a-form-model-item>-->
        <a-form-model-item
          :labelCol="labelCol"
          :wrapperCol="wrapperCol"
          label="地址"
          :hidden="seen">
          <a-input placeholder="请输入地址" v-model="model.address"/>
        </a-form-model-item>
        <!--        <a-form-model-item-->
        <!--          :labelCol="labelCol"-->
        <!--          :wrapperCol="wrapperCol"-->
        <!--          label="排序">-->
        <!--          <a-input-number v-model="model.departOrder"/>-->
        <!--        </a-form-model-item>-->
        <a-form-model-item
          :labelCol="labelCol"
          :wrapperCol="wrapperCol"
          label="备注">
          <a-textarea placeholder="请输入备注" v-model="model.memo"/>
        </a-form-model-item>

      </a-form-model>
    </a-spin>
  </a-modal>
</template>

<script>
import {httpAction} from '@/api/manage'
import {queryIdTree} from '@/api/api'
import pick from 'lodash.pick'
import ATextarea from 'ant-design-vue/es/input/TextArea'

export default {
  name: "SysDepartModal",
  components: {ATextarea},
  data() {
    return {
      departTree: [],
      orgTypeData: [],
      phoneWarning: '',
      departName: "",
      title: "操作",
      seen: false,
      visible: false,
      condition: true,
      disableSubmit: false,
      model: {},
      defaultModel: {
        departOrder: 0,
        orgCategory: ''
      },
      menuhidden: false,
      menuusing: true,
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
        departName: [{required: true, message: '请输入机构/部门名称!'}],
        code: [{required: false, message: '请输入自定义编码!'},
          {pattern: /^[A-Za-z]{2}$/, message: '请输入两位且只能为英文的自定义编码!'}],
        orgCode: [{required: true, message: '请输入机构编码!'}],
        mobile: [{validator: this.validateMobile}],
        orgCategory: [{required: true, message: '请选择区域类型'}]
      },
      url: {
        add: "/sys/sysDepart/add",
      },
      dictDisabled: true,
    }
  },
  created() {
  },
  methods: {
    loadTreeData() {
      var that = this;
      queryIdTree().then((res) => {
        if (res.success) {
          that.departTree = [];
          for (let i = 0; i < res.result.length; i++) {
            let temp = res.result[i];
            that.departTree.push(temp);
          }
        }

      })
    },
    add(depart) {
      if (depart) {
        this.seen = false;
        this.dictDisabled = false;
      } else {
        this.seen = true;
        this.dictDisabled = true;
      }
      this.edit(depart);
      // 判断一级部门时，隐藏工厂特定编码和地址
      this.validatorRules.code[0].required = depart != null;
    },
    edit(record) {
      this.visible = true;
      this.model = Object.assign({}, this.defaultModel, record)
      this.loadTreeData();
      this.model.parentId = record != null ? record.toString() : null;
      if (this.seen) {
        this.model.orgCategory = '1';
      } else {
        this.model.orgCategory = '2';
      }
      // 判断一级部门时，隐藏工厂特定编码和地址
      this.validatorRules.code[0].required = record != null;
    },
    close() {
      this.$emit('close');
      this.disableSubmit = false;
      this.visible = false;
      this.$refs.form.resetFields();
    },
    handleOk() {
      const that = this;
      // 触发表单验证
      this.$refs.form.validate(valid => {
        if (valid) {
          that.confirmLoading = true;
          httpAction(this.url.add, this.model, "post").then((res) => {
            if (res.success) {
              that.$message.success(res.message);
              that.loadTreeData();
              that.$emit('ok');
            } else {
              that.$message.warning(res.message);
            }
          }).finally(() => {
            that.confirmLoading = false;
            that.close();
          })

        } else {
          return false;
        }
      })
    },
    handleCancel() {
      this.close()
    },
    validateMobile(rule, value, callback) {
      if (!value || new RegExp(/^1([38][0-9]|4[579]|5[0-3,5-9]|6[6]|7[0135678]|9[89])\d{8}$/).test(value)) {
        callback();
      } else {
        callback("您的手机号码格式不正确!");
      }

    }
  }
}
</script>

<style scoped>

</style>