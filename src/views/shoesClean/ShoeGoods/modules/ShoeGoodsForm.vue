<template>
  <a-spin :spinning="confirmLoading">
    <j-form-container :disabled="formDisabled">
      <a-form-model ref="form" slot="detail" :model="model" :rules="validatorRules">
        <a-row>
          <a-col :span="24">
            <a-form-model-item :labelCol="labelCol" :wrapperCol="wrapperCol" label="商品名称" prop="title">
              <a-input v-model="model.title" placeholder="请输入商品名称"></a-input>
            </a-form-model-item>
          </a-col>
          <a-col :span="24">
            <a-form-model-item label="商品分类" :labelCol="labelCol"
                               :wrapperCol="wrapperCol" prop="categoryId"
                               v-if="model.goodsId !== 1 && model.goodsId !== 2 && model.goodsId !== 28">
              <a-select
                placeholder="选择分类"
                v-model="model.categoryId"
              >
                <a-select-option  v-for="i in categoryList" :value="i.categoryId" :key="i.name">
                  {{i.name}}
                </a-select-option>
              </a-select>
            </a-form-model-item>
          </a-col>
          <a-col :span="24">
            <a-form-model-item :labelCol="labelCol" :wrapperCol="wrapperCol" label="描述" prop="describe">
              <a-input v-model="model.describe" placeholder="请输入描述"></a-input>
            </a-form-model-item>
          </a-col>
          <a-col :span="24" >
            <a-form-model-item :labelCol="labelCol" :wrapperCol="wrapperCol" label="商品规格">
              <a-button class="editable-add-btn" @click="handleAdd">
                添加规格
              </a-button>
              <a-table bordered :data-source="model.skuTable" :columns="columns"
                        prop="skuTable" :rowKey="model.uuid">
                <template slot="skuTitle" slot-scope="text,index, record" prop="skuTitle">
                  <editable-cell :text="text" @change="onCellChange(record, 'skuTitle', $event)" />
                </template>
                <template slot="price" slot-scope="text,index, record" prop="price">
                  <editable-cell type="number" :text="text" @change="onCellChange(record,'price',$event)" />
                </template>
                <template slot="originalPrice" slot-scope="text,index, record" prop="originalPrice">
                  <editable-cell type="number" :text="text" @change="onCellChange(record,'originalPrice',$event)" />
                </template>
                <template slot="skuImage" slot-scope="skuImage,index, record" prop="skuImage">
                  <j-image-upload v-model="skuImage" @change="onCellChange(record, 'skuImage',$event)" :isMultiple="false" text="上传"></j-image-upload>
                </template>


                <template slot="operation" slot-scope="text, record,index">
                  <a-popconfirm
                    title="确定要删除该规格么？"
                    @confirm="() => onDelete(index,record)"
                  >
                    <a href="javascript:;">删除</a>
                  </a-popconfirm>
                </template>
              </a-table>
            </a-form-model-item>
          </a-col>

