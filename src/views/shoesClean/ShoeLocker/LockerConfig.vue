<template>
  <a-card class="card" :bordered="false">
    <div>
      <a-form :model="model" :label-col="labelCol" :wrapper-col="wrapperCol">
        <p style="margin-left: 56px;font-size: 20px;"><b>文字设置</b></p>
        <a-row>
          <a-col :span="24">
            <a-form-item label="1.客服电话：">
              <a-input v-model:value="model.phone" style="width: 200px"/>
            </a-form-item>
          </a-col>
        </a-row>
        <a-row>
          <a-col :span="24">
            <a-form-item label="2.用户协议：">
              <a-textarea v-model:value="model.userAgreement" style="width: 100%"/>
            </a-form-item>
          </a-col>
        </a-row>
        <div style="margin-bottom: 20px">
          <span style="margin-left: 56px;margin-right: 20px;font-size: 20px;"><b>首页图片设置</b></span><span style="color: #ff3535" @click="exampleImg">点击查看位置示例图</span>
        </div>
        <a-row>
          <a-col :span="24">
            <div>1.顶部轮播图（最多五张；尺寸：满足比例16：9即可）</div>
<!--            <j-image-upload isMultiple  v-model="model.image" ></j-image-upload>-->
          </a-col>
        </a-row>
        <a-row>
          <a-col :span="24">
          </a-col>
        </a-row>
        <a-row>
          <a-col :span="24">
          </a-col>
        </a-row>


      </a-form>
      <!-- 底部提交按钮 -->
      <footer-tool-bar>
        <a-button type="primary" @click="submitForm" :loading="loading">提交</a-button>
      </footer-tool-bar>


      <a-modal v-model:visible="exampleImgShoe" title="位置示例图" :footer="null" width="800px">
        <div>
          <img alt="locker_screen_example" style="width: 700px; height: 700px" src="../../../assets/locker_screen_example.png">
        </div>
      </a-modal>
    </div>
  </a-card>
</template>

<script>
export default {
  name: "LockerConfig",
  data() {
    return {
      loading: false,
      model: {},
      labelCol: {
        xs: {span: 24},
        sm: {span: 2},
      },
      wrapperCol: {
        xs: {span: 24},
        sm: {span: 10},
      },
      exampleImgShoe: false,
    }
  },
  computed: {},
  created() {

  },
  mounted() {
  },
  methods: {
    submitForm() {
      const that = this;
      console.log(this.model);
    },
    exampleImg() {
      this.exampleImgShoe = true;
    }
  }
}
</script>

<style lang="less" scoped>
.card {
  margin-bottom: 24px;
}
</style>