<template>
  <a-card :bordered="false">
    <!-- 查询区域 -->
    <div class="table-page-search-wrapper">
      <a-form layout="inline" @keyup.enter.native="searchQuery">
        <a-row :gutter="24">
          <a-col :xl="4" :lg="7" :md="8" :sm="24">
            <a-form-item label="订单编号">
              <a-input placeholder="请输入订单编号" v-model="queryParam.no"></a-input>
            </a-form-item>
          </a-col>
          <a-col :xl="4" :lg="7" :md="8" :sm="24">
            <a-form-item label="操作员">
              <a-input placeholder="请输入操作员" v-model="queryParam.name"></a-input>
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
<!--      <a-button type="primary" icon="download" @click="handleExportXls('订单列表')" v-if="selectedRowKeys.length > 0">导出订单</a-button>-->
      <a-button type="primary" size="large" @click="handleInOfStorage()" style="width: 200px;height: 50px">入&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;库</a-button>
      <a-button type="primary" size="large" @click="handleCreateWashedMark()" style="width: 200px;height: 50px">打印水洗唛</a-button>
      <a-button type="primary" size="large" @click="manualInOfStorage()" style="width: 200px;height: 50px">手工录单</a-button>
    </div>

    <!-- table区域-begin -->
    <div>
      <div class="ant-alert ant-alert-info" style="margin-bottom: 16px;">
        <i class="anticon anticon-info-circle ant-alert-icon"></i> 已选择 <a style="font-weight: 600">{{ selectedRowKeys.length }}</a>项
        <a style="margin-left: 24px" @click="onClearSelected">清空</a>
      </div>

      <a-table
        ref="table"
        size="middle"
        :scroll="{x:true}"
        bordered
        rowKey="factoryOrderId"
        :columns="columns"
        :dataSource="dataSource"
        :pagination="ipagination"
        :loading="loading"
        :rowSelection="{selectedRowKeys: selectedRowKeys, onChange: onSelectChange}"
        class="j-table-force-nowrap"
        @change="handleTableChange">

        <template slot="htmlSlot" slot-scope="text">
          <div v-html="text"></div>
        </template>
        <template slot="imgSlot" slot-scope="text,record">
          <span v-if="!text" style="font-size: 12px;font-style: italic;">无图片</span>
          <img v-else :src="getImgView(text)" :preview="record.factoryOrderId" height="25px" alt="" style="max-width:80px;font-size: 12px;font-style: italic;"/>
        </template>
        <template slot="fileSlot" slot-scope="text">
          <span v-if="!text" style="font-size: 12px;font-style: italic;">无文件</span>
          <a-button
            v-else
            :ghost="true"
            type="primary"
            icon="download"
            size="small"
            @click="downloadFile(text)">
            下载
          </a-button>
        </template>

        <span slot="action" slot-scope="text, record">
          <a @click="handleFactoryOrderDetail(record)">查看详情</a>
        </span>

      </a-table>
    </div>

<!--    <shoe-factory-order-detail-modal ref="shoeFactoryOrderDetailModal" @ok="modalFormOk"></shoe-factory-order-detail-modal>-->
    <shoe-in-of-storage-modal ref="shoeInOfStorageModal"  @ok="modalFormOk"></shoe-in-of-storage-modal>

    <create-washed-mark-modal ref="createWashedMarkModal" @ok="modalFormOk"></create-washed-mark-modal>

    <manual-in-of-storage ref="manualInOfStorage" @ok="modalFormOk"></manual-in-of-storage>

  </a-card>
</template>

<script>

  import '@/assets/less/TableExpand.less'
  import { mixinDevice } from '@/utils/mixin'
  import { JeecgListMixin } from '@/mixins/JeecgListMixin'
  import ShoeInOfStorageModal from "./modules/ShoeInOfStorageModal";
  import CreateWashedMarkModal from "./modules/CreateWashedMarkModal";
  import ManualInOfStorage from "./modules/ManualInOfStorage";

  export default {
    name: 'ShoeOrderList',
    mixins:[JeecgListMixin, mixinDevice],
    components: {
      ShoeInOfStorageModal,
      CreateWashedMarkModal,
      ManualInOfStorage
    },
    data () {
      return {
        description: '入库管理页面',
        // 表头
        columns: [
          {
            title:'订单编号',
            align:"center",
            dataIndex: 'no'
          },
          {
            title:'入库时间',
            align:"center",
            dataIndex: 'factoryInTime'
          },
          {
            title:'操作员',
            align:"center",
            dataIndex: 'inUsername'
          }
          // {
          //   title: '操作',
          //   dataIndex: 'action',
          //   align:"center",
          //   fixed:"right",
          //   width:147,
          //   scopedSlots: { customRender: 'action' }
          // }
        ],
        url: {
          list: "/ShoeFactoryOrder/shoeFactoryOrder/queryInOrderList",
          // exportXlsUrl: "/ShoeOrder/shoeOrder/exportXls",
        },
        dictOptions:{},
        superFieldList:[],
      }
    },
    created() {
    this.getSuperFieldList();
    },
    computed: {
      importExcelUrl: function(){
        return `${window._CONFIG['domianURL']}/${this.url.importExcelUrl}`;
      },
    },
    methods: {
      initDictConfig(){
      },
      getSuperFieldList(){
        let fieldList=[];
        this.superFieldList = fieldList
      },
      handleInOfStorage(){
        this.$refs.shoeInOfStorageModal.show();
      },
      handleCreateWashedMark() {
        this.$refs.createWashedMarkModal.show();
      },
      manualInOfStorage(){
        this.$refs.manualInOfStorage.show();
      }
    }
  }
</script>
<style scoped>
  @import '~@assets/less/common.less';
</style>