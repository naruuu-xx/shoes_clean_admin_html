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
        <div slot="detail">
          <a-row>
            <div class="tab">
              <a-radio-group v-model="tabValue" button-style="solid">
                <a-radio-button :value="item.value" v-for="(item, index) in tabs" :key="index">
                  {{item.label}}
                </a-radio-button>
              </a-radio-group>
            </div>
          <XfPhotograph ref="photograph" :photographImg="form[tabValue].factoryInImages"></XfPhotograph>
          </a-row>
          <a-form-model :ref="`form${idx}`" :model="mm" :rules="validatorRules" v-for="(mm,idx) in form" :key="idx">
            <a-row>
              <a-col :span="24">第{{idx+1}}双鞋</a-col>
              <a-col :span="24">
                <a-form-model-item label="快递单号" :labelCol="labelCol" :wrapperCol="wrapperCol">
                  {{mm.kuaidinum}}
                </a-form-model-item>
              </a-col>
              <a-col :span="24">
                <a-form-model-item label="订单编号" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="no">
                  <a-input v-model.trim="mm.no" placeholder="请输入订单编号" style="width: 200px"></a-input>
                </a-form-model-item>
              </a-col>
              <a-col :span="24">
                <a-form-model-item label="订单来源" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="platformId">
                  <a-input v-model.trim="mm.platformName" placeholder="请输入订单编号" style="width: 200px" disabled></a-input>
                  <!-- <a-select v-model="mm.platformId" style="width: 100px">
                    <a-select-option v-for="item in orderType" :value="item.value" :key="item.value">{{ item.name }}
                    </a-select-option>
                  </a-select> -->
                </a-form-model-item>
              </a-col>
              <a-col :span="24">
                <a-form-model-item label="商品名称" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="title">
                  <a-input v-model="mm.title" placeholder="请输入商品名称" style="width: 200px"></a-input>
                </a-form-model-item>
              </a-col>
              <a-col :span="24">
                <a-form-model-item label="商品规格" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="skuTitle">
                  <a-input v-model="mm.skuTitle" placeholder="请输入商品规格" style="width: 200px"></a-input>
                </a-form-model-item>
              </a-col>
              <a-col :span="24">
                <a-form-model-item label="手机号" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="phone">
                  <a-input v-model="mm.phone" placeholder="请输入手机号" style="width: 200px"></a-input>
                </a-form-model-item>
              </a-col>
              <a-col :span="24">
                <a-form-model-item label="姓名" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="name">
                  <a-input v-model="mm.name" placeholder="请输入姓名" style="width: 200px"></a-input>
                </a-form-model-item>
              </a-col>
              <a-col :span="24">
                <a-form-model-item label="地址" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="noteAddress">
                  <a-textarea v-model="mm.noteAddress" placeholder="请输入地址"></a-textarea>
                </a-form-model-item>
              </a-col>
              <a-col :span="24">
                <a-form-model-item label="备注" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="note">
                  <a-textarea v-model="mm.note" placeholder="请输入备注"></a-textarea>
                </a-form-model-item>
              </a-col>
              <a-col :span="24">
                <a-form-model-item label="品牌" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="brandId">
                  <XfSelect
                    :list="weekList"
                    @changeList="changeSelect"
                    v-model="mm.brandId"
                    :url='`/shoeBrand/list`'
                  >
                  </XfSelect>
                </a-form-model-item>
              </a-col>
            </a-row>

          </a-form-model>
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
        </div>

      </j-form-container>
    </a-spin>
  </j-modal>
</template>

<script>
import {downFile, httpAction} from "../../../../../api/manage";
import XfSelect from "@comp/Xf/XfSelect";
import XfPhotograph from "@comp/Xf/XfPhotograph";

