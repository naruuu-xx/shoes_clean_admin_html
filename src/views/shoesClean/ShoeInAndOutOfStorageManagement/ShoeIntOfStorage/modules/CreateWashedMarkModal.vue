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
          <a-input style="height: 120px" v-model:value="no" placeholder="请扫码水洗唛编码或者手动输入水洗唛编码" @pressEnter="handleOutOfStorage"  ref="autoInput"/>
        </a-col>
        <a-col :span="2"></a-col>
        <a-col :span="4">
          <a-row><a-button @click="handleOutOfStorage" style="width: 100%;height: 50px;margin-bottom: 20px;background: rgba(0,229,230,0.39)"><span style="font-size: 22px;">打&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;印</span></a-button></a-row>
          <a-row><a-button @click="emptyBagCode" style="width: 100%;height: 50px;background: rgba(255,255,102,0.56)"><span style="font-size: 22px;">清&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;空</span></a-button></a-row>
        </a-col>
      </a-row>
      <a-divider />
    </div>

  </j-modal>
</template>

<script>

import {downFile, httpAction} from "../../../../../api/manage";

export default {
  name: "CreateWashedMarkModal",
  components: {},
  data() {
    return {
      visible: false,
      title: '打印入库水洗唛',
      no: "",
      data: {},
      imageList: [],
      shoeOrderInfo: false,
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
      this.no = "";
      //关闭弹窗并刷新列表
      this.$emit('ok');
    },
    emptyBagCode(){
      //清空输入框内容
      this.no = "";
      this.data = {};
      this.imageList = [];
      this.shoeOrderInfo = false;
    },
    handleOutOfStorage(){
      let data = {
        "no": this.no
      }
      downFile("/ShoeFactoryOrder/shoeFactoryOrder/createWashedMark", data, "post").then((res) => {
        if (!res.success && res.success !== undefined) {
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
        // this.$message.success("打印成功");
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