<template>
  <j-modal
    :title="title"
    :width="1200"
    :visible="visible"
    switchFullscreen
    @cancel="handleCancel"
    cancelText="关闭"
    :footer="null"
    :fullscreen="true">
    <div style="margin-left: 20px">
      <a-row>
        <a-col :span="18">
          <a-input style="height: 120px" v-model:value="no" placeholder="请扫码水洗唛编码或者手动输入水洗唛编码"
                   @pressEnter="handleOutOfStorage" ref="autoInput"/>
        </a-col>
        <a-col :span="2"></a-col>
        <a-col :span="4">
          <a-row>
            <a-button @click="handleOutOfStorage"
                      style="width: 100%;height: 50px;margin-bottom: 20px;background: rgba(0,229,230,0.39)"><span
              style="font-size: 22px;">出&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;库</span></a-button>
          </a-row>
          <a-row>
            <a-button @click="emptyNo" style="width: 100%;height: 50px;background: rgba(255,255,102,0.56)"><span
              style="font-size: 22px;">清&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;空</span></a-button>
          </a-row>
        </a-col>
      </a-row>
      <a-divider/>
      <a-row v-show="shoeOrderInfo">
        <a-row style="margin-bottom: 30px">
          <a-col :span="24">
            <span class="content">订单编号：{{ data.no }}</span>
          </a-col>
        </a-row>
        <a-row style="margin-bottom: 30px">
          <a-col :span="24">
            <span class="content">商品名：{{ data.title }}</span>
          </a-col>
        </a-row>
        <a-row style="margin-bottom: 30px">
          <a-col :span="24">
            <span class="content">商品规格：{{ data.skuTitle }}</span>
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
    <a-modal :zIndex="2000" :width="600" :visible="resDataModal" :footer="null"
             @cancel="handleResDataModal">
      <h1 style="text-align: center">{{ resData.message }}</h1>
      <div style="display: flex;justify-content: center">
      <a-button type="primary" if="resData.code==2001" @click="routeToDetail">查看详情</a-button>
      </div>
    </a-modal>

  </j-modal>
</template>

<script>

import {downFile, httpAction} from "../../../../../api/manage";

export default {
  name: "ShoeOutOfStorageModal",
  components: {},
  data() {
    return {
      visible: false,
      resDataModal: false,
      title: '出库',
      no: "",
      data: {},
      imageList: [],
      showImageModal: false,
      shoeOrderInfo: false,
      clickedImage: "",
      resData: {

      },

    }
  },
  created() {
  },
  methods: {
    show(record) {
      this.visible = true;
      this.$nextTick(() => {
        this.$refs.autoInput.focus();
      })
    },
    routeToDetail() {
      this.$router.push("/shoesClean/ShoeExpressageOrder/ShoeExpressageOrderListByFactory");
    },
    handleResDataModal() {
      this.resDataModal = false

    },
    handleCancel() {
      this.visible = false;
      this.data = {};
      this.imageList = [];
      this.shoeOrderInfo = false;
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
    handleOutOfStorage() {
      //处理出库
      if (this.no === "" || this.no === null || this.no === undefined) {
        this.$message.warning("请扫码水洗唛编码或者手动输入水洗唛编码");
      } else {
        let data = {
          "no": this.no
        }
        httpAction("/ShoeFactoryOrder/shoeFactoryOrder/shoeOutOfStorage", data, "post").then((res) => {
          if (res.code !== 200) {
            this.$message.warning(res.message);
            //清空输入框并重新聚焦
            this.no = "";
            this.$nextTick(() => {
              this.$refs.autoInput.focus();
            })
            if (res.code == 2000 || res.code == 2001) {
              this.resData.message = res.message;
              this.resDataModal = true
            }

            return false;
          } else {
            this.data = {
              "no": res.result.no,
              "note": res.result.note,
              "title": res.result.title,
              "skuTitle": res.result.skuTitle
            }
            this.imageList = JSON.parse(res.result.orderImages);
            this.shoeOrderInfo = true;
            this.$message.success(res.message);
            //清空输入框并重新聚焦
            this.no = "";
            this.$nextTick(() => {
              this.$refs.autoInput.focus();
            })

            //打印水洗唛
            this.createWashedMark(res.result.no);

          }
        })
      }
    },
    emptyNo() {
      //清空输入框内容
      this.no = "";
      this.data = {};
      this.imageList = [];
      this.shoeOrderInfo = false;
    },
    createWashedMark(no) {
      let data = {
        "no": no
      }
      downFile("/ShoeFactoryOrder/shoeFactoryOrder/createWashedMarkByOut", data, "post").then((res) => {
        if (!res) {
          this.$message.warning(res.message)
          return
        }
        const content = res;
        // 主要的是在这里的转换，必须要加上{ type: 'application/pdf' }
        // 要不然无法进行打印
        const blob = new Blob([content], {type: 'application/pdf'});
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
  }
}
</script>

<style scoped>
.content {
  font-size: 20px;
  color: #000000;
}
</style>