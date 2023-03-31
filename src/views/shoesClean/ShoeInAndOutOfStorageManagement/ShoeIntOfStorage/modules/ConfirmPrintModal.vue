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
    handleInOfStorage(){
      this.confirmLoading = true;
      if (this.data.brandId==null||this.data.brandId==''){
        this.$message.warning("请选择品牌");
      }else {
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

      downFile("/ShoeFactoryOrder/shoeFactoryOrder/createWashedMark", data, "post").then((res) => {
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