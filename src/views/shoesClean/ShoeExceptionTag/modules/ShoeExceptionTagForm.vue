<template>
  <a-spin :spinning="confirmLoading">
    <j-form-container :disabled="formDisabled">
      <a-form-model ref="form" :model="model" :rules="validatorRules" slot="detail">
        <a-row>
          <a-col :span="24">
            <a-form-model-item label="订单编号" :labelCol="labelCol" :wrapperCol="wrapperCol">
              <h3>{{this.model.no}}</h3>
            </a-form-model-item>
          </a-col>
          <a-col :span="24">
            <a-form-model-item label="商品名称" :labelCol="labelCol" :wrapperCol="wrapperCol">
              <h3>{{this.model.title}}</h3>
            </a-form-model-item>
          </a-col>
          <a-col :span="24">
            <a-form-model-item label="商品规格" :labelCol="labelCol" :wrapperCol="wrapperCol">
              <h3>{{this.model.skuTitle}}</h3>
            </a-form-model-item>
          </a-col>

          <a-col :span="24">
            <a-form-model-item label="订单图片" :labelCol="labelCol" :wrapperCol="wrapperCol">
              <div class="imgs">
                <div class="imgs-box" v-for="(img,idx) in model.images" :key="idx">
                  <img class="imgs-box-img" :src="img" alt="" />
                  <div class="show" @click="piveImage(img)">
                    <a-icon type="eye" style="color:#fff;font-size: 20px;" />
                  </div>
                </div>
              </div>
            </a-form-model-item>
          </a-col>
          <a-col :span="24">
            <a-form-model-item prop="factoryImages" label="入库图片" :labelCol="labelCol" :wrapperCol="wrapperCol" help="请选择至少一张图片作为异常图片">
              <div class="imgs">
                <div class="imgs-box" v-for="(img,idx) in factoryImages" :key="idx">
                  <img class="imgs-box-img" :src="img.url" alt="" />
                  <div class="imgs-box-select" :class="{selected: img.select}" @click="onSelect(idx)"></div>
                  <div class="show" @click="piveImage(img.url)">
                    <a-icon type="eye" style="color:#fff;font-size: 20px;" />
                  </div>
                </div>
              </div>
            </a-form-model-item>
          </a-col>


          <a-col :span="24">
            <a-form-model-item label="处理方式" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="dealType">
              <a-radio-group v-model="model.dealType">
                <a-radio value="1">转异常</a-radio>
                <a-radio value="2">继续洗</a-radio>
              </a-radio-group>
            </a-form-model-item>
          </a-col>
          <a-col :span="24">

            <a-form-model-item :label="this.model.dealType==2?'备注':'异常描述'" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="note">
              <a-input placeholder="请输入订单备注" v-model="model.note"  />
            </a-form-model-item>
          </a-col>
        </a-row>
      </a-form-model>
    </j-form-container>
    <a-modal :visible="ImgVisible" :footer="null" @cancel="ImgVisible = false" width="600px">
      <img alt="example" style="width: 100%" :src="previewImage"/>
  </a-modal>
  </a-spin>
</template>

<script>

  import { httpAction, getAction } from '@/api/manage'
  import { validateDuplicateValue } from '@/utils/util'

  export default {
    name: 'ShoeExceptionTagForm',
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
        date:{},
        model:{
          factoryImages:[]
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

           dealType: [
              { required: true, message: '请选择处理方式!'},
           ],
           factoryImages: [
              { required: true, message: '请选择至少一张图片作为异常图片!'},
           ],
           note: [
              { required: true, message: '请输入!'},
           ],
        },
        url: {
          add: "/shoeExceptionTag/add",
          edit: "/shoeExceptionTag/edit",
          queryById: "/shoeExceptionTag/shoeExceptionTag/queryById"
        },
        factoryImages:[],
        previewImage:'',
        ImgVisible:false
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
    watch:{
      factoryImages: {
        handler(val,oldValue) {
          this.model.factoryImages = val.filter(item => item.select).map(item => item.url)
        },
        deep:true
      },
    },
    methods: {
      onSelect(idx) {
        this.factoryImages[idx].select = !this.factoryImages[idx].select
      },
      piveImage(url) {
        this.previewImage = url
        this.ImgVisible = true
      },
      add () {
        this.edit(this.modelDefault);
      },
      edit (record) {
        this.model = Object.assign({
          images:[],
          factoryImages:[]
        }, record);
        this.model.dealType="1"
        this.getImages(record);
        this.visible = true;
      },
      getImages(record){
        httpAction("/shoeExceptionTag/getImages?no="+record.no,null,"get").then((res)=>{
          if (res.success){
            this.model.images=res.result.orderList
            this.factoryImages=res.result.factoryList.map(url => ({
              url,
              select:false
            }))
            console.log("111",this.model)

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
            if(!this.model.exceptionTagId){
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

<style lang="less" scoped>
.imgs {
  display: flex;
  flex-wrap: wrap;
  &-box {
    margin-right: 8px;
    position: relative;
    .selected {
      background: #1890ff;
    }
    &:hover {
      .show {
        display: flex;
        
      }
      cursor: pointer;
      
    }
    &-img {
      width: 104px;
      height: 104px;
     
    }
    &-select {
      width: 20px;
      height: 20px;
      position: absolute;
      right: 0;
      top: 0;
      border: 1px solid #f5f5f5;
      z-index: 10;
      &::after {
          content: '';
          position: absolute;
          left: -16px;
          right: 0;
          top: 0;
          bottom: -16px;
      }
    }
  }
  .show {
    width: 100%;
    height: 100%;
    position: absolute;
    z-index: 5;
    background: rgba(0, 0, 0, 0.2);
    display: flex;
    justify-content:center;
    align-items: center;
    display: none;
    top: 0;
  }
}
</style>