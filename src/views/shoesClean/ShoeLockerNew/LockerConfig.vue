<template>
  <a-card class="card" :bordered="false">
    <div>
      <a-form :model="model" :label-col="labelCol" :wrapper-col="wrapperCol" :rules="rules">

        <div style="margin-bottom: 20px">
          <p style="margin-left: 56px;font-size: 20px;"><b>文字设置</b></p>
          <a-row>
            <a-col :span="24">
              <a-form-item label="1.客服电话：" prop="phone">
                <a-input v-model:value="model.phoneNew" style="width: 200px"/>
              </a-form-item>
            </a-col>
          </a-row>
        </div>

        <div style="margin-bottom: 20px">
          <p style="margin-left: 56px;font-size: 20px;"><b>链接设置</b></p>
          <a-row>
            <a-col :span="24">
              <a-form-item label="1.首页二维码：" prop="homePageQR">
                <j-image-upload v-model="model.homePageQR"></j-image-upload>
              </a-form-item>
            </a-col>
          </a-row>
<!--          <a-row>-->
<!--            <a-col :span="24">-->
<!--              <a-form-item label="2.存鞋二维码链接：" prop="homePageQR">-->
<!--                <a-input type="textarea" v-model:value="model.saveQrCodeNew"/>-->
<!--              </a-form-item>-->
<!--            </a-col>-->
<!--          </a-row>-->
<!--          <a-row>-->
<!--            <a-col :span="24">-->
<!--              <a-form-item label="3.取鞋二维码链接：" prop="homePageQR">-->
<!--                <a-input type="textarea" v-model:value="model.pickQrCodeNew"/>-->
<!--              </a-form-item>-->
<!--            </a-col>-->
<!--          </a-row>-->
        </div>

      </a-form>
      <!-- 底部提交按钮 -->
      <footer-tool-bar>
        <a-button type="primary" @click="submitForm" :loading="loading">提交</a-button>
      </footer-tool-bar>

      <a-modal v-model:visible="exampleImgShoe" title="首页示例图" :footer="null" width="800px">
        <div>
          <img alt="locker_screen_example" style="width: 700px; height: 700px" src="../../../assets/locker_screen_example.png">
        </div>
      </a-modal>
      <a-modal v-model:visible="exampleImgAppQrCode" title="小程序相关示例图" :footer="null" width="900px">
        <div>
          <img alt="locker_screen_example" style="width: 400px; height: 600px;margin-right: 50px" src="../../../assets/appQrCode01.png">
          <img alt="locker_screen_example" style="width: 400px; height: 600px" src="../../../assets/appQrCode02.png">
        </div>
      </a-modal>
    </div>
  </a-card>
</template>

<script>

import JImageUploadByBanner from "./components/JImageUploadByBanner";
import JImageUploadByOne from "./components/JImageUploadByOne";
import FooterToolBar from '@/components/tools/FooterToolBar';
import {httpAction} from "../../../api/manage";

export default {
  name: "LockerConfig",
  components: {
    FooterToolBar,
    JImageUploadByBanner,
    JImageUploadByOne
  },
  data() {
    return {
      uploadAction:window._CONFIG['domianURL']+"/sys/common/upload",
      loading: false,
      model: {},
      labelCol: {
        xs: {span: 24},
        sm: {span: 3},
      },
      wrapperCol: {
        xs: {span: 24},
        sm: {span: 12},
      },
      rules: {
        phone: [
          {required: false, message: '请输入正确电话号码!'},
        ],
      },
      headers:{},
      fileList: [],
      exampleImgShoe: false,
      exampleImgAppQrCode: false,
      previewImage: "",
      previewVisible: false,
      picUrl:false,
    }
  },
  computed: {},
  created() {
    httpAction("/ShoeConfig/shoeConfig/showShoeLockerConfigNew", "", "get").then((res)=> {
      let resultList = res.result;

      let phoneNew = resultList.phoneNew;
      let homePageQR = resultList.homePageQR;
      let saveQrCodeNew = resultList.saveQrCodeNew;
      let pickQrCodeNew = resultList.pickQrCodeNew;

      this.model = {
        "phoneNew": phoneNew,
        "homePageQR": homePageQR,
        "saveQrCodeNew": saveQrCodeNew,
        "pickQrCodeNew": pickQrCodeNew
      }
    })
  },
  mounted() {
  },
  methods: {
    submitForm() {
      const that = this;

      let data = {
        "phoneNew": this.model.phoneNew,
        "homePageQR": this.model.homePageQR,
        "saveQrCodeNew": this.model.saveQrCodeNew,
        "pickQrCodeNew": this.model.pickQrCodeNew
      };

      httpAction("/ShoeConfig/shoeConfig/saveShoeLockerConfigNew", data, "post").then((res) => {
        if (res.success) {
          that.$message.success(res.message);
        } else {
          that.$message.warning(res.message);
        }
      })
    },
    exampleImg() {
      this.exampleImgShoe = true;
    },
    showExampleImgAppQrCode() {
      this.exampleImgAppQrCode = true;
    },
  }
}
</script>

<style lang="less" scoped>
.card {
  margin-bottom: 24px;
}
</style>