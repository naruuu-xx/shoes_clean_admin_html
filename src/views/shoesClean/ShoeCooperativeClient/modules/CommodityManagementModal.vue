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
          <a-select v-model="goodList[idx].goodsId" style="width: 240px" :options="goodOptions" @change="changeGood($event,idx)">
          </a-select>
        </span>
        <span slot="skuId" slot-scope="text, record, idx">
          <a-select v-model="goodList[idx].skuId" style="width: 140px" :options="skuOptions" :disabled="goodList[idx].disabled" @focus="onClickSku(idx)">
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
      goodOptions:[
        {
          value:'1',
          label:'商品1'
        },
        {
          value:'2',
          label:'商品2'
        },
        {
          value:'3',
          label:'商品3'
        },
      ],
      skuOptions:[
        {
          value:'1',
          label:'规格1'
        },
        {
          value:'2',
          label:'规格2'
        },
        {
          value:'3',
          label:'规格3'
        },
      ],
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
      console.log(88888,idx,value);
      this.setSkuOptions(value)
    },
    changeGood(value,idx) {
      this.goodList[idx].skuId = ''
      this.goodList[idx].disabled = false
      console.log(111,value);
      // this.setSkuOptions(value)
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
      this.goodList.push({
        goodsId:'',
        skuId:'',
        price:'',
        uuid: this.getUuid(),
        disabled: true
      })
    },
    onDel(idx) {
      this.goodList.splice(idx,1)
    },
    onChangePrice(v,idx) {
      let price = parseFloat(parseFloat(v).toFixed(2)) || 0.01
      this.goodList[idx].price = price
    },
    show(record) {
      this.visible = true;
      // this.data = record;
      // this.auditOption = "1";
      // this.data.note = "";
    },
    handleCancel2() {
      this.visible = false;
      this.goodList = []
    },
    handleSubmit2() {
      let that = this;
      console.log(this.goodList);

      that.confirmLoading = true;

      // if ("2" === this.auditOption && this.data.note.trim() === "") {
      //   that.$message.warning("请填写拒绝原因！");
      //   that.confirmLoading = false;
      //   return false;
      // } else {
      //   this.data.status = this.auditOption;
      //   this.data.note = this.data.note.trim();
      //   //发送请求
      //   let httpUrl = "/shoeCouponExchangeThird/update";
      //   httpAction(httpUrl, this.data, "put").then((res) => {
      //     if (res.success) {
      //       that.$message.success(res.message);
      //       this.handleCancel2();
      //       that.$emit('ok');
      //     } else {
      //       that.$message.warning(res.message);
      //     }
      //   }).finally(() => {
      //     that.confirmLoading = false;
      //   })
      // }
    },
    getGoodList() {
      getAction('/shoes/shoeGoods/list',{
        pageSize: 100
      }).then((res) => {
          if (res.success) {
            this.$message.success(res.message);
            this.goodOptions = res.result.records.map(good => ({
              label:good.title,
              value:good.goodsId,
              skuTable:good.skuTable.map(sku  => ({
                label:sku.skuTitle,
                value:sku.skuId
              }))
            }))
            console.log(99,this.goodOptions);
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