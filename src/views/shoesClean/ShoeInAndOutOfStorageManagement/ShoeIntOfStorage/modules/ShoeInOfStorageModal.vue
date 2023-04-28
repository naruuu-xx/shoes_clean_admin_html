<template>
  <j-modal
    :title="title"
    :width="1200"
    :visible="visible"
    switchFullscreen
    @cancel="handleCancel"
    cancelText="关闭"
    :footer="null"
    :fullscreen = "false">
    <a-spin :spinning="confirmLoading">
      <div style="margin-left: 20px">
        <a-row>
          <a-col :span="18">
            <a-input style="height: 120px" v-model.trim="bagCode" placeholder="请扫码袋子编码或者手动输入袋子编码" @pressEnter="queryOrderInfo"  ref="autoInput"/>
          </a-col>
          <a-col :span="2"></a-col>
          <a-col :span="4">
            <a-row><a-button @click="queryOrderInfo" style="width: 100%;height: 50px;margin-bottom: 20px;background: rgba(0,229,230,0.39)"><span style="font-size: 22px;">确&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;认</span></a-button></a-row>
            <a-row><a-button @click="emptyBagCode" style="width: 100%;height: 50px;background: rgba(255,255,102,0.56)"><span style="font-size: 22px;">清&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;空</span></a-button></a-row>
          </a-col>
        </a-row>
        <a-divider />
        
        <a-row v-show="shoeOrderInfo">
          <a-row>
            <XfPhotograph ref="photograph"></XfPhotograph>
          </a-row>
          <a-row>
            <a-col :span="18">
              <span class="content">订单编号：{{data.no}}</span>
            </a-col>
            <a-col :span="2"></a-col>
            <a-col :span="4">
              <a-button @click="shoeInOfStorageModal" style="width: 100%;height: 50px;background: rgba(255,46,77,0.63)"><span style="font-size: 22px;" :loading="loadingBtn">打&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;印</span></a-button>
            </a-col>
          </a-row>
          <a-row style="margin-bottom: 30px">
            <a-col :span="6">
              <span class="content">商品名：{{data.title}}</span>
            </a-col>
            <a-col :span="18">
              <span class="content">商品规格：{{data.skuTitle}}</span>
            </a-col>
          </a-row>
          <a-row style="margin-bottom: 30px">
            <a-col :span="24">
              <span class="content">附加项：{{data.name}}</span>
            </a-col>
          </a-row>
          <a-row style="margin-bottom: 30px">
            <a-col :span="8">
              <span class="content">姓名：{{data.userName}}</span>
            </a-col>
            <a-col :span="8">
              <span class="content">电话：{{data.userPhone}}</span>
            </a-col>
          </a-row>
          <a-row style="margin-bottom: 30px">
            <a-col :span="24">
              <span class="content">地址：{{data.userAddress}}</span>
            </a-col>
          </a-row>
          <a-row style="margin-bottom: 30px">
            <a-col :span="12">
              <span class="content">订单类型：{{data.orderType}}</span>
            </a-col>
            <a-col :span="12">
              <span class="content">{{data.orderType == '站点订单' ? '站点' : '机柜'}}名称：{{data.lockerName}}</span>
            </a-col>
          </a-row>
<!--          <a-row style="margin-bottom: 30px">-->
<!--            <a-col :span="24">-->
<!--              <span class="content">用户备注：{{data.note}}</span>-->
<!--            </a-col>-->
<!--          </a-row>-->
          <a-row>
            <a-col :span="24">
              <p class="content">照片：</p>
              <img alt="example" style="width: 25%;height:25%;margin: 10px" v-for="item in imageList"
                   :src="item" @click="showImage(item)">
            </a-col>
          </a-row>
        </a-row>
      </div>
    </a-spin>

    <a-modal :zIndex="2000" :width="1000" :visible="showImageModal" :footer="null"
             @cancel="handleShoeImageModalCancel()">
      <img alt="example" style="width: 100%" :src="clickedImage">
    </a-modal>

