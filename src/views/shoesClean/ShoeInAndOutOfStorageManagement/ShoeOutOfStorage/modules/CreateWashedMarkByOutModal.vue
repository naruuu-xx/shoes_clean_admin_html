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
    <a-spin :spinning="confirmLoading">
    <div style="margin-left: 20px">
      <a-row>
        <a-col :span="18">
          <a-input style="height: 120px" v-model.trim="no" placeholder="请扫码水洗唛编码或者手动输入水洗唛编码" @pressEnter="handleInOfStorage"  ref="autoInput"/>
        </a-col>
        <a-col :span="2"></a-col>
        <a-col :span="4">
          <a-row><a-button @click="handleInOfStorage" style="width: 100%;height: 50px;margin-bottom: 20px;background: rgba(0,229,230,0.39)"><span style="font-size: 22px;">打&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;印</span></a-button></a-row>
          <a-row><a-button @click="emptyBagCode" style="width: 100%;height: 50px;background: rgba(255,255,102,0.56)"><span style="font-size: 22px;">清&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;空</span></a-button></a-row>
        </a-col>
      </a-row>
      <a-divider />
    </div>
    </a-spin>
  </j-modal>
</template>

<script>

import {downFile, httpAction} from "../../../../../api/manage";
import { getLodop } from '@/utils/LodopFuncs';
let Lodop;
export default {
  name: "CreateWashedMarkByOutModal",
  components: {},
  data() {
    return {
      visible: false,
      title: '打印出库水洗唛',
      no: "",
      data: {},
      shoeOrderInfo: false,
      clickedImage: "",
      confirmLoading: false,
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
      this.shoeOrderInfo = false;
      this.no = "";
      //关闭弹窗并刷新列表
      this.$emit('ok');
    },
    emptyBagCode(){
      //清空输入框内容
      this.no = "";
      this.data = {};
      this.shoeOrderInfo = false;
    },
    handleInOfStorage(){
      this.confirmLoading = true;
      let data = {
        "no": this.no
      }
      httpAction("/ShoeFactoryOrder/shoeFactoryOrder/reCreateWashedMarkByOut", data, "post").then((res) => {
        if (res.code != 200) {
          this.$message.warning(res.message)
        } else {
          const file = res.result;
          this.printPic(file, "热敏纸")
        }

        this.confirmLoading = false;
      })
    },
    /**
     *
     * @param file base64
     * @param printerName 打印机名称
     */
    printPic(file,printerName){
      LODOP = getLodop() // 获取LODOP对象的主过程
      LODOP.SET_LICENSES("","9598E18E55ADC63670695568858B9F880FD","","")
      if (LODOP != false) {
        let timestamp = parseInt(new Date().getTime() / 1000 + '');
        LODOP.PRINT_INIT("出库打印热敏纸" + timestamp);
        LODOP.SET_PRINTER_INDEX(printerName);
        LODOP.SET_PRINT_PAGESIZE(1, "49mm", "50mm", "");
        LODOP.ADD_PRINT_PDF(0,0,"100%","100%",file);

        if (process.env.NODE_ENV === 'production') {
          LODOP.PRINT() // 直接打印
        } else {
          LODOP.PREVIEW() // 打印预览
        }
      }
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