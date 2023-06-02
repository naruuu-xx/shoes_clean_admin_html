<template>
  <j-modal
    :title="title"
    :width="1200"
    :visible="visible"
    switchFullscreen
    @cancel="handleCancel"
    cancelText="关闭"
    :footer="null"
    wrapClassName="full-modal">
    <a-spin :spinning="confirmLoading" size="large" tip="图片正在上传中，请耐心等待......">
    <div style="margin-left: 20px">
      <a-row>
        <a-col :span="18">
          <a-input style="height: 120px" v-model.trim="no" placeholder="请扫码水洗唛编码或者手动输入水洗唛编码" @pressEnter="uploadImage"  ref="autoInput"/>
        </a-col>
        <a-col :span="2"></a-col>
        <a-col :span="4">
          <a-row><a-button :loading="loadingBtn" type="primary" @click="uploadImage" style="width: 100%;height: 50px;margin-bottom: 20px;"><span style="font-size: 22px;">上传照片</span></a-button></a-row>
          <a-row><a-button @click="emptyBagCode" style="width: 100%;height: 50px;background: rgba(255,255,102,0.56)"><span style="font-size: 22px;">清&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;空</span></a-button></a-row>
        </a-col>
      </a-row>
      <a-divider />
      <a-row style="margin-bottom: 10px" v-if="no">
        <XfPhotograph ref="photograph" :photographImg="factoryOutImages"></XfPhotograph>
      </a-row>
    </div>
    </a-spin>
  </j-modal>
</template>

<script>

import { httpAction} from "../../../../../api/manage";
import XfPhotograph from "@comp/Xf/XfPhotograph";
export default {
  name: "CreateWashedMarkByOutModal",
  components: {
    XfPhotograph
  },
  data() {
    return {
      visible: false,
      title: '打印出库水洗唛',
      no: "",
      data: {},
      confirmLoading: false,
      factoryOutImages: [],
      loadingBtn:false
    }
  },
  created() {
  },
  methods: {
    show(record) {
      this.visible = true;
      this.$nextTick(()=> {
        this.$refs.autoInput.focus();
      })
    },
    handleCancel() {
      this.visible = false;
      this.no = "";
      //关闭弹窗并刷新列表
      this.$emit('ok');
    },
    emptyBagCode(){
      //清空输入框内容
      this.no = "";
      this.factoryOutImages = [];
    },
    uploadImage(){
      // if(!this.$refs.photograph.images.length) {
      //   return this.$message.warning('请拍摄出库照片!')
      // }
      this.confirmLoading = true;
      this.loadingBtn = true
      this.$refs.photograph.submit().then(Images => {
        this.factoryOutImages = Images
        let factoryOutImages = Images.map(item => item.file)
        let form = {
          no: this.no,
          factoryOutImages
        }
        httpAction("/ShoeFactoryOrder/shoeFactoryOrder/photo", form, "post").then((res) => {
          if (res.success) {
            this.$message.success(res.message)
            this.emptyBagCode()
          } else {
            this.$message.warning(res.message)
          }

          this.confirmLoading = false;
          this.loadingBtn = false
        })
      }).finally(res => {
        this.loadingBtn = false
        this.confirmLoading = false
      })
      
    },
  }
}
</script>

<style scoped lang="less">
/deep/ .ant-spin-text{
  font-size: 40px;
}
.content {
  font-size: 20px;
  color: #000000;
}
</style>