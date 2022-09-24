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
            <a-form-model-item :labelCol="labelCol" :wrapperCol="wrapperCol" label="描述" prop="describe">
              <a-input v-model="model.describe" placeholder="请输入描述"></a-input>
            </a-form-model-item>
          </a-col>
          <a-col :span="24" >
            <a-form-model-item :labelCol="labelCol" :wrapperCol="wrapperCol" label="商品规格">
<!--              <a-table :columns="columns" :data-source="data" bordered>-->
<!--                <template-->
<!--                  v-for="col in ['skuTitle',  'price']"-->
<!--                  :slot="col"-->
<!--                  slot-scope="text, record, index"-->
<!--                  v-for="(item,idx) in model.skuTable"-->
<!--                >-->
<!--                  <div :key="col" >-->
<!--                    <a-input-->
<!--                      v-if="col == 'skuTitle'"-->
<!--                      v-model="model.skuTable[idx].skuTitle"-->
<!--                      :value="text"-->
<!--                      placeholder="请输入名称"-->
<!--                      style="margin: -5px 0"-->

<!--                    />-->
<!--                    <a-input-->
<!--                      v-if="col == 'price'"-->
<!--                      v-model="model.skuTable[idx].price"-->
<!--                      :value="text"-->
<!--                      placeholder="请输入价格"-->
<!--                      style="margin: -5px 0"-->

<!--                    />-->
<!--                  </div>-->
<!--                </template>-->
<!--                <template slot="operation" slot-scope="text, record, index">-->
<!--                  <div class="editable-row-operations">-->
<!--        <span>-->
<!--          <a-button-->
<!--            icon="plus"-->
<!--            shape="circle"-->
<!--            type="primary"-->
<!--            @click="() => addItem(record.key)"-->
<!--          />-->
<!--          <a-button-->
<!--            icon="minus"-->
<!--            shape="circle"-->
<!--            type="primary"-->
<!--            @click="() => deleteItem(record.key)"-->
<!--          />-->
<!--        </span>-->
<!--                  </div>-->
<!--                </template>-->
<!--              </a-table>-->

<!--              <a-table :columns="columns" :data-source="data" bordered>-->
<!--                <template-->
<!--                  v-for="(item, idx) in model.skuTable"-->

<!--                  slot-scope="text, record, index"-->

<!--                >-->
<!--                  <div >-->
<!--                    <a-input-->
<!--                      v-model="model.skuTable[idx].skuTitle"-->
<!--                      :value="text"-->
<!--                      placeholder="请输入名称"-->
<!--                      style="margin: -5px 0"-->
<!--                    />-->
<!--                    <a-input-->
<!--                      v-model="model.skuTable[idx].price"-->
<!--                      :value="text"-->
<!--                      placeholder="请输入价格"-->
<!--                      style="margin: -5px 0"-->
<!--                    />-->
<!--                  </div>-->
<!--                </template>-->
<!--                <template slot="operation" slot-scope="text, record, index">-->
<!--                  <div class="editable-row-operations">-->
<!--        <span>-->
<!--          <a-button-->
<!--            icon="plus"-->
<!--            shape="circle"-->
<!--            type="primary"-->
<!--            @click="() => addItem(record.key)"-->
<!--          />-->
<!--          <a-button-->
<!--            icon="minus"-->
<!--            shape="circle"-->
<!--            type="primary"-->
<!--            @click="() => deleteItem(record.key)"-->
<!--          />-->
<!--        </span>-->
<!--                  </div>-->
<!--                </template>-->
<!--              </a-table>-->
              <a-button class="editable-add-btn" @click="handleAdd">
                Add
              </a-button>
              <a-table bordered :data-source="model.skuTable" :columns="columns"
                        prop="skuTable">
                <template slot="skuTitle" slot-scope="text,index, record" prop="skuTitle">
                  <editable-cell :text="text" @change="onCellChange(record, 'skuTitle', $event)" />
                </template>
                <template slot = "price" slot-scope="text,index, record" prop="price">
                  <editable-cell :text="text" @change="onCellChange(record,'price',$event)" />
                </template>
                <template slot="operation" slot-scope="text, record">
                  <a-popconfirm
                    title="Sure to delete?"
                    @confirm="() => onDelete(record)"
                  >
                    <a href="javascript:;">Delete</a>
                  </a-popconfirm>
                </template>
              </a-table>


            </a-form-model-item>
          </a-col>