<!--          <div>-->
<!--               {{model.skuTable[0].price}}-->
<!--          </div>-->


          <a-col :span="24">
            <a-form-model-item :labelCol="labelCol" :wrapperCol="wrapperCol" label="主图" prop="image">
              <!--              <a-textarea v-model="model.images" rows="4" placeholder="请输入主图" />-->
              <j-image-upload v-model="model.image" :isMultiple="false" text="上传"></j-image-upload>
            </a-form-model-item>
          </a-col>

          <a-col :span="24">
            <a-form-model-item :labelCol="labelCol" :wrapperCol="wrapperCol" label="轮播图" prop="banner">
              <!--              <a-textarea v-model="model.images" rows="4" placeholder="请输入主图" />-->
              <j-image-upload v-model="model.banner" :isMultiple="true" text="上传"></j-image-upload>
            </a-form-model-item>
          </a-col>
          <a-col :span="24">
            <a-form-model-item :labelCol="labelCol" :wrapperCol="wrapperCol" label="详情" prop="content">
              <!--              <a-textarea v-model="model.content" rows="4" placeholder="请输入详情" />-->
              <JEditor v-model="model.content" placeholder="请输入详情"></JEditor>
            </a-form-model-item>

          </a-col>
          <!--          <a-col :span="24">-->
          <!--            <a-form-model-item label="销量" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="sale">-->
          <!--              <a-input-number v-model="model.sale" placeholder="请输入销量" style="width: 100%" />-->
          <!--            </a-form-model-item>-->
          <!--          </a-col>-->
          <!--          <a-col :span="24">-->
          <!--            <a-form-model-item label="浏览量" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="pv">-->
          <!--              <a-input-number v-model="model.pv" placeholder="请输入浏览量" style="width: 100%" />-->
          <!--            </a-form-model-item>-->
          <!--          </a-col>-->
          <a-col :span="24">
            <a-form-model-item :labelCol="labelCol" :wrapperCol="wrapperCol" label="权重" prop="weight">
              <a-input-number v-model="model.weight" placeholder="请输入权重" style="width: 100%"/>
            </a-form-model-item>
          </a-col>
          <a-col :span="24">
            <a-form-model-item :labelCol="labelCol" :wrapperCol="wrapperCol" label="状态" prop="status">
              <!--              <a-input-number v-model="model.status" placeholder="请输入状态:0=下架,1=上架" style="width: 100%" />-->
              <j-switch v-model="model.status"></j-switch>
            </a-form-model-item>
          </a-col>

          <a-col :span="24">
            <a-form-model-item :labelCol="labelCol" :wrapperCol="wrapperCol" label="是否满减" prop="superpositionStatus">
              <a-radio-group name="radioGroup" v-model="model.superpositionStatus" @change="changeSu">
                <a-radio :value="1">
                  是
                </a-radio>
                <a-radio :value="0">
                  否
                </a-radio>
              </a-radio-group>
            </a-form-model-item>
          </a-col>

          <a-col :span="24" v-if="model.superpositionStatus == 1">
            <a-form-model-item :labelCol="labelCol" :wrapperCol="wrapperCol" label="是否与优惠券叠加优惠" prop="compatibilityStatus">
              <div>
                <a-radio-group name="radioGroup" v-model="model.compatibilityStatus">
                <a-radio :value="1">
                  是
                </a-radio>
                <a-radio :value="0">
                  否
                </a-radio>
              </a-radio-group>
              </div>
              <a-button type="primary" @click="fullDiscountAdd">新增</a-button>
              <a-table v-if="fullDiscountList.length" bordered :data-source="fullDiscountList" :columns="fullDiscountColumns" :rowKey="model.uuid" size="small" :pagination="false">
                <template slot="num" slot-scope="text,record,index">
                  <a-input-number style="width: 80px;" @blur="numBlur(index,record.num)" v-model="record.num" placeholder="请输双数" @change="v => record.num = isNaN(parseInt(v)) ? 2 : parseInt(v)" :min="2" />
                </template>
                <template slot="reduce" slot-scope="text,record,index">
                  <a-input-number style="width: 120px;" v-model="record.reduce" placeholder="请输满减金额(元)" @change="v => record.reduce = isNaN(parseInt(v)) ? 0 : parseFloat(v).toFixed(2)" :min="0" />
                </template>
                <template slot="operation" slot-scope="text,record,index">
                  <a href="javascript:;" style="color: red" @click="fullDiscountList.splice(index,1)" v-if="fullDiscountList.length > 1">删除</a>
                </template>
              </a-table>
            </a-form-model-item>
          </a-col>

          <a-col :span="24">
            <a-form-model-item label="附加服务项" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="additionalId" >
              <a-select
                mode="multiple"
                show-search
                placeholder="选择或搜索需要绑定的用户"
                option-filter-prop="children"
                style="width: 200px"
                :filter-option="(input, option) => option.componentOptions.children[0].text.toLowerCase().indexOf(input.toLowerCase()) >= 0"
                v-model="model.additionalIds"
              >
                <a-select-option  v-for="i in additionalList" :value="i.additionalId" :key="i.additionalId">
                  {{i.name}}
                </a-select-option>
              </a-select>
            </a-form-model-item>
          </a-col>

        </a-row>

      </a-form-model>
    </j-form-container>
  </a-spin>
</template>

