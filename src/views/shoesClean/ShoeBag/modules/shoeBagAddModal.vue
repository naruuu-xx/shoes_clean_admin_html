<template>
  <j-modal
    :title="title"
    :width="width"
    :visible="visible"
    switchFullscreen
    @cancel="handleCancel"
    cancelText="关闭"
    :footer="null">
    <div>
      <a-row>
        <a-form layout="inline" :model="dataForm">
          <a-form-item label="新增袋子数">
            <a-input-number v-model:value="dataForm.bagNum" :defaultValue="defaultValue" :min="1" placeholder="输入数量" style="width: 100px"/>
          </a-form-item>
          <a-form-item :wrapper-col="buttonItemLayout.wrapperCol">
            <a-button type="primary" @click="onSubmit">生成编码</a-button>
          </a-form-item>
        </a-form>
      </a-row>
      <a-row style="margin-top: 10px;">
        <a-col span="24">
          <p style="font-size: 16px; color: #000000">袋子编码：</p>
          <a-checkbox
            v-model:checked="checkAll"
            :indeterminate="indeterminate"
            @change="onCheckAllChange($event)"
          >
            全选
          </a-checkbox>
        </a-col>
      </a-row>
      <a-row>
        <a-checkbox-group v-model:value="selectedBagNum">
          <a-row>
            <a-col :span="24">
              <a-checkbox v-for="(item, index) in bagNumList" :value="item" :key="item" style="margin: 10px 40px;font-size: 18px;color: #000000">{{item}}</a-checkbox>
            </a-col>
          </a-row>
        </a-checkbox-group>
      </a-row>
      <div  style="margin-left: 320px">
        <a-button type="primary" @click="onPrint" v-show="showPrintButton">打印</a-button>
      </div>
    </div>

  </j-modal>
</template>

<script>
import {downFile, httpAction} from "../../../../api/manage";

export default {
  name: "shoeBagAddModal",
  data() {
    return {
      title: '新增袋子',
      width: 800,
      visible: false,
      dataForm: {},
      defaultValue: 1,
      buttonItemLayout: {
        wrapperCol: {
          span: 14,
          offset: 4,
        }
      },
      bagNumList: [],
      selectedBagNum: [],
      checkAll: false,
      indeterminate: true,
      showPrintButton: false,
    }
  },
  created() {
  },
  methods: {
    show() {
      this.visible = true;
    },
    handleCancel() {
      this.visible = false;
      this.dataForm = {};
      this.selectedBagNum = [];
      this.bagNumList = [];
    },
    onSubmit(){
      let that = this;
      let bagNum = this.dataForm.bagNum;
      this.selectedBagNum = [];
      if (bagNum === null) {
        this.$message.warning("请输入数字");
        return false;
      }
      httpAction("/ShoeBag/shoeBag/createBagCode", this.dataForm, "post").then((res) => {
        if (res.success) {
          this.bagNumList = res.result;
          this.showPrintButton = true;
        } else {
          that.$message.error(res.message);
        }
      })
    },
    onCheckAllChange(e){
      if (e.target.checked) {
        this.selectedBagNum = this.bagNumList;
        return false;
      } else {
        this.selectedBagNum = [];
        this.indeterminate = false;
      }
    },
    onPrint(){
      // console.log(this.selectedBagNum.length);
      // console.log(this.selectedBagNum);
      if (this.selectedBagNum.length < 1) {
        this.$message.warning("请选择需要打印的袋子编码！");
      } else {
        let selectedBagNumString = "";
        for (let i = 0 ; i < this.selectedBagNum.length;  i ++) {
          selectedBagNumString += this.selectedBagNum[i] + ",";
        }

        let data = {
          "selectedBagNum": selectedBagNumString
        }
        // console.log(data);
        downFile("/ShoeBag/shoeBag/printBagCode", data, "post").then((res) => {
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

          //关闭弹窗，初始化数据，刷新列表
          this.visible = false;
          this.dataForm = {};
          this.selectedBagNum = [];
          this.bagNumList = [];

          this.$emit("ok");
        })
      }
    },
    // 打印
    doPrint(val) {
      var ordonnance = document.getElementById(val).contentWindow;
      setTimeout(() => {
        // window.print()
        ordonnance.print()
        this.pdfLoading = false
      }, 100)
    },
  }
}
</script>

<style scoped>

</style>