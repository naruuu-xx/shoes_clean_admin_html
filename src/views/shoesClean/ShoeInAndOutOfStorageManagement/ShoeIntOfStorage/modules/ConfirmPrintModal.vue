<template>
  <j-modal
    :title="title"
    :width="600"
    :visible="visible"
    @ok="handleOk"
    @cancel="handleCancel"
    cancelText="关闭"
    :fullscreen = "false">
    <a-spin :spinning="confirmLoading">
      <a-row>
        <a-col :span="24" style="margin-bottom: 30px">
          <span class="content">订单编号：{{data.no}}</span>
        </a-col>
      </a-row>
      <a-row style="margin-bottom: 30px">
        <a-col :span="12">
          <span class="content">商品名：{{data.title}}</span>
        </a-col>
        <a-col :span="12">
          <span class="content">商品规格：{{data.skuTitle}}</span>
        </a-col>
      </a-row>
      <a-row style="margin-bottom: 30px">
        <a-col :span="24">
          <span class="content">附加项：{{data.name}}</span>
        </a-col>
      </a-row>
      <a-row style="margin-bottom: 30px">
        <a-col :span="24">
          <div class="content">备注：<a-input style="width: 240px;" v-model.trim="data.note" placeholder="请输入备注"/></div>
        </a-col>
      </a-row>
      <a-row style="margin-bottom: 30px">
        <a-col :span="24">
          <div class="content">品牌：<XfSelect
                :list="weekList"
                @change="checkedSelect"
                @changeList="changeSelect"
                v-model="data.brandId"
                :url='`/shoeBrand/list`'
              >
              </XfSelect></div>
        </a-col>
      </a-row>
      <a-row style="margin-bottom: 30px">
        <a-col :span="24">
          <div class="content">
            是否转为异常：
            <a-radio-group v-model="data.isException">
                <a-radio value="1">是</a-radio>
                <a-radio value="2">否</a-radio>
              </a-radio-group>
          </div>
        </a-col>
      </a-row>
    </a-spin>
  </j-modal>
</template>

<script>

import {downFile, httpAction, postAction} from "../../../../../api/manage";
import XfSelect from "@comp/Xf/XfSelect";
import { getLodop } from '@/utils/LodopFuncs';
let Lodop;

export default {
  name: "ConfirmPrintModal",
  components: {
    XfSelect
  },
  data() {
    return {
      weekList:[],
      visible: false,
      title: '',
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
    }
  },
  created() {
  },
  methods: {
    changeSelect(data) {
      this.weekList = data.records.map(item => ({
        label: item.name,
        value: +item.brandId
      }));
    },
    checkedSelect(val) {
    },
    show(record) {
      httpAction("/shoeFactoryWasher/getWasher","", "get").then((res) =>{
        if(!res.success){
          this.$message.warning(res.message)
        }
      })
      this.visible = true;
      this.data = Object.assign({},record,{isException:"2"})
    },
    handleCancel(){
      this.visible = false;
    },
    handleOk(){

      this.handleInOfStorage();

    },
    handleInOfStorage(){

      if (!this.data.brandId){
        return this.$message.warning("请选择品牌");
      }
      if (this.data.isException == '1' && !this.data.factoryInImages.length){
        return this.$message.warning("请拍摄入库照片！");
      }
      this.confirmLoading = true;
        //处理入库
        this.loadingBtn = true;
        postAction("/ShoeFactoryOrder/shoeFactoryOrder/shoeInOfStorage", this.data).then((res) => {
          if (res.code !== 200) {
            this.$message.warning(res.message);
          } else {
            //打印水洗唛
            this.downWaterMark(res.result);
            this.visible = false;
          }
        }).finally(res => {
          this.loadingBtn = false;
          this.confirmLoading = false;
        })
    },
    downWaterMark(no) {
      let data = {
        "no": no
      }

      httpAction("/ShoeFactoryOrder/shoeFactoryOrder/createWashedMark", data, "post").then((res) => {
        if (!res) {
          this.$message.warning(res.message)
          return
        }
        const file = res;
        this.printPic(file, "水洗唛")

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
        LODOP.PRINT_INIT("入库打印水洗唛" + timestamp);
        LODOP.SET_PRINTER_INDEX(printerName);
        LODOP.SET_PRINT_PAGESIZE(1, "111mm", "20mm", "");
        LODOP.SET_PRINT_COPIES(2);
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