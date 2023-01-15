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
      <div class="box" @scroll="scrollEvent">
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
      <a-row>
        <a-col :span="24">
          <a-form-model-item label="备注" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="note">
            <a-select
              v-model="item.selectedNote"
              mode="multiple"
              style="width: 100%;"
              placeholder="请选择"
              :options="noteOptions"
              :z-index="2000"
              :ref="`selectedNote${idx}`"
              @blur="selectedNoteBlur('blur',`selectedNote${idx}`)"
              @focus="selectedNoteBlur('focus',`selectedNote${idx}`)"
            >
            </a-select>
          </a-form-model-item>
        </a-col>
      </a-row>
      </div>
    </div>
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
      kuaidinum: "",
      data: {},
      imageList: [],
      showImageModal: false,
      shoeOrderInfo: false,
      clickedImage: "",
      confirmLoading: false,
      showInOfStoragePrintModal: false,
      selectedNote: [],
      noteOptions: [],
      dataList:[],
      selectedNoteKey: ''
    }
  },
  created() {
  },
  methods: {
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
    scrollEvent(e) {
      this.dataList.forEach((item,idx) => {
        this.$refs[`selectedNote${idx}`][0].blur()
      })
    },
    show(record) {
      this.visible = true;
      this.dataList = record.map(item => Object.assign({},item,{selectedNote: []}))

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
      let dataList = this.dataList.map(item => {
        return {
          orderId: item.orderId,
          selectedNote: item.selectedNote.join(';')
        }
      })
      this.handleInOfStorage(dataList);

    },
    handleInOfStorage(dataList){
      this.confirmLoading = true;
      downFile("/ShoeFactoryOrder/shoeFactoryOrder/expressageInOfStorage", dataList, "post").then((res) => {
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