export default {
  name: "ManualInOfStorage",
  components: {
    XfSelect,
    XfPhotograph
  },
  props: {
    //表单禁用
    disabled: {
      type: Boolean,
      default: false,
      required: false
    }
  },
  data() {
    let validatorNo = (rule, value, callback) => {
      let arr = this.form.filter(item => item.no === value);
      if(arr.length >1) {
        callback(new Error('订单编号重复'))
      } else {
        callback();
      }
    }
    return {
      visible: false,
      confirmLoading: false,
      model: {},
      orderType: [{"value": "2", "name": "候鸟洗衣"}, {"value": "3", "name": "干洗店"}, {"value": "4", "name": "供应商"}, {"value": "5", "name": "叼到家"}, {"value": "6", "name": "魔法阿嫲"}],
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
          { pattern: /^[0-9]*$/, message: '只能输入数字!'},
          { validator: validatorNo, trigger: ['change','blur'] }
        ],
        platformId: [
          {required: true, message: '请选择订单来源!'},
        ],
        phone: [
          {required: true, message: '请输入手机号!'},
          { pattern: /^1[3456789]\d{9}$/, message: '请输入正确的手机号码!'}
        ],
        name: [
          {required: true, message: '请输入姓名!'},
        ],
        noteAddress: [
          {required: true, message: '请输入地址!'},
        ],
        note: [
          {required: false, message: '请输入备注!'},
        ],
        brandId : [
          {required: true, message: '请选择品牌!'},
        ]
      },
      form:[],
      weekList:[],
      tabValue: 0
    }
  },
  computed: {
    formDisabled() {
      return this.disabled
    },
    tabs() {
      return this.form.map((item,idx) => ({
        label: `鞋子${idx+1}`,
        value: idx
      }))
    }
  },
  watch:{
    tabValue: {
      handler(val,oldValue) {
        let imgs = this.$refs.photograph.imgs
        this.form[oldValue].factoryInImages = imgs
      },
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
    show(data) {
      this.form = data.map(item => ({...item,factoryInImages: []}))
      this.visible = true;
    },
    handleCancel() {

      this.visible = false;
      this.form = [];
    },
    validate(obj) {
      return this.form.map((item,idx) => {
        let obj = this.$refs[`form${idx}`][0]
        return new Promise((resolve,reject) => {
          obj.validate(valid => {
            if(valid) {
              resolve(true)
            } else {
              reject(false)
            }
          })
        })
      })
    },
    handleSubmit(){
      Promise.all(this.validate()).then(res => {
        // let form = this.form.map(({name,no,note,noteAddress,orderId,phone,platformId,skuTitle,title}) => ({
        //     name,no,note,noteAddress,orderId,phone,platformId,skuTitle,title
        //   }))

          this.confirmLoading = true;
          this.form[this.tabValue].factoryInImages = this.$refs.photograph.imgs
          let data = this.form.map(async (item,idx) => {
            let factoryInImages = await this.$refs.photograph.uploadImgs(item.factoryInImages)
            return {
              ...item,
              factoryInImages
            }
              
          });
          Promise.all(data).then(res => {
            this.form = res
            let d = this.form.map(item => ({
              ...item,
              factoryInImages: item.factoryInImages.map(t => t.file)
            }))
            httpAction("/ShoeFactoryOrder/shoeFactoryOrder/batchManualInOfStorage",d, "post").then((res)=> {
              if (res.success) {
                this.$message.success(res.message);
                this.visible = false;
                this.form = [];
                this.$emit('ok');
                //打印水洗唛
                this.createWashedMark(res.result);
              } else {
                this.$message.warning(res.message);
              }
            }).finally(() => {
              this.confirmLoading = false;
            })
          }).catch(err => {
            this.confirmLoading = false
          })

          
      }).catch(err => {
        console.log(555,err);
      })
    },
    createWashedMark(data){
      downFile("/ShoeFactoryOrder/shoeFactoryOrder/batchCreateWashedMark", data, "post").then((res) => {
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

<style scoped lang="less">
.tab {
    height: 50px;
    display: flex;
    align-items: center;
  }
  .tab /deep/ .ant-radio-group {
    overflow-x: scroll;
    display: flex;
  }
</style>