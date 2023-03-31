<template>
  <a-card :bordered="false">
    <!-- 查询区域 -->
    <div class="table-page-search-wrapper">
      <a-form layout="inline" @keyup.enter.native="searchQuery">
        <a-row :gutter="24">
          <a-col :xl="6" :lg="7" :md="8" :sm="24">
            <a-form-item label="姓名">
              <a-input placeholder="请输入姓名" v-model.trim="queryParam.name"></a-input>
            </a-form-item>
          </a-col>
          <a-col :xl="6" :lg="7" :md="8" :sm="24">
            <a-form-item label="手机号">
              <a-input placeholder="请输入手机号" v-model.trim="queryParam.phone"></a-input>
            </a-form-item>
          </a-col>
          <a-col :xl="6" :lg="7" :md="8" :sm="24">
            <a-form-item label="配送方式">
              <a-select v-model="queryParam.courierType">
                <a-select-option v-for="item in typeOptionList" :value="item.value" :key="item.value">
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
    <!-- 查询区域-END -->

    <!-- 操作按钮区域 -->
    <div class="table-operator">
      <a-button @click="handleAdd" type="primary" icon="plus">新增</a-button>
    </div>

    <!-- table区域-begin -->
    <div>
      <a-table
        ref="table"
        size="middle"
        :scroll="{x:true}"
        bordered
        rowKey="customerId"
        :columns="columns"
        :dataSource="dataSource"
        :pagination="ipagination"
        :loading="loading"
        class="j-table-force-nowrap"
        @change="handleTableChange">

        <span slot="action" slot-scope="text, record">
          <a @click="handleEdit(record)">编辑</a>
          <a-divider type="vertical" />
          <a @click="onCommodityManagement(record)">商品管理</a>
        </span>

      </a-table>
    </div>

    <shoe-cooperative-client-modal ref="modalForm" @ok="modalFormOk"></shoe-cooperative-client-modal>
    <commodity-management-modal ref="managementForm" @ok="modalFormOk"></commodity-management-modal>
  </a-card>
</template>

<script>

  import '@assets/less/TableExpand.less'
  import { mixinDevice } from '@/utils/mixin'
  import { JeecgListMixin } from '@/mixins/JeecgListMixin'
  import ShoeCooperativeClientModal from './modules/ShoeCooperativeClientModal'
  import CommodityManagementModal from './modules/CommodityManagementModal'
  import {filterDictTextByCache} from "../../../components/dict/JDictSelectUtil";

  export default {
    name: 'ShoeTimecardList',
    mixins:[JeecgListMixin, mixinDevice],
    components: {
      ShoeCooperativeClientModal,
      CommodityManagementModal
    },
    data () {
      return {
        description: 'shoe_timecard管理页面',
        // 表头
        columns: [
          {
            title:'姓名',
            align:"center",
            dataIndex: 'name'
          },
          {
            title:'手机号',
            align:"center",
            dataIndex: 'phone'
          },
          {
            title:'配送方式',
            align:"center",
            dataIndex: 'courierType',
            customRender: (text) => {
              return text == 'logistics' ? "物流" : "快递";
            },
          },
          {
            title:'最低下单鞋数',
            align:"center",
            dataIndex: 'miniNum'
          },
          {
            title:'已下单',
            align:"center",
            dataIndex: 'orderNum'
          },
          {
            title:'总下单金额',
            align:"center",
            dataIndex: 'totalPrice'
          },
          {
            title:'状态',
            align:"center",
            dataIndex: 'status',
            customRender: (text) => {
              return text == 1 ? "启用" : "禁用";
            },
          },
          {
            title: '操作',
            dataIndex: 'action',
            align:"center",
            fixed:"right",
            width:147,
            scopedSlots: { customRender: 'action' }
          }
        ],
        typeOptionList: [
          { 
            value: "", name: "全部"
          },
          {
            value: "logistics", name: "物流"
          }, 
          { 
            value: "expressage", name: "快递"
          },
        ],
        url: {
          list: "/shoes/shoeCustomer/list",
          delete: "/shoes/shoeCustomer/delete",
        },
        dictOptions:{},
      }
    },
    created() {

    },
    computed: {
      importExcelUrl: function(){
        return `${window._CONFIG['domianURL']}/${this.url.importExcelUrl}`;
      },
    },
    methods: {
      onCommodityManagement(r) {
        this.$refs.managementForm.show(r.customerId)
      },
      initDictConfig(){
      },
    }
  }
</script>
<style scoped>
  @import '~@assets/less/common.less';
</style>