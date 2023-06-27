<template>
  <a-modal :visible="visible" :footer="null" @cancel="handleCancel" width="600px">
      <a-form-model ref="form" :model="model">
        <a-row>
          <a-col :span="24">
            <a-form-model-item label="订单编号" :labelCol="labelCol" :wrapperCol="wrapperCol">
              <h3>{{model.no}}</h3>
            </a-form-model-item>
          </a-col>
          <a-col :span="24">
            <a-form-model-item label="商品名称" :labelCol="labelCol" :wrapperCol="wrapperCol">
              <h3>{{model.title}}</h3>
            </a-form-model-item>
          </a-col>
          <a-col :span="24">
            <a-form-model-item label="商品规格" :labelCol="labelCol" :wrapperCol="wrapperCol">
              <h3>{{model.skuTitle}}</h3>
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
            <a-form-model-item label="入库图片" :labelCol="labelCol" :wrapperCol="wrapperCol">
              <div class="imgs">
                <div class="imgs-box" v-for="(img,idx) in model.factoryImages" :key="idx">
                  <img class="imgs-box-img" :src="img" alt="" />
                  <div class="show" @click="piveImage(img)">
                    <a-icon type="eye" style="color:#fff;font-size: 20px;" />
                  </div>
                </div>
              </div>
            </a-form-model-item>
          </a-col>


          <a-col :span="24">
            <a-form-model-item label="处理方式" :labelCol="labelCol" :wrapperCol="wrapperCol">
              {{ model.dealType }}
            </a-form-model-item>
          </a-col>
          <a-col :span="24">
            <a-form-model-item :label="this.model.dealType==2?'备注':'异常描述'" :labelCol="labelCol" :wrapperCol="wrapperCol">
              {{ model.note }}
            </a-form-model-item>
          </a-col>
        </a-row>
      </a-form-model>
    <a-modal :visible="ImgVisible" :footer="null" @cancel="ImgVisible = false" width="600px">
      <img alt="example" style="width: 100%" :src="previewImage"/>
    </a-modal>
    </a-modal>

</template>

<script>
  import {httpAction} from "@api/manage";

  export default {
    name: 'ShoeExceptionTagModal',
    data () {
      return {
        factoryImages:[],
        previewImage:'',
        ImgVisible:false,
        title:'',
        width:800,
        visible: false,
        disableSubmit: false,
        labelCol: {
          xs: { span: 24 },
          sm: { span: 5 },
        },
        wrapperCol: {
          xs: { span: 24 },
          sm: { span: 16 },
        },
        model: {
          factoryImages:[],
        }
      }
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
      show (record) {
        this.model = Object.assign({
          images:[],
          factoryImages:[]
        }, record);
        this.getImages(record);
        this.visible=true
      },
      getImages(record){
        httpAction("/shoeExceptionTag/getImages?no="+record.no,null,"get").then((res)=>{
          if (res.success){
            this.model.images=res.result.orderList
            this.model.factoryImages=res.result.factoryList

          }
        })
      },
      close () {
        this.$emit('close');
        this.visible = false;
      },
      handleCancel () {
        this.close()
      }
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