<!--    <a-modal :zIndex="2000" :width="600" :visible="showInOfStoragePrintModal" :footer="null"-->
<!--             @cancel="handleShowInOfStoragePrintModalCancel()">-->
<!--      <a-row>-->
<!--        <a-col :span="24" style="margin-bottom: 30px">-->
<!--          <span class="content">订单编号：{{data.no}}</span>-->
<!--        </a-col>-->
<!--      </a-row>-->
<!--      <a-row style="margin-bottom: 30px">-->
<!--        <a-col :span="12">-->
<!--          <span class="content">商品名：{{data.title}}</span>-->
<!--        </a-col>-->
<!--        <a-col :span="12">-->
<!--          <span class="content">商品规格：{{data.skuTitle}}</span>-->
<!--        </a-col>-->
<!--      </a-row>-->
<!--      <a-row style="margin-bottom: 30px">-->
<!--        <a-col :span="24">-->
<!--          <span class="content">附加项：{{data.name}}</span>-->
<!--        </a-col>-->
<!--      </a-row>-->
<!--      <a-row>-->
<!--        <a-col :span="24">-->
<!--          <a-form-model-item label="备注" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="note">-->
<!--            <a-select-->
<!--              v-model:value="selectedNote"-->
<!--              mode="multiple"-->
<!--              style="width: 100%;"-->
<!--              placeholder="请选择"-->
<!--              :options="noteOptions"-->
<!--              :z-index="2000"-->
<!--            >-->
<!--            </a-select>-->
<!--          </a-form-model-item>-->
<!--        </a-col>-->
<!--      </a-row>-->
<!--    </a-modal>-->

    <confirm-print-modal ref="confirmPrintModal"></confirm-print-modal>

  </j-modal>
</template>

<script>

import {downFile, httpAction, postAction} from "../../../../../api/manage";
import ConfirmPrintModal from "./ConfirmPrintModal";

import XfPhotograph from "@comp/Xf/XfPhotograph";

export default {
  name: "ShoeInOfStorageModal",
  components: {ConfirmPrintModal,XfPhotograph},
  data() {
    return {
      visible: false,
      title: '入库',
      bagCode: "",
      data: {},
      imageList: [],
      showImageModal: false,
      shoeOrderInfo: false,
      clickedImage: "",
      confirmLoading: false,
      showInOfStoragePrintModal: false,
      selectedNote: [],
      noteOptions: [],
      loadingBtn: false
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

      //获取备注项列表
      httpAction("/ShoeNote/shoeNote/queryList", null, "GET").then((res) => {
        this.noteOptions = res.result.records.map((item,index,arr)=>{
          let c = {label:item.note, value:item.note}
          return c;
        })
      })

    },
    handleCancel() {
      this.visible = false;
      this.data = {};
      this.imageList = [];
      this.shoeOrderInfo = false;
      this.bagCode = "";
      //关闭弹窗并刷新列表
      this.$emit('ok');
      this.loadingBtn = false;
    },
    showImage(item) {
      this.showImageModal = true;
      this.clickedImage = item;
    },
    handleShoeImageModalCancel() {
      this.showImageModal = false;
      this.clickedImage = "";
    },
    queryOrderInfo(){
      //查询订单信息
      if (this.bagCode === "" || this.bagCode === null || this.bagCode === undefined) {
        this.$message.warning("请扫描袋子编码或者手动输入袋子编码");
      } else if (this.bagCode.length < 6) {
        this.$message.warning("请扫描或输入正确的袋子编码");
      } else {
        httpAction("/ShoeFactoryOrder/shoeFactoryOrder/queryOrderInfoByBagCode?bagCode=" + this.bagCode, null, "get").then((res) => {
          if (res.code !== 200) {
            this.$message.warning(res.message);
            //清空输入框并重新聚焦
            this.bagCode = "";
            this.$nextTick(()=> {
              this.$refs.autoInput.focus();
            })
            return false;
          } else {
            this.data = res.result
            this.imageList = JSON.parse(res.result.orderImages);
            this.shoeOrderInfo = true;
            this.$refs.photograph.imgs = []
            //清空输入框并重新聚焦
            this.bagCode = "";
            this.selectedNote = [];
            this.$nextTick(()=> {
              this.$refs.autoInput.focus();
            })
          }
        })
      }
    },
    emptyBagCode(){
      //清空输入框内容
      this.bagCode = "";
      this.data = {};
      this.imageList = [];
      this.shoeOrderInfo = false;
      this.selectedNote = [];
    },
    handleShowInOfStoragePrintModalCancel() {
      this.showInOfStoragePrintModal = false;
    },
    shoeInOfStorageModal() {
      this.$refs.photograph.submit().then(factoryInImages => {
        this.$refs.confirmPrintModal.show(Object.assign({},this.data,{factoryInImages}));
      })
      // this.showInOfStoragePrintModal = true;
      
    },
  }
}
</script>

<style scoped lang="less">
.content {
  font-size: 20px;
  color: #000000;
}
.full-modal {
  .ant-modal {
    max-width: 100%;
    top: 0;
    padding-bottom: 0;
    margin: 0;
  }
  .ant-modal-content {
    display: flex;
    flex-direction: column;
    height: calc(100vh);
  }
  .ant-modal-body {
    flex: 1;
  }
}
</style>