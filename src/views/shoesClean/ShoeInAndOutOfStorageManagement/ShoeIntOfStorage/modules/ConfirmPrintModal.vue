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
      <a-row>
        <a-col :span="24">
          <a-form-model-item label="备注" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="note">
<!--            <a-select-->
<!--              v-model:value="selectedNote"-->
<!--              mode="multiple"-->
<!--              style="width: 100%;"-->
<!--              placeholder="请选择"-->
<!--              :options="noteOptions"-->
<!--              :z-index="2000"-->
<!--            >-->
<!--            </a-select>-->
            <a-input v-model.trim="data.note" placeholder="请输入备注"/>
          </a-form-model-item>
        </a-col>
      </a-row>
      <a-row>
        <a-col :span="24">
          <a-form-model-item label="品牌" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="brandId">

              <XfSelect
                :list="weekList"
                @change="checkedSelect"
                @changeList="changeSelect"
                v-model="data.brandId"
                :url='`/shoeBrand/list`'
              >
              </XfSelect>
          </a-form-model-item>
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
      this.visible = true;

      this.data = record;

    },
    handleCancel(){
      this.visible = false;
    },
    handleOk(){

      this.handleInOfStorage();

    },
    async handleInOfStorage(){
      this.confirmLoading = true;
      if (this.data.brandId==null||this.data.brandId==''){
        this.$message.warning("请选择品牌");
        this.confirmLoading = false;
        return;
      }else {
        let res = await httpAction("/shoeFactoryWasher/getWasher","", "get")
        if(!res.success){
          this.$message.warning(res.message)
          this.confirmLoading = false;
          return false;
        }
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
      }
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