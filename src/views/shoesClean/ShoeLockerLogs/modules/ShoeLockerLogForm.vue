<template>
  <a-spin :spinning="confirmLoading">
    <j-form-container :disabled="formDisabled">
      <a-form-model ref="form" :model="model" :rules="validatorRules" slot="detail">
        <a-row>
          <a-col :span="24">
            <a-form-model-item label="日志id" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="logId">
              <a-input-number v-model="model.logId" placeholder="请输入日志id" style="width: 100%" />
            </a-form-model-item>
          </a-col>
          <a-col :span="24">
            <a-form-model-item label="机柜编号" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="lockerCode">
              <a-input v-model="model.lockerCode" placeholder="请输入机柜编号"  ></a-input>
            </a-form-model-item>
          </a-col>
          <a-col :span="24">
            <a-form-model-item label="格子号" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="gridNumber">
              <a-input v-model="model.gridNumber" placeholder="请输入格子号"  ></a-input>
            </a-form-model-item>
          </a-col>
          <a-col :span="24">
            <a-form-model-item label="操作类型" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="operationType">
              <j-dict-select-tag type="list" v-model="model.operationType" dictCode="" placeholder="请选择操作类型" />
            </a-form-model-item>
          </a-col>
          <a-col :span="24">
            <a-form-model-item label="操作详情" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="operationComment">
              <a-input v-model="model.operationComment" placeholder="请输入操作详情"  ></a-input>
            </a-form-model-item>
          </a-col>
          <a-col :span="24">
            <a-form-model-item label="操作时间" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="createTime">
              <j-date placeholder="请选择操作时间" v-model="model.createTime"  style="width: 100%" />
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
    name: 'ShoeLockerLogForm',
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
           logId: [
              { required: true, message: '请输入日志id!'},
           ],
           lockerCode: [
              { required: true, message: '请输入机柜编号!'},
           ],
           operationComment: [
              { required: true, message: '请输入操作详情!'},
           ],
        },
        url: {
          add: "/ShoeLockerLog/shoeLockerLog/add",
          edit: "/ShoeLockerLog/shoeLockerLog/edit",
          queryById: "/ShoeLockerLog/shoeLockerLog/queryById"
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