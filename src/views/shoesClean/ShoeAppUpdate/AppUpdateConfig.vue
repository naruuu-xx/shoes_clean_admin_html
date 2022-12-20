<template>
  <a-card class="card" :bordered="false">
    <div>
      <a-spin :spinning="confirmLoading">
        <a-form :model="model" :label-col="labelCol" :wrapper-col="wrapperCol" :rules="rules">
          <div>
            <a-row>
              <a-col :span="24">
                <a-form-item label="APP版本号：" prop="versionApp">
                  <a-input v-model:value="model.versionApp" style="width: 200px"/>
                </a-form-item>
              </a-col>
            </a-row>
            <a-row>
              <a-col :span="24">
                <a-form-item label="APP下载地址：" prop="urlApp">
                  <a-input v-model:value="model.urlApp"/>
                </a-form-item>
              </a-col>
            </a-row>
          </div>
        </a-form>
        <!-- 底部提交按钮 -->
        <footer-tool-bar>
          <a-button type="primary" @click="submitForm" :loading="loading">提交</a-button>
        </footer-tool-bar>
      </a-spin>
    </div>
  </a-card>
</template>

<script>

import FooterToolBar from '@/components/tools/FooterToolBar';
import {httpAction} from "../../../api/manage";

export default {
  name: "AppUpdateConfig",
  components: {
    FooterToolBar
  },
  data() {
    return {
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
        versionApp: [
          {required: true, message: '请输入app版本号!'},
        ],
        urlApp: [
          {required: true, message: '请输入app下载地址!'},
        ],
      },
      headers:{},
      confirmLoading: false,
    }
  },
  computed: {},
  created() {
    this.getAppUpdateConfigInfo();
  },
  mounted() {
  },
  methods: {
    submitForm() {
      const that = this;

      that.confirmLoading = true;
      setTimeout(() => {

        let data = {
          "versionApp": this.model.versionApp,
          "urlApp": this.model.urlApp,
        };

        httpAction("/ShoeConfig/shoeConfig/saveShoeAppUpdateConfig", data, "post").then((res) => {
          if (res.success) {
            that.$message.success(res.message);
            this.getAppUpdateConfigInfo();
          } else {
            that.$message.warning(res.message);
          }
        })
        that.confirmLoading = false;
      }, 1000)
    },
    getAppUpdateConfigInfo() {
      httpAction("/ShoeConfig/shoeConfig/showShoeAppUpdateConfig", "", "get").then((res)=> {
        let resultList = res.result;

        let versionApp = resultList.versionApp;
        let urlApp = resultList.urlApp;

        this.model = {
          "versionApp": versionApp,
          "urlApp": urlApp
        }
      })
    }
  }
}
</script>

<style lang="less" scoped>
.card {
  //margin-bottom: 24px;
}
</style>