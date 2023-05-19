<template>
  <a-card :bordered="false">
    <!-- 查询区域 -->
    <div class="table-page-search-wrapper">
      <a-form layout="inline" @keyup.enter.native="searchQuery">
        <a-row :gutter="24">
          <a-col :md="6" :sm="8">
            <a-form-item label="订单编号">
              <a-input placeholder="请输入订单编号" v-model="queryParam.no"></a-input>
            </a-form-item>
          </a-col>
          <a-col :xl="6" :lg="7" :md="8" :sm="24">
            <a-form-item label="订单状态">

              <a-select v-model="queryParam.status" style="width: 180px">
                <a-select-option v-for="item in statusOptionList" :value="item.value" :key="item.value">
                  {{ item.name }}
                </a-select-option>
              </a-select>
            </a-form-item>
          </a-col>

          <a-col :xl="6" :lg="7" :md="8" :sm="24">
            <span style="float: left;overflow: hidden;" class="table-page-search-submitButtons">
              <a-button type="primary" @click="searchQuery" icon="search">查询</a-button>
              <a-button type="primary" @click="searchReset" icon="reload" style="margin-left: 8px">重置</a-button>

            </span>
          </a-col>
        </a-row>
      </a-form>
    </div>

  <div style="background-color: #FFFFFF">
    <a-table
      ref="table"
      size="middle"
      :scroll="{x:true}"
      bordered
      rowKey="promotionId"
      :columns="columns"
      :dataSource="dataSource"
      :pagination="ipagination"
      :loading="loading"
      class="j-table-force-nowrap"
      @change="handleTableChange">


    </a-table>
  </div>
  </a-card>
</template>

<script>
import { mixinDevice } from '@/utils/mixin'
import { JeecgListMixin } from '@/mixins/JeecgListMixin'
import {filterDictTextByCache} from "@comp/dict/JDictSelectUtil";

export default {
  name: "ShoesitemanagerList",
  mixins:[JeecgListMixin, mixinDevice],

  data() {
    return {
      description: 'shoe_sitemanager管理页面',
      dataSource:[],
      statusOptionList: [{"value": "", "name": "全部"}, {"value": "0", "name": "待付款"}, {"value": "1", "name": "已付款"},
        {"value": "2", "name": "配送员已接单（取件）"}, {"value": "3", "name": "配送员已收件"}, {
          "value": "4",
          "name": "已入站"
        },
        {"value": "5", "name": "送工厂"}, {"value": "6", "name": "洗护中"}, {"value": "7", "name": "异常"},
        {"value": "8", "name": "退回中"}, {"value": "9", "name": "已出库"}, {"value": "10", "name": "待取件"},
        {"value": "11", "name": "配送员已接单（送件）"}, {"value": "12", "name": "配送员已取鞋"}, {
          "value": "13",
          "name": "已完成"
        },
        {"value": "14", "name": "退款中"},
        {"value": "15", "name": "已退款"},
        {"value": "16", "name": "已取消"},
        {"value": "20", "name": "送站点"},
        {"value":"25","name":"待入库"}
      ],
      url: {
        list: "/shoes/shoeLocker/sitemanagerOrderList",
      },
      // 表头
      columns: [

        {
          title: '订单编号',
          align: "center",
          dataIndex: 'no'
        },
        {
          title: '商品名称',
          align: "center",
          dataIndex: 'title'
        },
        {
          title: '商品规格',
          align: "center",
          dataIndex: 'skuTitle'
        },
        {
          title: '订单状态',
          align: "center",
          dataIndex: 'status',
          customRender: (text) => {
            return filterDictTextByCache('sitemanager:order:status', text);
          }
        },
        {
          title: '配送费',
          align: "center",
          dataIndex: 'platformFreight'
        },
        {
          title: '实付金额',
          align: "center",
          dataIndex: 'actualPrice'
        },
        {
          title: '站点收益',
          align: "center",
          dataIndex: 'totalAmount'
        },

      ],
    }
  },
  create() {
  },
  methods: {
  }
}
</script>

<style scoped>
@import '~@assets/less/common.less';
</style>