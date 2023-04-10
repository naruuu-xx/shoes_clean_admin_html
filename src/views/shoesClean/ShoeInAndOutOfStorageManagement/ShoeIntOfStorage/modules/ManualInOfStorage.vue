<template>
  <j-modal
    title="手工录单"
    :width="600"
    :visible="visible"
    @cancel="handleCancel"
    :footer="null"
    wrapClassName="full-modal">
    <a-spin :spinning="confirmLoading">
      <j-form-container :disabled="formDisabled">
        <a-form-model ref="form" :model="model" :rules="validatorRules" slot="detail">
          <a-row>
            <a-col :span="24">
              <a-form-model-item label="订单编号" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="no">
                <a-input v-model.trim="model.no" placeholder="请输入订单编号" style="width: 200px"></a-input>
              </a-form-model-item>
            </a-col>
            <a-col :span="24">
              <a-form-model-item label="订单类型" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="platformId">
                <a-select v-model="model.platformId" style="width: 200px">
                  <a-select-option v-for="item in orderType" :value="item.value.toString()" :key="item.value">{{ item.name }}
                  </a-select-option>
                </a-select>
              </a-form-model-item>
            </a-col>
            <a-col :span="24">
              <a-form-model-item label="商品名称" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="title">
                <a-input v-model="model.title" placeholder="请输入商品名称" style="width: 200px"></a-input>
              </a-form-model-item>
            </a-col>
            <a-col :span="24">
              <a-form-model-item label="商品规格" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="skuTitle">
                <a-input v-model="model.skuTitle" placeholder="请输入商品规格" style="width: 200px"></a-input>
              </a-form-model-item>
            </a-col>
            <a-col :span="24">
              <a-form-model-item label="姓名" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="name">
                <a-input v-model="model.name" placeholder="请输入姓名" style="width: 200px"></a-input>
              </a-form-model-item>
            </a-col>
            <a-col :span="24">
              <a-form-model-item label="手机号" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="phone">
                <a-input v-model="model.phone" placeholder="请输入手机号" style="width: 200px"></a-input>
              </a-form-model-item>
            </a-col>
            <a-col :span="24">
              <a-form-model-item label="地址" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="noteAddress">
                <a-textarea v-model="model.noteAddress" placeholder="请输入地址"></a-textarea>
              </a-form-model-item>
            </a-col>
            <a-col :span="24">
              <a-form-model-item label="备注" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="note">
                <a-textarea v-model="model.note" placeholder="请输入备注"></a-textarea>
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
                  v-model="model.brandId"
                  :url='`/shoeBrand/list`'
                >
                </XfSelect>
              </a-form-model-item>
            </a-col>
          </a-row>
          <a-row>
            <a-col :span="24">
              <a-col :span="6"></a-col>
              <a-col :span="6">
                <a-button type="primary" @click="handleSubmit">确认</a-button>
              </a-col>
              <a-col :span="6">
                <a-button @click="handleCancel">取消</a-button>
              </a-col>
              <a-col :span="6"></a-col>
            </a-col>
          </a-row>
        </a-form-model>
      </j-form-container>
    </a-spin>
  </j-modal>
</template>

<script>
import {downFile, httpAction} from "../../../../../api/manage";
import XfSelect from "@comp/Xf/XfSelect";

export default {
  name: "ManualInOfStorage",
  components: {XfSelect},
  props: {
    //表单禁用
    disabled: {
      type: Boolean,
      default: false,
      required: false
    }
  },
  data() {
    return {
      weekList:[],
      visible: false,
      confirmLoading: false,
      model: {},
      orderType: [],
      labelCol: {
        xs: {span: 24},
        sm: {span: 5},
      },
      wrapperCol: {
        xs: {span: 24},
        sm: {span: 16},
      },
      validatorRules: {
        no: [
          {required: true, message: '请输入订单编号!'},
          { pattern: /^[0-9]*$/, message: '只能输入数字!'}
        ],
        platformId: [
          {required: true, message: '请选择订单类型!'},
        ],
        phone: [
          {required: true, message: '请输入手机号!'},
          { pattern: /^1[3456789]\d{9}$/, message: '请输入正确的手机号码!'}
        ],
        noteAddress: [
          { required: true, message: '请输入地址!' }
        ],
        brandId: [
          { required: true, message: '请输入品牌!' }
        ],
        name: [
          {required: true, message: '请输入姓名!'},
        ],
        note: [
          {required: false, message: '请输入备注!'},
        ]
      },
    }
  },
  computed: {
    formDisabled() {
      return this.disabled
    },
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
    show() {
      httpAction("/shoeFactoryWasher/getWasher","", "get").then((res) =>{
      if(!res.success){
        this.$message.warning(res.message)

      }
    })
      this.visible = true;
      this.model = {};

      let url = "/ShoeFactoryOrder/shoeFactoryOrder/getFactoryPlatformList?type=" + 2;

      httpAction(url, null, "get").then((res) => {
        this.orderType = res.result.map((item, index, arr) => {
          let c = {value : item.platformId, name : item.name}
          return c;
        })
      })

    },
    handleCancel() {
      this.visible = false;
      this.model = {};
    },
     handleSubmit(){
      const that = this;

      let no = this.model.no;

      this.$refs.form.validate( valid => {
        if (valid) {
          that.confirmLoading = true;



          httpAction("/ShoeFactoryOrder/shoeFactoryOrder/manualInOfStorage",that.model, "post").then((res)=> {
            if (res.success) {
              that.$message.success(res.message);
              this.visible = false;
              this.model = {};
              this.$emit('ok');

              //打印水洗唛
              this.createWashedMark(no);
            } else {
              that.$message.warning(res.message);
            }
          }).finally(() => {
            that.confirmLoading = false;
          })
        }
      })
    },
    createWashedMark(no){
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

</style>