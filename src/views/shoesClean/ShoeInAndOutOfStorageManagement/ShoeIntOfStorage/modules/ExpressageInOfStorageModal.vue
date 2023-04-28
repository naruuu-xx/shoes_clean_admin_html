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
            <a-input style="height: 120px" v-model.trim="KuaidiNum" placeholder="请输入快递单号" @pressEnter="queryOrderInfo"  ref="autoInput"/>
          </a-col>
          <a-col :span="2"></a-col>
          <a-col :span="4">
            <a-row><a-button @click="queryOrderInfo" style="width: 100%;height: 50px;margin-bottom: 20px;background: rgba(0,229,230,0.39)"><span style="font-size: 22px;">确&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;认</span></a-button></a-row>
            <a-row><a-button @click="emptyKuaidiNum" style="width: 100%;height: 50px;background: rgba(255,255,102,0.56)"><span style="font-size: 22px;">清&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;空</span></a-button></a-row>
          </a-col>
        </a-row>
        <a-row style="margin-top: 12px;" v-if="shoeOrderInfo">
          <a-col :span="18">
            <div class="tab">
              <a-radio-group v-model="tabValue" button-style="solid">
                <a-radio-button :value="item.value" v-for="(item, index) in tabs" :key="index">
                  {{item.label}}
                </a-radio-button>
              </a-radio-group>
            </div>
          </a-col>
          <a-col :span="2"></a-col>
          <a-col :span="4">
            <a-button @click="shoeInOfStorageModal" style="width: 100%;height: 50px;background: rgba(255,46,77,0.63)"><span style="font-size: 22px;">打&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;印</span></a-button>
          </a-col>
        </a-row>
        <a-row v-if="shoeOrderInfo">
          <XfPhotograph ref="photograph" :photographImg="dataList[tabValue].factoryInImages"></XfPhotograph>
        </a-row>
        <a-divider />
        <div class="list">
          <a-row v-show="shoeOrderInfo">
            <div v-for="(item,idx) in dataList" :key="idx">
            <a-row>
              <a-col :span="18">
                <span class="content">订单编号：{{item.no}}</span>
              </a-col>
            </a-row>
            <a-row style="margin-bottom: 30px">
              <a-col :span="6">
                <span class="content">商品名：{{item.title}}</span>
              </a-col>
              <a-col :span="18">
                <span class="content">商品规格：{{item.skuTitle}}</span>
              </a-col>
            </a-row>
            <a-row style="margin-bottom: 30px">
              <a-col :span="24">
                <span class="content">附加项：{{item.name}}</span>
              </a-col>
            </a-row>
            <a-row style="margin-bottom: 30px">
              <a-col :span="8">
                <span class="content">姓名：{{item.userName}}</span>
              </a-col>
              <a-col :span="8">
                <span class="content">电话：{{item.userPhone}}</span>
              </a-col>
            </a-row>
            <a-row style="margin-bottom: 30px">
              <a-col :span="24">
                <span class="content">地址（用户寄）：{{item.userAddressSend}}</span>
              </a-col>
            </a-row>
            <a-row style="margin-bottom: 30px">
              <a-col :span="24">
                <span class="content">地址（用户收）：{{item.userAddressReceive}}</span>
              </a-col>
            </a-row>
            <a-row style="margin-bottom: 30px">
              <a-col :span="12">
                <span class="content">订单类型：{{item.orderType}}</span>
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
                <img alt="example" style="width: 25%;height:25%;margin: 10px" v-for="image in item.imageList"
                     :src="image" @click="showImage(image)">
              </a-col>
            </a-row>
            </div>
          </a-row>
        </div>
        
      </div>
    </a-spin>

    <a-modal :zIndex="2000" :width="1000" :visible="showImageModal" :footer="null"
             @cancel="handleShoeImageModalCancel()">
      <img alt="example" style="width: 100%" :src="clickedImage">
    </a-modal>

    <confirm-expressage-print-modal ref="confirmExpressagePrintModal"></confirm-expressage-print-modal>

    <platform-confirm-modal ref="platformConfirmModal" @rk="rk"></platform-confirm-modal>

    <ManualInOfStorageMultiple ref="ManualInOfStorageMultiple"></ManualInOfStorageMultiple>

  </j-modal>
</template>

<script>

import {downFile, httpAction} from "../../../../../api/manage";
import ConfirmExpressagePrintModal from "./ConfirmExressagePrintModal";
import PlatformConfirmModal from "./PlatformConfirmModal";
import ManualInOfStorageMultiple from './ManualInOfStorageMultiple'
import XfPhotograph from "@comp/Xf/XfPhotograph";