<!--          <div>-->
<!--               {{model.skuTable[0].price}}-->
<!--          </div>-->


          <a-col :span="24">
            <a-form-model-item :labelCol="labelCol" :wrapperCol="wrapperCol" label="主图" prop="images">
              <!--              <a-textarea v-model="model.images" rows="4" placeholder="请输入主图" />-->
              <j-image-upload v-model="model.images" :isMultiple="true" text="上传"></j-image-upload>
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

      <a-input :value="value" @change="handleChange" @pressEnter="check" @input="inputChange"/>
      <a-icon
        type="check"
        class="editable-cell-icon-check"
        @click="check"
      />
    </div>
    <div v-else class="editable-cell-text-wrapper">
      {{ value || ' ' }}
      <a-icon type="edit" class="editable-cell-icon" @click="edit"/>
    </div>
    </div>
  `,
  props: {
    text: String | Number,
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
  methods: {

    handleChange(e) {
      const value = e.target.value;
      this.value = value;
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
      },
      url: {
        list: "/shoes/shoeGoodsSku/list",
        add: '/shoes/shoeGoods/add',
        edit: '/shoes/shoeGoods/edit',
        queryById: '/shoes/shoeGoods/queryById'
      },


      count:0,

      columns : [
        {
          title: '规格名称',
          dataIndex: 'skuTitle',
          scopedSlots: { customRender: 'skuTitle' },
        },
        {
          title: '价格',
          dataIndex: 'price',
          scopedSlots: { customRender: 'price' },

        },
        {
          title: 'operation',
          dataIndex: 'operation',
          scopedSlots: { customRender: 'operation' },
        },
      ],



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
    this.modelDefault = JSON.parse(JSON.stringify(this.model))

  },
  methods: {

    // loadData(goodsId) {
    //   if(!this.url.list){
    //     this.$message.error("请设置url.list属性!")
    //     return
    //   }
    //  // var params = this.getQueryParams();//查询条件
    //   this.loading = true;
    //   console.log(typeof goodsId);
    //   const params = {goodsId: goodsId,};
    //
    //   getAction(this.url.list,params).then((res) => {
    //     if (res.success) {
    //       //update-begin---author:zhangyafei    Date:20201118  for：适配不分页的数据列表------------
    //           // console.log(res);
    //       this.dataSource = res.result.records||res.result;
    //       console.log("datasorce :       "+this.dataSource);
    //       if(res.result.total)
    //       {
    //         this.ipagination.total = res.result.total;
    //       }else{
    //         this.ipagination.total = 0;
    //       }
    //       //update-end---author:zhangyafei    Date:20201118  for：适配不分页的数据列表------------
    //     }else{
    //       this.$message.warning(res.message)
    //     }
    //   }).finally(() => {
    //     this.loading = false
    //   })
    // },

    // addItem(record){
    //   console.log(record)
    //   const len = record.skuTable.length;
    //   record.skuTable.splice(len+1, 0,{
    //     skuTitle:'',
    //     price:'',
    //   })
    // },
    //


    // deleteItem(record){
    //   if(record.skuTable.length == 1){
    //     return
    //   }
    //   const len = record.skuTable.length;
    //   record.skuTable.splice(len,1)
    // },

    exceptSkuId(value){
      if(value.key !== null){
        return value.key !== value
      }
    },

    onCellChange(record, dataIndex, value) {


      const dataSource = [... this.model.skuTable];
      console.log(dataSource[record])

      const target = dataSource[record];
      if (target) {
        target[dataIndex] = value;
        this.model.skuTable = dataSource;
      }
    },
    onDelete(record) {
      /**
       * 删除存在有bug，待修复。
       * @type {*[]}
       */
      const dataSource = [...this.model.skuTable];
      record.delFLag = 1;
      this.model.skuTable = dataSource.filter(item => item.skuId !== record.skuId);

    },
    handleAdd() {

      const dataSource  = this.model.skuTable;


      let skuids=  [];
      let count = 0;

      const newData = {
        skuId : count ,
        skuTitle: '',
        price:'',
      };
      this.model.skuTable = [...dataSource, newData];
      this.count = count + 1;
      console.log(this.model.skuTable);

    },


    add() {
      this.edit(this.modelDefault)
    },
    edit(record) {
     // this.loadData(record.goodsId);
     //
      this.model = Object.assign({}, record)
      this.visible = true
    },
    submitForm() {
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

  },
}
</script>

<style lang="less">
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