<template>
  <a-spin :spinning="confirmLoading">
    <j-form-container :disabled="formDisabled">
      <a-form-model ref="form" slot="detail" :model="model" :rules="validatorRules">
        <a-row>
          <a-col :span="24">
            <a-form-model-item :labelCol="labelCol" :wrapperCol="wrapperCol" label="产品名称" prop="title">
              <a-input v-model="model.title" placeholder="请输入产品名称"></a-input>
            </a-form-model-item>
          </a-col>
          <a-col :span="24">
            <a-form-model-item :labelCol="labelCol" :wrapperCol="wrapperCol" label="产品描述" prop="describe">
              <a-input v-model="model.describe" placeholder="请输入描述"></a-input>
            </a-form-model-item>
          </a-col>
          <a-col :span="24" >
            <a-form-model-item :labelCol="labelCol" :wrapperCol="wrapperCol" label="产品规格" >
              <a-button class="editable-add-btn" @click="handleAdd" type="primary">
                新增
              </a-button>
              <a-table bordered :data-source="model.skuTable" :columns="columns" :rowKey="model.uuid" :pagination="false">
                <template slot="goodId" slot-scope="text,record,index">
                  <a-select v-model="record.goodId" style="width: 100%" >
                    <a-select-option value="jack">
                      Jack
                    </a-select-option>
                  </a-select>
                </template>
                <template slot="skuId" slot-scope="text,record,index">
                  <a-select v-model="record.skuId" style="width: 100%" >
                    <a-select-option value="jack">
                      Jack
                    </a-select-option>
                  </a-select>
                </template>
                <template slot="num" slot-scope="text,record,index">
                  <a-input-number style="width: 100%"  v-model="record.num" placeholder="请输入双数" @change="v => record.num = isNaN(parseInt(v)) ? 1 : parseInt(v)" :min="1" />
                </template>
                <template slot="price" slot-scope="text,record,index">
                  <a-input-number style="width: 100%"  v-model="record.price" placeholder="请输入秒杀价" @change="v => record.price = isNaN(parseInt(v)) ? 0.01 : parseFloat(parseFloat(v).toFixed(2))" :min="0.01" />
                </template>


                <template slot="operation" slot-scope="text, record,index">
                  <a-popconfirm
                    title="确定要删除该规格么？"
                    @confirm="() => onDelete(index,record)"
                  >
                    <a href="javascript:;" style="color: red">删除</a>
                  </a-popconfirm>
                </template>
              </a-table>
            </a-form-model-item>
          </a-col>

          <a-col :span="24">
            <a-form-model-item :labelCol="labelCol" :wrapperCol="wrapperCol" label="产品库存" prop="inventory">
              <a-input-number style="width: 100%" v-model="model.inventory" :min="1" @change="v => model.inventory = isNaN(parseInt(v)) ? 1 : parseInt(v)" />
            </a-form-model-item>
          </a-col>

          <a-col :span="24">
            <a-form-model-item :labelCol="labelCol" :wrapperCol="wrapperCol" label="每人限购数量" prop="purchaseMotivation">
              <a-input-number style="width: 100%" v-model="model.purchaseMotivation" :min="1" @change="v => model.purchaseMotivation = isNaN(parseInt(v)) ? 1 : parseInt(v)" />
            </a-form-model-item>
          </a-col>

          <a-col :span="24">
            <a-form-model-item :labelCol="labelCol" :wrapperCol="wrapperCol" label="主图" prop="image">
              <j-image-upload v-model="model.image" :isMultiple="false" text="上传"></j-image-upload>
            </a-form-model-item>
          </a-col>

          <a-col :span="24">
            <a-form-model-item :labelCol="labelCol" :wrapperCol="wrapperCol" label="轮播图" prop="banner">
              <j-image-upload v-model="model.banner" :isMultiple="true" text="上传"></j-image-upload>
            </a-form-model-item>
          </a-col>

          <a-col :span="24">
            <a-form-model-item :labelCol="labelCol" :wrapperCol="wrapperCol" label="详情" prop="content">
              <JEditor v-model="model.content" placeholder="请输入详情"></JEditor>
            </a-form-model-item>
          </a-col>

          <a-col :span="24">
            <a-form-model-item :labelCol="labelCol" :wrapperCol="wrapperCol" label="秒杀时间" prop="time">
              <a-range-picker v-model="model.time" :format="dateFormat" />
            </a-form-model-item>
          </a-col>
          
          <a-col :span="24">
            <a-form-model-item :labelCol="labelCol" :wrapperCol="wrapperCol" label="状态" prop="status">
              <j-switch v-model="model.status"></j-switch>
            </a-form-model-item>
          </a-col>

        </a-row>

      </a-form-model>
    </j-form-container>
  </a-spin>
