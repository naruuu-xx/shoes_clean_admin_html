<template>
  <j-modal
    :title="title"
    :width="1200"
    :visible="visible"
    switchFullscreen
    @cancel="handleCancel"
    cancelText="关闭"
    :footer="null"
    :fullscreen="false">
    <div style="margin-left: 20px">
      <a-row>
        <a-col :span="18">
          <a-input style="height: 120px" v-model.trim="no" placeholder="请扫码水洗唛编码或者手动输入水洗唛编码"
                   @pressEnter="queryOutOfStorageInfo" ref="autoInput"/>
        </a-col>
        <a-col :span="2"></a-col>
        <a-col :span="4">
          <a-row>
            <a-button @click="queryOutOfStorageInfo" :loading="loadingBtn"
                      style="width: 100%;height: 50px;margin-bottom: 20px;background: rgba(0,229,230,0.39)"><span
              style="font-size: 22px;">确&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;认</span></a-button>
          </a-row>
          <a-row>
            <a-button @click="emptyNo" style="width: 100%;height: 50px;background: rgba(255,255,102,0.56)"><span
              style="font-size: 22px;">清&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;空</span></a-button>
          </a-row>
        </a-col>
      </a-row>
      <a-divider/>
      <a-row v-show="shoeOrderInfo">
        <a-row style="margin-bottom: 10px">
          <a-col :span="18">
            <span class="content">订单编号：{{ data.no }}</span>
          </a-col>
          <a-col :span="2"></a-col>
          <a-col :span="4">
            <a-button @click="handleOutOfStorage" style="width: 100%;height: 50px;background: rgba(255,46,77,0.63)"><span style="font-size: 22px;" :loading="loadingBtn">打&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;印</span></a-button>
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
            <p class="content">订单照片：</p>
            <img alt="example" style="width: 25%;height:25%;margin: 10px" v-for="item in imageList"
                 :src="item" @click="showImage(item)">
          </a-col>
        </a-row>
        <a-row>
          <a-col :span="24">
            <p class="content">入库照片：</p>
            <img alt="example" style="width: 25%;height:25%;margin: 10px" v-for="item in factoryInImages"
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
import { getLodop } from '@/utils/LodopFuncs';
let Lodop;

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
      resData: {},
      loadingBtn: false,
      factoryInImages: []
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
      this.loadingBtn = false
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
    queryOutOfStorageInfo() {
      if (this.no === "" || this.no === null || this.no === undefined) {
        this.$message.warning("请扫码水洗唛编码或者手动输入水洗唛编码");
      } else {
        let data = {
          "no": this.no
        }
        this.loadingBtn = true
        httpAction("/ShoeFactoryOrder/shoeFactoryOrder/queryShoeOutOfStorageInfo", data, "post").then((res) => {
          if (res.code === 200) {
            this.data = {
              "no": res.result.no,
              "note": res.result.note,
              "title": res.result.title,
              "skuTitle": res.result.skuTitle
            }
            this.imageList = JSON.parse(res.result.orderImages);
            this.factoryInImages = res.result.factoryInImages;
            this.shoeOrderInfo = true;
            //清空输入框并重新聚焦
            this.no = "";
            this.$nextTick(() => {
              this.$refs.autoInput.focus();
            })
          } else {
            this.$message.warning(res.message);
          }
        }).finally(res => {
          this.loadingBtn = false
        })
      }
    },
    handleOutOfStorage() {
      //处理出库
      if (this.data.no === "" || this.data.no === null || this.data.no === undefined) {
        this.$message.warning("请扫码水洗唛编码或者手动输入水洗唛编码");
      } else {
        let data = {
          "no": this.data.no
        }
        this.loadingBtn = true
        httpAction("/ShoeFactoryOrder/shoeFactoryOrder/shoeOutOfStorage", data, "post").then((res) => {
          if (res.code !== 200) {
            if (res.code !== 2000 && res.code !== 2001) {
              this.$message.warning(res.message);
            }

            //清空输入框并重新聚焦
            this.no = "";
            this.$nextTick(() => {
              this.$refs.autoInput.focus();
            })

            if (res.code === 2001) {
              this.resData = res;
              this.resDataModal = true;
              //打印水洗唛
              this.createWashedMark(res.result.no);


            } else if (res.code === 2000) {
              this.resData = res;
              this.$message.success(res.message, 5);
              //打印水洗唛
              this.createWashedMark(res.result.no)

              //lodop打印快递
              this.printKuaidi(res.result.deliveryId);


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
        }).finally(res => {
          this.loadingBtn = false
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
    printKuaidi(deliveryId){
      let data = {
        "deliveryId": deliveryId
      }
      downFile("/ShoeFactoryOrder/shoeFactoryOrder/createKuaidiByOut", data, "post").then((res) => {
        if (!res) {
          this.$message.warning(res.message)
          return
        }
        let content = 'data:image/jpeg;base64,';

        let cont
        // data：指待读取blob数据
        let reader = new FileReader();
        reader.onload = event => {
          //读取之后进行操作的代码区域，event.currentTarget.result 指读取到的内容
          cont=content+event.currentTarget.result

          this.printPic(cont,'快递100')

        }
        //调用方法读取
        reader.readAsText(res);

      })

    },
    /**
     *
     * @param image 图片
     * @param printerName 打印机名称
     */
    printPic(image,printerName){
      LODOP = getLodop() // 获取LODOP对象的主过程
      if (LODOP != false) {
        let timestamp = parseInt(new Date().getTime() / 1000 + '');
        LODOP.PRINT_INIT("面单打印" + timestamp);
        LODOP.SET_PRINT_PAGESIZE(1, "95mm", "113m", "");
        LODOP.ADD_PRINT_IMAGE(0, 0, "95mm", "113mm", image)
        // LODOP.SET_PRINT_STYLEA(0,"Stretch",1);//(可变形)扩展缩放模式
        LODOP.SET_PRINT_STYLEA(0, "Stretch", 2); //按原图比例(不变形)缩放模式

        //设定名称为XXX的打印机为本次打印的打印机
        let index = this.getPrinterIndex(LODOP, printerName);
        LODOP.SET_PRINTER_INDEX(index);
        LODOP.SET_SHOW_MODE('PREVIEW_IN_BROWSE', 1)

        // LODOP.PRINT()// 直接打印
        LODOP.PREVIEW() // 打印预览
      }
    },
    /**
     * 根据打印机名称获取该打印机在系统中的序号
     * @param {Object} LODOP
     * @param printName
     */
    getPrinterIndex(LODOP, printName) {
      let num = LODOP.GET_PRINTER_COUNT();
      let index = 0;
      for (let i = 0; i < num; i++) {
        let name = LODOP.GET_PRINTER_NAME(i);
        if (printName === name) {
          index = i;
          break;
        }
      }
      return index;
    },
    createWashedMark(no) {
      let data = {
        "no": no
      }
      httpAction("/ShoeFactoryOrder/shoeFactoryOrder/createWashedMarkByOut", data, "post").then((res) => {
        if (!res) {
          this.$message.warning(res.message)
          return
        }
        const file = res;
        this.printThermal(file, "热敏纸")

        this.confirmLoading = false;
      })
    },
    /**
     *
     * @param file base64
     * @param printerName 打印机名称
     */
    printThermal(file,printerName){
      LODOP = getLodop() // 获取LODOP对象的主过程
      LODOP.SET_LICENSES("","9598E18E55ADC63670695568858B9F880FD","","")
      if (LODOP != false) {
        let timestamp = parseInt(new Date().getTime() / 1000 + '');
        LODOP.PRINT_INIT("出库打印热敏纸" + timestamp);
        LODOP.SET_PRINTER_INDEX(printerName);
        LODOP.SET_PRINT_PAGESIZE(1, "49mm", "50mm", "");
        LODOP.ADD_PRINT_PDF(0,0,"100%","100%",file);

        // LODOP.PRINT()// 直接打印
        LODOP.PREVIEW() // 打印预览
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