<script>
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
      },
      labelCol: {
        xs: { span: 24 },
        sm: { span: 5 },
      },
      wrapperCol: {
        xs: { span: 24 },
        sm: { span: 16 },
      },
      confirmLoading: false,
      validatorRules: {
        title: [
          { required: true, message: '请输入商品名称!' },
        ],
        content: [
          { required: true, message: '请输入详情!' },
        ],
        weight: [
          { required: true, message: '请输入权重!' },
        ],
        goodsSku: [
          { required: true, message: '请填写商品规格！' },
        ],
        skuTitle: [
          { required: true, message: '请填写规格名称!' },
        ],
        price: [
          { required: true, message: '测' },
        ],
        status: [
          { required: true, message: '请输入状态' },
        ],
        superpositionStatus: [
          { required: true, message: '请选择是否满减' },
        ],
        compatibilityStatus: [
          { required: true, message: '请选择是否优惠券叠加优惠' },
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
          title: '规格名称',
          dataIndex: 'skuTitle',
          scopedSlots: { customRender: 'skuTitle' },
        },
        {
          title: '规格图片',
          dataIndex:'skuImage',
          scopedSlots: {customRender: 'skuImage'},
        },
        {
          title: '原价格',
          dataIndex: 'originalPrice',
          scopedSlots: { customRender: 'originalPrice' },

        },
        {
          title: '优惠价格',
          dataIndex: 'price',
          scopedSlots: { customRender: 'price' },

        },
        {
          title: '操作',
          dataIndex: 'operation',
          scopedSlots: { customRender: 'operation' },
        },
      ],

      additionalList:[],
      fullDiscountColumns : [
        {
          title: '双数',
          dataIndex: 'num',
          scopedSlots: { customRender: 'num' },
          align: 'center'
        },
        {
          title: '满减金额(元)',
          dataIndex:'reduce',
          scopedSlots: {customRender: 'reduce'},
          align: 'center'
        },
        {
          title: '操作',
          dataIndex: 'operation',
          scopedSlots: { customRender: 'operation' },
          align: 'center'
        },
      ],
      fullDiscountList:[]


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
    changeSu(val) {
      if(this.model.superpositionStatus == 0) {
        // this.fullDiscountList = []
      } else {
        let uuid = (Math.random() + new Date().getTime()).toString(32).slice(0,8);
        this.fullDiscountList = this.fullDiscountList.length ? this.fullDiscountList : [
          {
            num: '',
            reduce: 0,
            uuid
          }
        ]
      }
    },
    fullDiscountAdd() {
      const dataSource  = this.model.skuTable;
      let uuid = (Math.random() + new Date().getTime()).toString(32).slice(0,8);

      const newData = {
        num: '',
        reduce: 0,
        uuid
      };
      this.fullDiscountList.push(newData)
      console.log(this.fullDiscountList);

    },
    numBlur(idx,val) {
      let list = [...this.fullDiscountList].map(({num}) => num)
      list.splice(idx,1)
      if(list.findIndex(item => item == val) != -1) {
        this.$message.error('已有相同鞋数!')
      }
    },
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
      const dataSource = [... this.model.skuTable];


      const target = dataSource[record];
      if (target) {
        target[dataIndex] = value;
        this.model.skuTable = dataSource;
      }
    },
    onDelete(index,record) {
      /**
       * 删除存在有bug，待修复。
       * @type {*[]}
       */
      this.model.skuTable.splice(index,1)
      console.log(888,this.model.skuTable);

    },
    handleAdd() {

      const dataSource  = this.model.skuTable;


      let skuids=  [];
      let count = 0;
      let uuid = (Math.random() + new Date().getTime()).toString(32).slice(0,8);

      const newData = {
        skuId : count,
        skuTitle: '',
        price:'',
        uuid
      };
      this.model.skuTable = [...dataSource, newData];
      this.count = count + 1;

    },


    add() {
      this.edit(this.modelDefault)
    },
    edit(record) {
     // this.loadData(record.goodsId);
     //
     this.fullDiscountList = record.superpositionReduce || []
      this.model = Object.assign({}, record)
      this.model.skuTable = this.model.skuTable.map(item => {
        return Object.assign({}, item,{uuid: (Math.random() + new Date().getTime()).toString(32).slice(0,8)})
      })
      this.visible = true
    },
    submitForm() {
      if(!this.isSubmitSkuTable()) {
        return
      }
      const that = this
      let numObj = {}
      for (let index = 0; index < this.fullDiscountList.length; index++) {
        const num = this.fullDiscountList[index].num;
        if (!numObj[num]) {
          numObj[num] = true
        } else {
          this.$message.error('鞋子双数不能重复')
          return;
        }
        
      }
      let superpositionReduce = this.fullDiscountList.map(({num,reduce}) => ({num,reduce}))
      let form = Object.assign({},this.model,{superpositionReduce})
      console.log(888,form);
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
          httpAction(httpurl, form, method).then((res) => {
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