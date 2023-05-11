<template>
  <a-spin :spinning="confirmLoading">
    <j-form-container :disabled="formDisabled">
      <a-form-model ref="form" :model="model" :rules="validatorRules" slot="detail">
        <a-row>
          <a-col :span="24">
            <a-form-model-item label="分组名称" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="name">
              <a-input v-model="model.name" placeholder="请输入分组名称"  ></a-input>
            </a-form-model-item>
          </a-col>
          <a-col :span="24">
            <a-form-model-item label="包含机柜" :labelCol="labelCol" :wrapperCol="wrapperCol" >
              <xf-select
                style="width: 100%"
                :list="weekList"
                @changeList="changeSelect"
                @change="checkedSelect"
                mode="multiple"
                v-model="model.lockerId"
                :url='`/shoes/shoeLocker/getLockerList`'
              >
              </xf-select>
            </a-form-model-item>
          </a-col>
          <a-col :span="24">
            <a-form-model-item label="包含站点" :labelCol="labelCol" :wrapperCol="wrapperCol">
              <xf-select
                style="width: 100%"
                :list="siteList"
                @changeList="changeSelect2"
                @change="checkedSelect2"
                mode="multiple"
                v-model="model.siteId"
                :url='`/shoes/shoeLocker/getSiteList`'
              >
              </xf-select>
            </a-form-model-item>
          </a-col>
          <a-col :span="24">
            <a-form-model-item label="权重" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="weight">
              <a-input-number v-model="model.weight" placeholder="请输入权重" style="width: 100%" />
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
  import XfSelect from "@comp/Xf/XfSelect";

  export default {
    name: 'ShoeLockerGroupForm',
    components: {
      XfSelect
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
        model:{lockerId:[],siteId:[]},
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
           lockerGroupId: [
              { required: true, message: '请输入机柜分组ID!'},
           ],
           name: [
              { required: true, message: '请输入分组名称!'},
           ],
           weight: [
              { required: true, message: '请输入权重!'},
           ],
        },
        url: {
          add: "/shoeLockerGroup/add",
          edit: "/shoeLockerGroup/edit",
          queryById: "/shoeLockerGroup/queryById"
        },
        weekList:[],
        siteList:[],
        first:true,
        first2:true,
        selectList:[],
        selectList2:[]
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
      changeSelect(data) {
        this.weekList = data.map(item => ({
          label: item.name,
          value: +item.lockerId
        }));
        if (this.first&&this.selectList.length){
          this.weekList=[...this.weekList,...this.selectList]
          this.first=false;
        }
      },
      changeSelect2(data) {
        this.siteList = data.map(item => ({
          label: item.name,
          value: +item.lockerId
        }));
        if (this.first2&&this.selectList2.length){
          this.siteList=[...this.siteList,...this.selectList2]
          this.first2=false;
        }
      },
      checkedSelect(val) {
      },
      checkedSelect2(val) {
      },
      add () {
        this.edit(this.modelDefault,1);
      },
      edit (record,type) {
        this.model = Object.assign({}, this.model,record);
        if (!(type==1)){
        this.show(record.lockerGroupId);
        }

      },
      show(id){
        httpAction("/shoeLockerGroup/show?id="+id,null,"get").then((res)=>{
          this.selectList2=res.siteList.map(item => ({
            label: item.name,
            value: +item.lockerId
          }))
          this.model.siteId=res.siteList.map(item => +item.lockerId)


          this.selectList=res.lockerList.map(item => ({
            label: item.name,
            value: +item.lockerId
          }))
          this.model.lockerId=res.lockerList.map(item => +item.lockerId)


          if (this.first&&this.weekList.length){
            this.weekList=[...this.weekList,...this.selectList]
            this.first=false;
          }
          if (this.first2&&this.siteList.length){
            this.siteList=[...this.siteList,...this.selectList2]
            this.first2=false;
          }

        })
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