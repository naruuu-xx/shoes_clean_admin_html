<template>
  <a-spin :spinning="confirmLoading">
    <j-form-container :disabled="formDisabled">
      <a-form-model ref="form" :model="model" :rules="validatorRules" slot="detail">
        <a-row>
          <a-col :span="24">
            <a-form-model-item label="区域" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="orgCode">
              <a-select v-model="model.orgCode" style="width: 100%">
                <a-select-option v-for="item in areaList" :value="item.orgCode.toString()" >{{ item.departName }}</a-select-option>
              </a-select>
            </a-form-model-item>
          </a-col>
          <a-col :span="24">
            <a-form-model-item label="机柜编码" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="lockerCode">
              <a-input v-model="model.lockerCode" placeholder="请输入机柜编码"  ></a-input>
            </a-form-model-item>
          </a-col>
          <a-col :span="24">
            <a-form-model-item label="状态" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="status">
              <j-dict-select-tag type="radio" v-model="model.status" dictCode="shoe_locker_status" placeholder="请选择状态" />
            </a-form-model-item>
          </a-col>
          <a-col :span="24">
            <a-form-model-item label="省市区" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="province">
<!--             <j-area-linkage type="cascader" v-model="model.province" placeholder="请输入省市区"  />-->
              <al-cascader v-model="model.province" level="3" data-type="name" />
            </a-form-model-item>
          </a-col>
<!--          <a-col :span="24">-->
<!--            <a-form-model-item label="市" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="city">-->
<!--             <j-area-linkage type="cascader" v-model="model.city" placeholder="请输入省市区"  />-->
<!--            </a-form-model-item>-->
<!--          </a-col>-->
<!--          <a-col :span="24">-->
<!--            <a-form-model-item label="区/县" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="area">-->
<!--             <j-area-linkage type="cascader" v-model="model.area" placeholder="请输入省市区"  />-->
<!--            </a-form-model-item>-->
<!--          </a-col>-->
          <a-col :span="24">
            <a-form-model-item label="详细地址" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="address">
              <a-textarea v-model="model.address" placeholder="请输入详细地址"  ></a-textarea>
            </a-form-model-item>
          </a-col>
          <a-col :span="24">
            <a-form-model-item label="经度" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="log">
              <a-input-number v-model="model.log" placeholder="请输入经度" style="width: 100%" />
            </a-form-model-item>
          </a-col>
          <a-col :span="24">
            <a-form-model-item label="纬度" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="lat">
              <a-input-number v-model="model.lat" placeholder="请输入纬度" style="width: 100%" />
            </a-form-model-item>
          </a-col>
          <a-col :span="24">
            <a-form-model-item label="格子数" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="num">
              <a-input-number v-model="model.num" placeholder="请输入格子数" style="width: 100%" />
            </a-form-model-item>
          </a-col>
<!--          <a-col :span="24">-->
<!--            <a-form-model-item label="空闲格子数" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="free">-->
<!--              <a-input-number v-model="model.free" placeholder="请输入空闲格子数" style="width: 100%" />-->
<!--            </a-form-model-item>-->
<!--          </a-col>-->
        </a-row>
      </a-form-model>
    </j-form-container>
  </a-spin>
</template>

<script>

  import { httpAction, getAction } from '@/api/manage'
  import { validateDuplicateValue } from '@/utils/util'
  import AlCascader from '@views/shoesClean/ShoeLocker/modules/al-cascader'

  export default {
    name: 'ShoeLockerForm',
    components: {
      AlCascader
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
           lockerId: [
              { required: true, message: '请输入ID!'},
           ],
           lockerCode: [
              { required: true, message: '请输入机柜编码!'},
           ],
           orgCode: [
              { required: true, message: '请选择区域!'},
           ],
           status: [
              { required: true, message: '请选择状态'},
           ],
           log: [
              { required: true, message: '请输入经度!'},
              { pattern: /^-?\d+\.?\d*$/, message: '请输入数字!'},
           ],
           lat: [
              { required: true, message: '请输入纬度!'},
              { pattern: /^-?\d+\.?\d*$/, message: '请输入数字!'},
           ],
           address: [
              { required: true, message: '请输入详细地址!'},
           ],
           province: [
              { required: true, message: '请输入省!'},
           ],
           city: [
              { required: true, message: '请输入市!'},
           ],
           area: [
              { required: true, message: '请输入区/县!'},
           ],
           num: [
              { required: true, message: '请输入格子数!'},
              { pattern: /^-?\d+$/, message: '请输入整数!'},
           ],
           free: [
              { required: true, message: '请输入空闲格子数!'},
              { pattern: /^-?\d+$/, message: '请输入整数!'},
           ],
        },
        url: {
          add: "/shoes/shoeLocker/add",
          edit: "/shoes/shoeLocker/edit",
          queryById: "/shoes/shoeLocker/queryById"
        },
        areaList: [],
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
      this.getAreaList();
    },
    methods: {
      add () {
        this.edit(this.modelDefault);
      },
      edit (record) {
        this.model = Object.assign({}, record);
        let province = record.province;
        let city = record.city;
        let area = record.area;
        this.model.province = [province, city, area];
        this.model.orgCode = record.orgCode.toString();
        this.model.departName = record.departName;
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
            if(!this.model.lockerId){
              httpurl+=this.url.add;
              method = 'post';
            }else{
              httpurl+=this.url.edit;
               method = 'put';
            }

            //处理省市区
            let province = this.model.province[0];
            let city = this.model.province[1];
            let area = this.model.province[2];

            let lockerCode = "";

            if (!this.model.lockerId) {
              lockerCode = this.model.orgCode + this.model.lockerCode;
            } else {
              lockerCode = this.model.lockerCode;
              for (let i = 0 ; i < this.areaList.length ; i ++) {
                let element = this.areaList[i].orgCode;
                lockerCode = lockerCode.replace(element, "");
              }
              lockerCode = this.model.orgCode + lockerCode;
            }

            let data = {
              "lockerId": this.model.lockerId,
              "orgCode": this.model.orgCode,
              "lockerCode": lockerCode,
              "status": this.model.status,
              "province": province,
              "city": city,
              "area": area,
              "address": this.model.address,
              "log": this.model.log,
              "lat": this.model.lat,
              "num": this.model.num
            }

            // console.log(data);
            httpAction(httpurl,data,method).then((res)=>{
              if(res.success){
                that.$message.success(res.message);
                that.$emit('ok');
              }else{
                that.$message.warning(res.message);
              }
            }).finally(() => {
              that.confirmLoading = false;
            })
            // that.confirmLoading = false;
          }

        })
      },
      getAreaList(){
        httpAction("/shoes/shoeLocker/getAreaList", null, "get").then((res) => {
          let areaList = res.result;

          this.areaList = areaList;
        })
      }
    }
  }
</script>