</template>

<script>
import moment from 'moment';
import { getAction, httpAction } from '@/api/manage'
import { JeecgListMixin } from '@/mixins/JeecgListMixin'
import { mixinDevice } from '@/utils/mixin'
import signMd5Utils from '@/utils/encryption/signMd5Utils'
import { axios } from '@/utils/request'


const EditableCell = {
  template: `
    <div class="editable-cell">
    <div v-if="editable" class="editable-cell-input-wrapper">
      <a-input :value="value" @change="handleChange" @pressEnter="check" @input="inputChange" v-if="type == 'text'" @blur="editable = false"/>
      <a-input-number v-model="value" :min="0" @pressEnter="check" @change="handleChange" v-else @blur="editable = false" />
    </div>
    <div v-else class="editable-cell-text-wrapper" @click="edit">
      {{ value || ' ' }}
      <a-icon type="edit" class="editable-cell-icon"/>
    </div>
    </div>
  `,
  props: {
    text: String | Number,
    type:{
      type: String,
      default: 'text'
    }
  },
  model: {
    prop: "value",
    event: "input",
  },
  data() {
    return {
      value: this.text,
      editable: false,
    };
  },
  watch:{
    text(value) {
      this.value = value;
    }
  },
  methods: {

    handleChange(e) {
      const value = this.type == 'text' ? e.target.value : e
      console.log(6666,value);
      this.value = value;
      
      this.$emit('change', this.value);
    },
    inputChange(e){
        this.$emit("input", e.target.value);
    },
    check() {
      this.editable = false;
      this.$emit('change', this.value);
    },
    edit() {
      this.editable = true;
    },
  },
};




// for(let i in model.skuTable){
//   data.push(model.skuTable[i]);
// }



