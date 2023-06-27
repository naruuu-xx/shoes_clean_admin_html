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
    </a-modal>
</template>

<script>
  export default {
    name: 'ShoeExceptionTagModal',
    data () {
      return {
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

        }
      }
    },
    methods: {
      show (record) {
        this.model = Object.assign({
          images:[],
          factoryImages:[]
        }, record);
        this.visible=true
        console.log(8888,this.model);
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