export default {
  name: "ShoeInOfStorageModal",
  components: {ConfirmExpressagePrintModal, PlatformConfirmModal,ManualInOfStorageMultiple,XfPhotograph},
  data() {
    return {
      visible: false,
      title: '入库',
      KuaidiNum: "",
      dataList:[],
      imageList: [],
      showImageModal: false,
      shoeOrderInfo: false,
      clickedImage: "",
      confirmLoading: false,
      showInOfStoragePrintModal: false,
      selectedNote: [],
      noteOptions: [],
      tabValue: 0
    }
  },
  created() {
  },
  computed:{
    tabs() {
      return this.dataList.map((item,idx) => ({
        label: `鞋子${idx+1}`,
        value: idx
      }))
    }
  },
  watch:{
    tabValue: {
      handler(val,oldValue) {
        let imgs = this.$refs.photograph.imgs
        this.dataList[oldValue].factoryInImages = imgs
      },
    },
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
      this.KuaidiNum = "";
      //关闭弹窗并刷新列表
      this.$emit('ok');
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
      if (this.KuaidiNum === "" || this.KuaidiNum === null || this.KuaidiNum === undefined) {
        this.$message.warning("请扫描快递单号或者手动输入快递单号");
      } else {
        httpAction("/ShoeFactoryOrder/shoeFactoryOrder/queryExpressageOrderInfoByKuaidiNum?kuaidiNum=" + this.KuaidiNum, null, "get").then((res) => {
          if (res.code !== 200) {
            this.$message.warning(res.message);
            //清空输入框并重新聚焦
            this.KuaidiNum = "";
            this.$nextTick(()=> {
              this.$refs.autoInput.focus();
            })
            return false;
          } else {
            res.result[0].orderId
            if (res.result[0].orderId == null) {
              this.$refs.platformConfirmModal.show(res.result);
            } else {
              this.dataList = res.result.map(item => {
                let imageList = JSON.parse(item.orderImages)
                let factoryInImages = []
                return Object.assign({},item,{imageList,factoryInImages})
              })
              this.shoeOrderInfo = true;
              //清空输入框并重新聚焦
              this.KuaidiNum = "";
              this.selectedNote = [];
              this.$nextTick(()=> {
                this.$refs.autoInput.focus();
              })
            }
          }
        })
      }
    },
    emptyKuaidiNum(){
      //清空输入框内容
      this.KuaidiNum = "";
      this.data = {};
      this.imageList = [];
      this.shoeOrderInfo = false;
      this.selectedNote = [];
    },
    handleShowInOfStoragePrintModalCancel() {
      this.showInOfStoragePrintModal = false;
    },
    shoeInOfStorageModal() {
      this.confirmLoading = true
      // this.showInOfStoragePrintModal = true;
      this.dataList[this.tabValue].factoryInImages = this.$refs.photograph.imgs
      let data = this.dataList.map(async (item,idx) => {
        let factoryInImages = await this.$refs.photograph.uploadImgs(item.factoryInImages)
        return {
          ...item,
          factoryInImages
        }
          
      });
      Promise.all(data).then(res => {
        this.dataList = res
        console.log(222,res);
        let d = this.dataList.map(item => ({
          ...item,
          factoryInImages: item.factoryInImages.map(t => t.file)
        }))
        console.log('ddd',d);
        this.$refs.confirmExpressagePrintModal.show(d);
        this.confirmLoading = false
      }).catch(err => {
        console.log(55,err);
        this.confirmLoading = false
      })
      
      
    },
    handleInOfStorage(){
      this.confirmLoading = true;
      downFile("/ShoeFactoryOrder/shoeFactoryOrder/expressageInOfStorage", this.data, "post").then((res) => {
        if (!res) {
          this.$message.warning(res.message)
          return
        }
        const content = res;
        // 主要的是在这里的转换，必须要加上{ type: 'application/pdf' }
        // 要不然无法进行打印
        const blob = new Blob([content], { type: 'application/pdf' });
        //=========================================================
        var date = (new Date()).getTime();
        var ifr = document.createElement('iframe');
        ifr.style.frameborder = 'no';
        ifr.style.display = 'none';
        ifr.style.pageBreakBefore = 'always';
        ifr.setAttribute('download', 'printPdf' + date + '.pdf');
        ifr.setAttribute('id', 'printPdf' + date + '.pdf');
        ifr.src = window.URL.createObjectURL(blob);
        document.body.appendChild(ifr);

        this.doPrint('printPdf' + date + '.pdf')
        window.URL.revokeObjectURL(ifr.src) // 释放URL 对象
        //=========================================================
        // this.$message.success("入库成功");
        this.confirmLoading = false;
      })
    },
    // 打印
    doPrint(val) {
      var ordonnance = document.getElementById(val).contentWindow;
      setTimeout(() => {
        // window.print()
        ordonnance.print();
      }, 0)
    },
    rk(val) {
      this.$refs.ManualInOfStorageMultiple.show(val)
    }
  }
}
</script>

<style scoped lang="less">
  .tab {
    height: 50px;
    display: flex;
    align-items: center;
  }
  .tab /deep/ .ant-radio-group {
    overflow-x: scroll;
    display: flex;
  }
  .list {
    max-height: 340px;
    overflow-y: scroll;
  }
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