export default {
  name: 'ShoeGoodsForm',
  mixins: [JeecgListMixin, mixinDevice],
  components: {
    EditableCell,
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

    return {
      key: 0,

      editingKey: '',

      model: {
        skuTable:[],
        time:[moment('2023-5-20'),moment('2023-5-22')]
      },
      labelCol: {
        xs: { span: 24 },
        sm: { span: 4 },
      },
      wrapperCol: {
        xs: { span: 24 },
        sm: { span: 20 },
      },
      confirmLoading: false,
      validatorRules: {
        title: [
          { required: true, message: '请输入商品名称!' },
        ],
        content: [
          { required: true, message: '请输入详情!' },
        ],
        status: [
          { required: true, message: '请输入状态' },
        ],
      },
      url: {
        list: "/shoes/shoeGoodsSku/list",
        add: '/shoes/shoeGoods/add',
        edit: '/shoes/shoeGoods/edit',
        queryById: '/shoes/shoeGoods/queryById'
      },
      categoryList:[],


      count:0,

      columns : [
        {
          title: '商品',
          dataIndex: 'goodId',
          scopedSlots: { customRender: 'goodId' },
          align: 'center',
          width:'180px'
        },
        {
          title: '商品规格',
          dataIndex:'skuId',
          scopedSlots: {customRender: 'skuId'},
          align: 'center',
          width:'180px'
        },
        {
          title: '双数',
          dataIndex: 'num',
          scopedSlots: { customRender: 'num' },
          align: 'center',
          width:'100px'
        },
        {
          title: '秒杀价',
          dataIndex: 'price',
          scopedSlots: { customRender: 'price' },
          align: 'center',
          width:'100px'
        },
        {
          title: '操作',
          dataIndex: 'operation',
          scopedSlots: { customRender: 'operation' },
          align: 'center',
        },
      ],

      additionalList:[],
      dateFormat:"YYYY-MM-DD"


    }
  },
  computed: {

    formDisabled() {
      return this.disabled
    },
  },
  created() {
    //备份model原始值
    //  this.loadData(this.model.goodsId);
    this.getCategoryList();
    this.getAdditonalList();
    this.modelDefault = JSON.parse(JSON.stringify(this.model))

  },
  methods: {

    // 是否可用提交规格
    isSubmitSkuTable() {
      let status = true
      const dataSource = [... this.model.skuTable];
      dataSource.forEach((item,idx) => {
        if(!item.originalPrice || !item.price || !item.skuTitle || !item.skuImage ) {
          this.$message.warning(`第${idx+1}个规格没有填写完整，无法保存`)
          dataSource.length = 0
          status = false
        }
      });
      return status
    },

    exceptSkuId(value){
      if(value.key !== null){
        return value.key !== value
      }
    },

    onCellChange(record, dataIndex, value) {

      console.log(999,value);
      const dataSource = [... this.model.skuTable];


      const target = dataSource[record];
      if (target) {
        target[dataIndex] = value;
        this.model.skuTable = dataSource;
      }
    },
    onDelete(index) {
      this.model.skuTable.splice(index,1)
    },
    handleAdd() {
      let uuid = (Math.random() + new Date().getTime()).toString(32).slice(0,8);

      const newData = {
        skuId : '',
        num: '',
        goodId: '',
        price:'',
        uuid
      };
      this.model.skuTable.push(newData)

    },


    add() {
      this.edit(this.modelDefault)
    },
    edit(record) {
     // this.loadData(record.goodsId);
     //
      this.model = Object.assign({}, record)
      this.model.skuTable = this.model.skuTable.map(item => {
        return Object.assign({}, item,{uuid: (Math.random() + new Date().getTime()).toString(32).slice(0,8)})
      })
      this.visible = true
    },
    submitForm() {
      console.log(77,this.model);
      if(!this.isSubmitSkuTable()) {
        return
      }
      const that = this
      console.log(this.model)
      // 触发表单验证
      this.$refs.form.validate(valid => {
        if (valid) {
          that.confirmLoading = true
          let httpurl = ''
          let method = ''
          if (!this.model.goodsId) {
            httpurl += this.url.add
            method = 'post'
          } else {
            httpurl += this.url.edit
            method = 'put'
          }
          httpAction(httpurl, this.model, method).then((res) => {
            if (res.success) {
              that.$message.success(res.message)
              that.$emit('ok')
            } else {
              that.$message.warning(res.message)
            }
          }).finally(() => {
            that.confirmLoading = false
          })
        }

      })

    },
    getCategoryList(){
      httpAction("/shoes/shoeGoods/categoryList","","get").then((res)=>{
        if(res){
          this.categoryList = res.result;
        }
      })
    },
    getAdditonalList(){
      httpAction("/shoes/shoeAdditional/queryList","", "get").then((res)=>{
        if(res){
          console.log(res.result);
          this.additionalList = res.result;

        }
      })
    },

  },
}
</script>

<style lang="less">
.ant-input-number-handler-wrap {
    display: none
}

.editable-row-operations a {
  margin-right: 8px;
}

.editable-cell {
  position: relative;
}

.editable-cell-input-wrapper,
.editable-cell-text-wrapper {
  padding-right: 24px;
}

.editable-cell-text-wrapper {
  padding: 5px 24px 5px 5px;
  cursor: pointer;
}

.editable-cell-icon,
.editable-cell-icon-check {
  position: absolute;
  right: 0;
  width: 20px;
  cursor: pointer;
}

.editable-cell-icon {
  line-height: 18px;
  display: none;
}

.editable-cell-icon-check {
  line-height: 28px;
}

.editable-cell:hover .editable-cell-icon {
  display: inline-block;
}

.editable-cell-icon:hover,
.editable-cell-icon-check:hover {
  color: #108ee9;
}

.editable-add-btn {
  margin-bottom: 8px;
}
</style>