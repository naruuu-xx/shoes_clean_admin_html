<template>
  <a-spin :spinning="confirmLoading">
    <j-form-container :disabled="formDisabled">
      <a-form-model ref="form" slot="detail" :model="model" :rules="validatorRules">
        <a-row>
          <a-col :span="24">
            <a-form-model-item :labelCol="labelCol" :wrapperCol="wrapperCol" label="产品名称" prop="title">
              <a-input :disabled="disabled" v-model="model.title" placeholder="请输入产品名称"></a-input>
            </a-form-model-item>
          </a-col>
          <a-col :span="24">
            <a-form-model-item :labelCol="labelCol" :wrapperCol="wrapperCol" label="产品描述" prop="describe">
              <a-input :disabled="disabled" v-model="model.describe" placeholder="请输入描述"></a-input>
            </a-form-model-item>
          </a-col>
          <a-col :span="24" >
            <a-form-model-item :labelCol="labelCol" :wrapperCol="wrapperCol" label="产品规格" >
              <a-button :disabled="disabled" class="editable-add-btn" @click="addProduct" type="primary">
                新增
              </a-button>
              <a-table bordered :data-source="goodList" :columns="columns" rowKey="uuid" :pagination="false">
                <template slot="goodsId" slot-scope="text,record,idx">
                  <a-select :disabled="disabled" showSearch :filterOption="((input,option) => option.componentOptions.children[0].text.toLowerCase().idxOf(input.toLowerCase()) >= 0)" optionFilterProp="value" v-model="record.goodsId" style="width: 140px" :options="goodOptions" @change="changeGood($event,idx)">
                  </a-select>
                </template>
                <template slot="skuId" slot-scope="text,record,idx">
                  <!--  -->
                  <a-select ref="skuSelect" v-model="record.skuId" :disabled="disabled || record.disabled" style="width: 140px" :options="skuOptions"  @focus="onClickSku(idx)" @change="$refs.skuSelect.blur()">
                  </a-select>
                </template>
                <template slot="num" slot-scope="text,record,idx">
                  <a-input-number :disabled="disabled" style="width: 100%"  v-model="record.num" placeholder="请输入双数" @change="v => record.num = isNaN(parseInt(v)) ? 1 : parseInt(v)" :min="1" />
                </template>
                <template slot="seckillPrice" slot-scope="text,record,idx">
                  <a-input-number :disabled="disabled" style="width: 100%"  v-model="record.seckillPrice" placeholder="请输入秒杀价" @change="v => record.seckillPrice = isNaN(parseInt(v)) ? 0.01 : parseFloat(parseFloat(v).toFixed(2))" :min="0.01" />
                </template>


                <template slot="operation" slot-scope="text, record,idx">
                    <a href="javascript:;" style="color: red" @click="onDel(idx,record)">删除</a>
                </template>
              </a-table>
            </a-form-model-item>
          </a-col>

          <a-col :span="24">
            <a-form-model-item :labelCol="labelCol" :wrapperCol="wrapperCol" label="产品剩余库存" prop="inventory">
              <a-input-number :disabled="disabled" style="width: 100%" v-model="model.inventory" :min="1" @change="v => model.inventory = isNaN(parseInt(v)) ? 1 : parseInt(v)" />
            </a-form-model-item>
          </a-col>

          <a-col :span="24">
            <a-form-model-item :labelCol="labelCol" :wrapperCol="wrapperCol" label="每人限购数量" prop="limitNum">
              <a-input-number :disabled="disabled" style="width: 100%" v-model="model.limitNum" :min="1" @change="v => model.limitNum = isNaN(parseInt(v)) ? 1 : parseInt(v)" />
            </a-form-model-item>
          </a-col>

          <a-col :span="24">
            <a-form-model-item :labelCol="labelCol" :wrapperCol="wrapperCol" label="主图" prop="image">
              <j-image-upload :disabled="disabled" v-model="model.image" :isMultiple="false" text="上传"></j-image-upload>
            </a-form-model-item>
          </a-col>

          <a-col :span="24">
            <a-form-model-item :labelCol="labelCol" :wrapperCol="wrapperCol" label="轮播图" prop="banner">
              <j-image-upload :disabled="disabled" v-model="model.banner" :isMultiple="true" text="上传"></j-image-upload>
            </a-form-model-item>
          </a-col>

          <a-col :span="24">
            <a-form-model-item :labelCol="labelCol" :wrapperCol="wrapperCol" label="详情" prop="content">
              <JEditor v-model="model.content" placeholder="请输入详情"></JEditor>
            </a-form-model-item>
          </a-col>

          <a-col :span="24">
            <a-form-model-item :labelCol="labelCol" :wrapperCol="wrapperCol" label="秒杀时间" prop="startTime">
              <a-range-picker :disabled="disabled" v-model="startAndEndTime" :format="dateFormat" show-time />
            </a-form-model-item>
          </a-col>
          
          <a-col :span="24">
            <a-form-model-item :labelCol="labelCol" :wrapperCol="wrapperCol" label="状态" prop="status">
              <j-switch :disabled="disabled" v-model="model.status"></j-switch>
            </a-form-model-item>
          </a-col>

          <a-col :span="24">
            <a-form-model-item :labelCol="labelCol" :wrapperCol="wrapperCol" label="权重" prop="weight">
              <a-input-number :disabled="disabled" v-model="model.weight" placeholder="请输入权重" style="width: 100%"/>
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
import signMd5Utils from '@/utils/encryption/signMd5Utils'
import { axios } from '@/utils/request'


