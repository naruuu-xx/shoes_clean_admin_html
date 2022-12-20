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
            <a-select
              v-model:value="selectedNote"
              mode="multiple"
              style="width: 100%;"
              placeholder="请选择"
              :options="noteOptions"
              :z-index="2000"
            >
            </a-select>
          </a-form-model-item>
        </a-col>
      </a-row>
    </a-spin>
  </j-modal>
</template>

<script>

import {downFile, httpAction} from "../../../../../api/manage";

export default {
  name: "ConfirmPrintModal",
  components: {},
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
    show(record) {
      this.visible = true;

      this.data = record;

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
      let selectedNotes = this.selectedNote;
      let selectedNoteString = "";
      for (let i = 0 ; i < this.selectedNote.length ; i ++) {
        selectedNoteString += selectedNotes[i] + "；";
      }

      selectedNoteString = selectedNoteString.substring(0, selectedNoteString.length - 1);

      this.handleInOfStorage(selectedNoteString);

    },
    handleInOfStorage(selectedNoteString){
      this.confirmLoading = true;

      this.data.selectedNote = selectedNoteString;

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
        // this.$message.success("入库成功");
        this.confirmLoading = false;
        this.selectedNote = [];
        this.visible = false  ;
      })
    },
    // 打印
    doPrint(val) {
      var ordonnance = document.getElementById(val).contentWindow;
      setTimeout(() => {
        // window.print()
        ordonnance.print();
      }, 0)
    }
  }
}
</script>

<style scoped>
.content {
  font-size: 20px;
  color: #000000;
}
</style>