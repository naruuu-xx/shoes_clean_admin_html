<template>
  <j-modal
    :title="title"
    :width="700"
    :visible="visible"
    @ok="handleOk"
    @cancel="handleCancel"
    cancelText="关闭"
    :fullscreen = "false">
    <a-spin :spinning="confirmLoading">
      <div class="box">
      <div v-for="(item,idx) in dataList" :key="idx">
        <a-row>
          <a-col :span="24" style="margin-bottom: 30px">
            <span class="content">订单编号：{{item.no}}</span>
          </a-col>
        </a-row>
        <a-row style="margin-bottom: 30px">
          <a-col :span="12">
            <span class="content">商品名：{{item.title}}</span>
          </a-col>
          <a-col :span="12">
            <span class="content">商品规格：{{item.skuTitle}}</span>
          </a-col>
        </a-row>
        <a-row style="margin-bottom: 30px">
          <a-col :span="24">
            <span class="content">附加项：{{item.name}}</span>
          </a-col>
        </a-row>
        <a-row style="margin-bottom: 30px">
          <a-col :span="24">
            <span class="content">
              备注：
              <a-input style="width: 50%" v-model.trim="item.selectedNote" placeholder="请输入备注"/>
            </span>
          </a-col>
        </a-row>
        <a-row style="margin-bottom: 30px">
          <a-col :span="24">
            <span class="content">
              品牌：
              <XfSelect
                :list="weekList"
                @change="checkedSelect"
                @changeList="changeSelect"
                v-model="item.brandId"
                :url='`/shoeBrand/list`'
              >
              </XfSelect>
            </span>
          </a-col>
        </a-row>
        <a-row style="margin-bottom: 30px">
          <a-col :span="24">
            <span class="content">是否转为异常：
              <a-radio-group v-model="item.isException">
                <a-radio value="1">是</a-radio>
                <a-radio value="2">否</a-radio>
              </a-radio-group>
              </span>
          </a-col>
        </a-row>

        <a-divider v-if="dataList.length > idx + 1 "/>
      </div>
    </div>
    </a-spin>
  </j-modal>
</template>

<script>

import {downFile, httpAction} from "../../../../../api/manage";
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
      labelCol: {
        xs: { span: 24 },
        sm: { span: 2 },
      },
      wrapperCol: {
        xs: { span: 24 },
        sm: { span: 16 },
      },
      visible: false,
      title: '',
      kuaidinum: "",
      data: {},
      imageList: [],
      showImageModal: false,
      shoeOrderInfo: false,
      clickedImage: "",
      confirmLoading: false,
      showInOfStoragePrintModal: false,
      noteOptions: [],
      dataList:[],
      selectedNoteKey: '',
      weekList:[],
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
    selectedNoteBlur(type,e) {
      // 后期在优化
      // if(type == 'focus') {
      //   this.selectedNoteKey = e
      // } else {
      //   if(this.selectedNoteKey == e && this.selectedNoteKey) {
      //     this.selectedNoteKey = ''
      //   }
      // }
    },
    // scrollEvent(e) {
    //   this.dataList.forEach((item,idx) => {
    //     this.$refs[`selectedNote${idx}`][0].blur()
    //   })
    // },
    show(record) {
      this.visible = true;
      httpAction("/shoeFactoryWasher/getWasher","", "get").then((res) =>{
        if(!res.success){
          this.$message.warning(res.message)
        }
      })
      this.dataList = record.map(item => Object.assign({},item,{selectedNote: "",isException: "2"}))
      //获取备注项列表
      httpAction("/ShoeNote/shoeNote/queryList", null, "GET").then((res) => {
        this.noteOptions = res.result.records.map((item,index,arr)=>{
          let c = {label:item.note, value:item.note}
          return c;
        })
      })
    },
    handleCancel(){
      this.visible = false;
    },
    handleOk(){
      let dataList = this.dataList.map(({orderId, selectedNote, sortNum,brandId,factoryInImages,isException}) => ({orderId, selectedNote, sortNum,brandId,factoryInImages,isException}))
      this.handleInOfStorage(dataList);
    },
    handleInOfStorage(dataList){
      if(dataList.some(item => !item.brandId)){
        this.$message.warning("请选择品牌")
        return;
      }
      if(!dataList.every(item => item.isException == 2 || item.factoryInImages.length)) {
        return this.$message.warning("请拍摄入库照片！")
      }

      this.confirmLoading = true;

      httpAction("/ShoeFactoryOrder/shoeFactoryOrder/expressageInOfStorage", dataList, "post").then((res) => {
        if (res.success) {
          this.$message.success(res.message);
          this.visible = false;
          this.form = [];
          this.$emit('ok');
          //打印水洗唛
          this.createWashedMark(res.result);
        }
      })

    },
    createWashedMark(data) {
      httpAction("/ShoeFactoryOrder/shoeFactoryOrder/expressageCreateWashedMark", data, "post").then((res) => {
        if (!res) {
          this.$message.warning(res.message)
          return
        }

        const file = res;
        this.printPic(file, "水洗唛")

        this.confirmLoading = false;
        this.visible = false  ;
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
        // LODOP.SET_LICENSES("","9598E18E55ADC63670695568858B9F880FD","","");
        let timestamp = parseInt(new Date().getTime() / 1000 + '');
        LODOP.PRINT_INIT("快递单入库打印水洗唛" + timestamp);
        LODOP.SET_PRINTER_INDEX(printerName);
        LODOP.SET_PRINT_PAGESIZE(1, "111mm", "20mm", "");
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
.box {
  /* 设置这个组件会出现错位问题 */
  height: 600px;
  overflow-y: scroll;
}
.content {
  font-size: 20px;
  color: #000000;
}
</style>