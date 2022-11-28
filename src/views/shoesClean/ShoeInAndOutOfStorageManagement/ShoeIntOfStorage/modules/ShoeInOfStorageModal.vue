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
    <div style="margin-left: 20px">
      <a-row>
        <a-col :span="18">
          <a-input style="height: 120px" v-model:value="bagCode" placeholder="请扫码袋子编码或者手动输入袋子编码" @pressEnter="queryOrderInfo"  ref="autoInput"/>
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
          <a-col :span="18">
            <span class="content">订单编号：{{data.no}}</span>
          </a-col>
          <a-col :span="2"></a-col>
          <a-col :span="4">
            <a-button @click="handleInOfStorage" style="width: 100%;height: 50px;background: rgba(255,46,77,0.63)"><span style="font-size: 22px;">打&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;印</span></a-button>
          </a-col>
        </a-row>
        <a-row style="margin-bottom: 30px">
          <a-col :span="24">
            <span class="content">商品名：{{data.title}}</span>
          </a-col>
        </a-row>
        <a-row style="margin-bottom: 30px">
          <a-col :span="24">
            <span class="content">商品规格：{{data.skuTitle}}</span>
          </a-col>
        </a-row>
        <a-row>
          <a-col :span="24">
            <p class="content">照片：</p>
            <img alt="example" style="width: 25%;height:25%;margin: 10px" v-for="item in imageList"
                 :src="item" @click="showImage(item)">
          </a-col>
        </a-row>
      </a-row>
    </div>

    <a-modal :zIndex="2000" :width="1000" :visible="showImageModal" :footer="null"
             @cancel="handleShoeImageModalCancel()">
      <img alt="example" style="width: 100%" :src="clickedImage">
    </a-modal>

  </j-modal>
</template>

<script>

import {downFile, httpAction} from "../../../../../api/manage";

export default {
  name: "ShoeInOfStorageModal",
  components: {},
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
      this.data = {};
      this.imageList = [];
      this.shoeOrderInfo = false;
      this.bagCode = "";
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
      if (this.bagCode === "" || this.bagCode === null || this.bagCode === undefined) {
        this.$message.warning("请扫码袋子编码或者手动输入袋子编码");
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
            this.data = {
              "orderId": res.result.orderId,
              "no": res.result.no,
              "note": res.result.note,
              "title": res.result.title,
              "skuTitle": res.result.skuTitle
            }
            this.imageList = JSON.parse(res.result.orderImages);
            this.shoeOrderInfo = true;
            //清空输入框并重新聚焦
            this.bagCode = "";
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
    },
    handleInOfStorage(){
      // httpAction("/ShoeFactoryOrder/shoeFactoryOrder/shoeInOfStorage", this.data, "post").then((res) => {
      //
      // })
      downFile("/ShoeFactoryOrder/shoeFactoryOrder/shoeInOfStorage", this.data, "post").then((res) => {
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
        this.$message.success("入库成功");
      })
    },
    // 打印
    doPrint(val) {
      var ordonnance = document.getElementById(val).contentWindow;
      setTimeout(() => {
        // window.print()
        ordonnance.print();
      }, 100)
    },
  }
}
</script>

<style scoped>
.content {
  font-size: 20px;
  color: #000000;
}
</style>