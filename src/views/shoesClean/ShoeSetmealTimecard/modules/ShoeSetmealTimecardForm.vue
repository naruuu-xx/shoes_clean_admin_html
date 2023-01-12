<template>
  <a-spin :spinning="confirmLoading">
    <j-form-container :disabled="formDisabled">
      <a-form-model ref="form" :model="model" :rules="validatorRules" slot="detail">
        <a-row>
          <a-col :span="24">
            <a-form-model-item label="平台" :labelCol="labelCol" :wrapperCol="wrapperCol" :prop="model.id ? '' : 'platform'">
              <div v-if="model.id ">222</div>
              <a-select style="width: 120px" v-model="model.platform" v-else>
                <a-select-option :value="item.id" v-for="(item,index) in platformList" :key="index">
                  {{item.name}}
                </a-select-option>
              </a-select>
            </a-form-model-item>
          </a-col>
          <a-col :span="24">
            <a-form-model-item label="套餐名称" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="setmeal">
              <a-input v-model="model.setmeal" placeholder="请输入套餐名称" ></a-input>
            </a-form-model-item>
          </a-col>
          <a-col :span="24">
            <a-form-model-item label="鞋峰卡" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="timecardId">
              <a-select style="width: 120px" v-model="model.timecardId">
                  <a-select-option :value="item.id" v-for="(item,index) in timecardList" :key="index">
                    {{item.name}}
                  </a-select-option>
                </a-select>
            </a-form-model-item>
          </a-col>
          <template v-if="model.id">
            <a-col :span="24">
            <a-form-model-item label="添加人" :labelCol="labelCol" :wrapperCol="wrapperCol">
              22
            </a-form-model-item>
          </a-col>
          <a-col :span="24">
            <a-form-model-item label="最后操作人" :labelCol="labelCol" :wrapperCol="wrapperCol">
              11
            </a-form-model-item>
          </a-col>
          </template>
          
        </a-row>
      </a-form-model>
    </j-form-container>
  </a-spin>
</template>

<script>

  import { httpAction, getAction } from '@/api/manage'
  import { validateDuplicateValue } from '@/utils/util'

  export default {
    name: 'ShoeSetmealTimecardForm',
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
           platform: [
              { required: true, message: '请输入平台：1=福州小洁!'},
           ],
           setmeal: [
              { required: true, message: '请输入套餐内容!'},
           ],
           timecardId: [
              { required: true, message: '请输入次卡id!'},
           ],
           addUserId: [
              { required: true, message: '请输入添加人ID!'},
           ],
           editUserId: [
              { required: true, message: '请输入最后修改人ID（首次添加为添加人id）!'},
           ],
        },
        url: {
          add: "/shoeSetmealTimecard/shoeSetmealTimecard/add",
          edit: "/shoeSetmealTimecard/shoeSetmealTimecard/edit",
          queryById: "/shoeSetmealTimecard/shoeSetmealTimecard/queryById"
        },
        platformList:[
          {
            name:'j姐小兔',
            id:1
          },{
            name:'霸道总裁',
            id: 2
          }
        ],
        timecardList:[
          {
            name:'388',
            id:2
          },{
            name: '699',
            id:3
          }
        ]
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
        // this.model.id = 1
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