export default {
  name: 'ShoeGoodsForm',
  components: {
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
        startTime:'',
        endTime:'',
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
          { required: true, message: '请输入产品名称!' },
        ],
        content: [
          { required: true, message: '请输入详情!' },
        ],
        status: [
          { required: true, message: '请输入状态' },
        ],
        describe: [
          { required: true, message: '请输入产品描述' },
        ],
        image: [
          { required: true, message: '请选择产品主图' },
        ],
        banner: [
          { required: true, message: '请选择产品轮播图' },
        ],
        content: [
          { required: true, message: '请输入产品内容' },
        ],
        startTime: [
          { required: true, message: '请选择秒杀时间!' },
        ],
        inventory: [
          { required: true, message: '请输入产品剩余库存!' },
        ],
        limitNum: [
          { required: true, message: '请输入每人限购数量' },
        ],
        weight: [
          { required: true, message: '请输入权重' },
        ],
      },
      url: {
        list: "/shoes/shoeGoodsSku/list",
        add: '/ShoeSeckill/shoeSeckill/add',
        edit: '/ShoeSeckill/shoeSeckill/edit',
        queryById: '/ShoeSeckill/shoeSeckill/queryById'
      },
      count:0,
      columns : [
        {
          title: '商品',
          dataIndex: 'goodsId',
          scopedSlots: { customRender: 'goodsId' },
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
          dataIndex: 'seckillPrice',
          scopedSlots: { customRender: 'seckillPrice' },
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
      dateFormat:"YYYY-MM-DD HH:mm:ss",
      goodOptions:[],
      skuOptions:[],
      goodList:[],
      startAndEndTime:[],

    }
  },
  watch: {
    startAndEndTime:{
      handler(val) {
        this.model.startTime = val.length ? moment(val[0]).format('YYYY-MM-DD HH:mm:ss') : null
        this.model.endTime = val.length ? moment(val[1]).format('YYYY-MM-DD HH:mm:ss') : null
      },
      immediate:true,
      deep:true
    }
  },
  computed: {

    formDisabled() {
      return this.disabled
    },
    selectedSkuIds() {
      return this.goodList.map(good => good.skuId)
    }
  },
  created() {
    //备份model原始值
    this.getGoodList()
    this.modelDefault = JSON.parse(JSON.stringify(this.model))

  },
  methods: {
    // 获取秒杀产品详情
    getDetail(seckillId) {
      getAction(this.url.queryById,{seckillId}).then((res) => {
          if (res.success) {
            this.model = res.result
            this.model.banner = res.result.banner.join(',')
            this.startAndEndTime = [moment(this.model.startTime),moment(this.model.endTime)]
            res.result.seckillGoodsList.forEach(item => {
              this.goodList.push({
                ...item,
                uuid: this.getUuid()
              })
              this.skuOptions.push({
                label: item.skuName,
                value: item.skuId
              })
            })
          } else {
            this.$message.warning(res.message);
          }
        }).finally(() => {
          this.confirmLoading = false;
        })
    },
    onClickSku(idx) {
      let value = this.goodList[idx].goodsId
      this.setSkuOptions(value)
    },
    changeGood(value,idx) {
      this.goodList[idx].skuId = ''
      this.goodList[idx].disabled = false
    },
    setSkuOptions(value) {
      let skuTable = this.goodOptions.find(good => good.value == value).skuTable
      this.skuOptions = skuTable.map(sku => ({
        ...sku,
        disabled: this.selectedSkuIds.some(item => item == sku.value)
      }))
    },
    getUuid() {
      return Math.random().toString(16).substr(2)
    },
    addProduct() {
      let keys = ['goodsId','skuId','seckillPrice','num']
      let flag = this.goodList.every(item => keys.every(key => item[key]))
      if(!this.goodList.length || flag) {
        this.goodList.push({
          goodsId:'',
          skuId:'',
          seckillPrice: '',
          num:1,
          uuid: this.getUuid(),
          disabled: true
        })
      } else {
        this.$message.warning('请先填写完整再新增！')
      }
      
    },
    onDel(idx) {
      this.goodList.splice(idx,1)
    },
    getGoodList() {
      getAction('/shoes/shoeCustomerGoods/list').then((res) => {
          if (res.success) {
            this.goodOptions = res.result.map(good => ({
              label:good.goodsName,
              value:+good.goodsId,
              skuTable:good.skuList.map(sku  => ({
                label:sku.skuName,
                value:+sku.skuId
              }))
            }))
          } else {
            this.$message.warning(res.message);
          }
        }).finally(() => {
          this.confirmLoading = false;
        })
    },


    add() {

    },
    edit(record) {
      // this.disabled = record.disabled
      this.confirmLoading = true
      this.getDetail(record.seckillId)
     //
      
    },
    submitForm() {
      let keys = ['goodsId','skuId','seckillPrice','num']
      let flag = this.goodList.every(item => keys.every(key => item[key]))
      if(!this.goodList.length || !flag) {
        return this.$message.warning('请先填写完整再保存！')
      }
      const that = this
      // 触发表单验证
      this.$refs.form.validate(valid => {
        if (valid) {
          that.confirmLoading = true
          let httpurl = ''
          let method = ''
          if (!this.model.seckillId) {
            httpurl += this.url.add
            method = 'post'
          } else {
            httpurl += this.url.edit
            method = 'put'
          }
          httpAction(httpurl, Object.assign({},this.model,{seckillGoodsList:this.goodList,banner:this.model.banner.split(',')}), method).then((res) => {
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