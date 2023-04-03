<template>
  <a-spin :spinning="confirmLoading">
    <j-modal title="商品管理"
             :width="700"
             :visible="visible"
             switchFullscreen
             @ok="handleSubmit2"
             @cancel="handleCancel2"
             cancelText="关闭"
             wrapClassName="full-modal">
      <div>
        <a-button type="primary" @click="addProduct">新增</a-button>
        <div style="margin-top: 24px;"></div>
        <a-table
        ref="table"
        size="middle"
        :scroll="{x:true}"
        bordered
        rowKey="uuid"
        :columns="columns"
        :dataSource="goodList"
        :loading="loading"
        :pagination="false"
        class="j-table-force-nowrap">

        <span slot="goodsId" slot-scope="text, record, idx">
          <a-select showSearch :filterOption="((input,option) => option.componentOptions.children[0].text.toLowerCase().indexOf(input.toLowerCase()) >= 0)" optionFilterProp="value" v-model="goodList[idx].goodsId" style="width: 240px" :options="goodOptions" @change="changeGood($event,idx)">
          </a-select>
        </span>
        <span slot="skuId" slot-scope="text, record, idx">
          <a-select ref="skuSelect" v-model="goodList[idx].skuId" style="width: 140px" :options="skuOptions" :disabled="goodList[idx].disabled" @focus="onClickSku(idx)" @change="$refs.skuSelect.blur()">
          </a-select>
        </span>
        <span slot="price" slot-scope="text, record, idx">
          <a-input-number v-model="goodList[idx].price" placeholder="价格" @change="onChangePrice($event,idx)" :min="0.01"/>
        </span>
        <span slot="action" slot-scope="text, record, idx">
          <a @click="onDel(idx)" style="color: #f92525">删除</a>
        </span>

      </a-table>
      </div>
      </j-modal>
  </a-spin>
</template>

<script>
import {httpAction,getAction} from "@/api/manage";
export default {
  data() {
    return {
      loading: false,
      visible: false,
      data: {},
      confirmLoading: false,
      goodList:[],
      goodOptions:[],
      skuOptions:[],
      // 表头
      columns: [
          {
            title:'商品名',
            align:"center",
            dataIndex: 'goodsId',
            scopedSlots: { customRender: 'goodsId' }
          },
          {
            title:'商品规格',
            align:"center",
            dataIndex: 'skuId',
            scopedSlots: { customRender: 'skuId' }
          },
          {
            title:'价格(元)',
            align:"center",
            dataIndex: 'price',
            scopedSlots: { customRender: 'price' }
          },
          {
            title: '操作',
            dataIndex: 'action',
            align:"center",
            fixed:"right",
            width:80,
            scopedSlots: { customRender: 'action' }
          }
        ],
        customerId:0
    }
  },
  created() {
    this.getGoodList()
  },
  computed:{
    selectedSkuIds() {
      return this.goodList.map(good => good.skuId)
    }
  },
  methods: {
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
      let keys = ['goodsId','skuId','price']
      let flag = this.goodList.every(item => keys.every(key => item[key]))
      if(!this.goodList.length || flag) {
        this.goodList.push({
          goodsId:'',
          skuId:'',
          price: 0.01,
          uuid: this.getUuid(),
          customerId:1,
          disabled: true
        })
      } else {
        this.$message.warning('请先填写完整再新增！')
      }
      
    },
    onDel(idx) {
      this.goodList.splice(idx,1)
    },
    onChangePrice(v,idx) {
      let price = parseFloat(parseFloat(v).toFixed(2)) || 0.01
      this.goodList[idx].price = price
    },
    show(customerId) {
      this.visible = true;
      this.customerId = customerId;
      this.confirmLoading = true;
      getAction('/shoes/shoeCustomerGoods/listByCustomerId', {customerId}).then((res) => {
          if (res.success) {
            res.result.forEach(item => {
              this.goodList.push({
                ...item,
                price:item.goodsPrice
              })
              this.skuOptions.push({
                label: item.skuName,
                value: item.skuId
              })
            });
          } else {
            this.$message.warning(res.message);
          }
        }).finally(() => {
          this.confirmLoading = false;
        })
      // this.auditOption = "1";
      // this.data.note = "";
    },
    handleCancel2() {
      this.visible = false;
      this.goodList = []
    },
    handleSubmit2() {
      let keys = ['goodsId','skuId','price']
      let idx = this.goodList.length - 1
      if(idx > -1 && keys.every(key => this.goodList[idx][key])) {
        // 保存 
        //发送请求
        this.confirmLoading = true;
        let httpUrl = "/shoes/shoeCustomerGoods/save";
        httpAction(httpUrl, this.goodList, "post").then((res) => {
          if (res.success) {
            this.$message.success(res.message);
            this.handleCancel2();
            this.$emit('ok');
          } else {
            this.$message.warning(res.message);
          }
        }).finally(() => {
          this.confirmLoading = false;
        })
      } else {
        this.$message.warning('请先填写完整再保存！')
      }
    },
    getGoodList() {
      getAction('/shoes/shoeCustomerGoods/list').then((res) => {
          if (res.success) {
            this.goodOptions = res.result.map(good => ({
              label:good.goodsName,
              value:good.goodsId,
              skuTable:good.skuList.map(sku  => ({
                label:sku.skuName,
                value:sku.skuId
              }))
            }))
          } else {
            this.$message.warning(res.message);
          }
        }).finally(() => {
          this.confirmLoading = false;
        })
    }
  }
}
</script>

<style scoped>
</style>