<template>
  <a-card class="card" :bordered="false">
    <div>
      <a-form :model="model" :label-col="labelCol" :wrapper-col="wrapperCol" :rules="rules">

        <div style="margin-bottom: 20px">
          <p style="margin-left: 56px;font-size: 20px;"><b>机柜账号设置</b></p>
          <a-row>
            <a-col :span="24">
              <a-form-item label="登录账号：" prop="account">
                <a-input v-model:value="model.account" style="width: 200px"/>
              </a-form-item>
            </a-col>
          </a-row>
          <a-row>
            <a-col :span="24">
              <a-form-item label="登录密码：" prop="password">
                <a-input-password v-model:value="model.password" style="width: 200px"/>
              </a-form-item>
            </a-col>
          </a-row>
        </div>

        <div style="margin-bottom: 20px">
          <p style="margin-left: 56px;font-size: 20px;"><b>文字设置</b></p>
          <a-row>
            <a-col :span="24">
              <a-form-item label="1.客服电话：" prop="phone">
                <a-input v-model:value="model.phone" style="width: 200px"/>
              </a-form-item>
            </a-col>
          </a-row>
          <a-row>
            <a-col :span="24">
              <a-form-item label="2.用户协议：">
<!--                <a-textarea v-model:value="model.userAgreement" style="width: 100%"/>-->
                <j-editor v-model="model.userAgreement" style="width: 1300px"/>
              </a-form-item>
            </a-col>
          </a-row>
        </div>

        <div style="margin-bottom: 20px">
          <span style="margin-left: 56px;margin-right: 20px;font-size: 20px;"><b>首页图片设置</b></span><span style="color: #ff3535" @click="exampleImg">点击查看位置示例图</span>
          <a-row>
            <a-col :span="24">
              <div style="margin-left: 56px;margin-bottom: 20px">1.顶部轮播图（最多五张；尺寸：满足比例16：9即可）</div>
              <div style="margin-left: 56px">
                <a-form-item label="" prop="banner">
                  <j-image-upload-by-banner isMultiple v-model="model.banner"></j-image-upload-by-banner>
                </a-form-item>
              </div>
            </a-col>
          </a-row>
          <a-row>
            <a-col :span="6">
              <div style="margin-left: 56px;margin-bottom: 20px">2.品牌广告栏（尺寸：1054*460）</div>
              <div style="margin-left: 56px">
                <j-image-upload-by-one v-model="model.rightTopPic"></j-image-upload-by-one>
              </div>
            </a-col>
            <a-col :span="12">
              <div style="margin-left: 56px;margin-bottom: 20px">4.公众号图片</div>
              <div style="margin-left: 56px">
                <j-image-upload-by-one v-model="model.officialAccount"></j-image-upload-by-one>
              </div>
            </a-col>
          </a-row>
          <a-row>
            <a-col :span="6">
              <div style="margin-left: 56px;margin-bottom: 20px">3.我要存鞋图片（尺寸：510*500）</div>
              <div style="margin-left: 56px">
                <j-image-upload-by-one v-model="model.indexSavePic"></j-image-upload-by-one>
              </div>
            </a-col>
            <a-col :span="12">
              <div style="margin-left: 56px;margin-bottom: 20px">5.我要取鞋图片（尺寸：510*500）</div>
              <div style="margin-left: 56px">
                <j-image-upload-by-one v-model="model.indexRetrievePic"></j-image-upload-by-one>
              </div>
            </a-col>
          </a-row>
        </div>

        <div style="margin-bottom: 20px">
          <span style="margin-left: 56px;margin-right: 20px;font-size: 20px;"><b>小程序图片设置</b></span><span style="color: #ff3535" @click="showExampleImgAppQrCode">点击查看位置示例图</span>
          <a-row>
            <a-col :span="6">
              <div style="margin-left: 56px;margin-bottom: 20px">1.小程序下单图</div>
              <div style="margin-left: 56px">
                <j-image-upload-by-banner isMultiple v-model="model.orderWxappQrCode"></j-image-upload-by-banner>
              </div>
            </a-col>
            <a-col :span="12">
              <div style="margin-left: 56px;margin-bottom: 20px">2.小程序存鞋图</div>
              <div style="margin-left: 56px">
                <j-image-upload-by-one v-model="model.saveWxappQrCode"></j-image-upload-by-one>
              </div>
            </a-col>
          </a-row>
          <a-row>
            <a-col :span="12">
              <div style="margin-left: 56px;margin-bottom: 20px">3.小程序取鞋的图</div>
              <div style="margin-left: 56px">
                <j-image-upload-by-banner isMultiple v-model="model.retrieveWxappQrCode"></j-image-upload-by-banner>
              </div>
            </a-col>
          </a-row>
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
        sm: {span: 2},
      },
      wrapperCol: {
        xs: {span: 24},
        sm: {span: 10},
      },
      rules: {
        account: [
          {required: true, message: '请输入账号!'},
        ],
        password: [
          {required: true, pattern:/^[A-Za-z0-9]+.{8,16}$/ ,message: '密码由8位数字和大小写字母组成!'},
        ],
        phone: [
          {required: false, message: '请正确电话号码!'},
        ],
        banner: [
          {required: true, message: '请上传至少一张轮播图!'},
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
    httpAction("/ShoeConfig/shoeConfig/showShoeLockerConfig", "", "get").then((res)=> {
      let resultList = res.result;
      console.log(resultList);

      let account = "";
      let password = "";
      let banner = "";
      let indexRetrievePic = "";
      let indexSavePic = "";
      let officialAccount = "";
      let orderWxappQrCode = "";
      let phone = "";
      let retrieveWxappQrCode = "";
      let rightTopPic = "";
      let saveWxappQrCode = "";
      let userAgreement = "";

      for (let i  = 0 ; i < resultList.length; i ++) {
        let resultListElement = resultList[i];
        if ("adminLoginInfo" === resultListElement.name) {
          let value = resultListElement.value;
          let split = value.split(",");
          account = split[0];
          password = split[1];
        } else if ("banner" === resultListElement.name) {
          banner = resultListElement.value;
        } else if ("indexRetrievePic" === resultListElement.name) {
          indexRetrievePic = resultListElement.value;
        } else if ("indexSavePic" === resultListElement.name) {
          indexSavePic = resultListElement.value;
        } else if ("officialAccount" === resultListElement.name) {
          officialAccount = resultListElement.value;
        } else if ("orderWxappQrCode" === resultListElement.name) {
          orderWxappQrCode = resultListElement.value;
        } else if ("phone" === resultListElement.name) {
          phone = resultListElement.value;
        } else if ("retrieveWxappQrCode" === resultListElement.name) {
          retrieveWxappQrCode = resultListElement.value;
        } else if ("rightTopPic" === resultListElement.name) {
          rightTopPic = resultListElement.value;
        } else if ("saveWxappQrCode" === resultListElement.name) {
          saveWxappQrCode = resultListElement.value;
        } else if ("userAgreement" === resultListElement.name) {
          userAgreement = resultListElement.value;
        }
      }

      this.model = {
        "account": account,
        "password": password,
        "banner": banner,
        "indexRetrievePic": indexRetrievePic,
        "indexSavePic": indexSavePic,
        "officialAccount": officialAccount,
        "orderWxappQrCode": orderWxappQrCode,
        "phone": phone,
        "retrieveWxappQrCode": retrieveWxappQrCode,
        "rightTopPic": rightTopPic,
        "saveWxappQrCode": saveWxappQrCode,
        "userAgreement": userAgreement
      }
    })
  },
  mounted() {
  },
  methods: {
    submitForm() {
      const that = this;

      let data = {
        "adminLoginInfo": this.model.account + "," + this.model.password,
        "banner": this.model.banner,
        "indexRetrievePic": this.model.indexRetrievePic,
        "indexSavePic": this.model.indexSavePic,
        "officialAccount": this.model.officialAccount,
        "orderWxappQrCode": this.model.orderWxappQrCode,
        "phone": this.model.phone,
        "retrieveWxappQrCode": this.model.retrieveWxappQrCode,
        "rightTopPic": this.model.rightTopPic,
        "saveWxappQrCode": this.model.saveWxappQrCode,
        "userAgreement": this.model.userAgreement
      };

      httpAction("/ShoeConfig/shoeConfig/saveShoeLockerConfig", data, "post").then((res) => {
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