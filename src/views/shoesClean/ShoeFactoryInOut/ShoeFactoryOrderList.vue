<template>
  <a-card :bordered="false">
    <!-- 查询区域 -->
    <div class="table-page-search-wrapper">
      <a-form layout="inline" @keyup.enter.native="searchQuery">
        <a-row :gutter="24">
        </a-row>
      </a-form>
    </div>
    <!-- 查询区域-END -->

    <!-- 操作按钮区域 -->
    <div class="table-operator">
      <a-button @click="handleAdd" type="primary" icon="plus">新增</a-button>
      <a-button type="primary" icon="download" @click="handleExportXls('shoe_factory_order')">导出</a-button>
      <a-upload name="file" :showUploadList="false" :multiple="false" :headers="tokenHeader" :action="importExcelUrl" @change="handleImportExcel">
        <a-button type="primary" icon="import">导入</a-button>
      </a-upload>
      <!-- 高级查询区域 -->
      <j-super-query :fieldList="superFieldList" ref="superQueryModal" @handleSuperQuery="handleSuperQuery"></j-super-query>
      <a-dropdown v-if="selectedRowKeys.length > 0">
        <a-menu slot="overlay">
          <a-menu-item key="1" @click="batchDel"><a-icon type="delete"/>删除</a-menu-item>
        </a-menu>
        <a-button style="margin-left: 8px"> 批量操作 <a-icon type="down" /></a-button>
      </a-dropdown>
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
        rowKey="id"
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
          <img v-else :src="getImgView(text)" :preview="record.id" height="25px" alt="" style="max-width:80px;font-size: 12px;font-style: italic;"/>
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
          <a @click="handleEdit(record)">编辑</a>

          <a-divider type="vertical" />
          <a-dropdown>
            <a class="ant-dropdown-link">更多 <a-icon type="down" /></a>
            <a-menu slot="overlay">
              <a-menu-item>
                <a @click="handleDetail(record)">详情</a>
              </a-menu-item>
              <a-menu-item>
                <a-popconfirm title="确定删除吗?" @confirm="() => handleDelete(record.id)">
                  <a>删除</a>
                </a-popconfirm>
              </a-menu-item>
            </a-menu>
          </a-dropdown>
        </span>

      </a-table>
    </div>

    <shoe-factory-order-modal ref="modalForm" @ok="modalFormOk"></shoe-factory-order-modal>
  </a-card>
</template>

<script>

  import '@/assets/less/TableExpand.less'
  import { mixinDevice } from '@/utils/mixin'
  import { JeecgListMixin } from '@/mixins/JeecgListMixin'
  import ShoeFactoryOrderModal from './modules/ShoeFactoryOrderModal'

  export default {
    name: 'ShoeFactoryOrderList',
    mixins:[JeecgListMixin, mixinDevice],
    components: {
      ShoeFactoryOrderModal
    },
    data () {
      return {
        description: 'shoe_factory_order管理页面',
        // 表头
        columns: [
          {
            title: '#',
            dataIndex: '',
            key:'rowIndex',
            width:60,
            align:"center",
            customRender:function (t,r,index) {
              return parseInt(index)+1;
            }
          },
          {
            title:'ID',
            align:"center",
            dataIndex: 'factoryOrderId'
          },
          {
            title:'来源：1=鞋蜂小程序，2=其他',
            align:"center",
            dataIndex: 'source'
          },
          {
            title:'工厂编码',
            align:"center",
            dataIndex: 'orgCode'
          },
          {
            title:'订单id',
            align:"center",
            dataIndex: 'orderId'
          },
          {
            title:'订单编号',
            align:"center",
            dataIndex: 'no'
          },
          {
            title:'商品id',
            align:"center",
            dataIndex: 'goodsId'
          },
          {
            title:'规格id',
            align:"center",
            dataIndex: 'skuId'
          },
          {
            title:'商品标题',
            align:"center",
            dataIndex: 'title'
          },
          {
            title:'规格',
            align:"center",
            dataIndex: 'skuTitle'
          },
          {
            title:'电话',
            align:"center",
            dataIndex: 'phone'
          },
          {
            title:'姓名',
            align:"center",
            dataIndex: 'name'
          },
          {
            title:'状态:1=已入库，2=已出库',
            align:"center",
            dataIndex: 'status'
          },
          {
            title:'入库时间',
            align:"center",
            dataIndex: 'factoryInTime',
            customRender:function (text) {
              return !text?"":(text.length>10?text.substr(0,10):text)
            }
          },
          {
            title:'出库时间',
            align:"center",
            dataIndex: 'factoryOutTime',
            customRender:function (text) {
              return !text?"":(text.length>10?text.substr(0,10):text)
            }
          },
          {
            title:'操作人ID',
            align:"center",
            dataIndex: 'dealUserId'
          },
          {
            title:'操作人名字',
            align:"center",
            dataIndex: 'dealUsername'
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
        url: {
          list: "/ShoeFactoryOrder/shoeFactoryOrder/list",
          delete: "/ShoeFactoryOrder/shoeFactoryOrder/delete",
          deleteBatch: "/ShoeFactoryOrder/shoeFactoryOrder/deleteBatch",
          exportXlsUrl: "/ShoeFactoryOrder/shoeFactoryOrder/exportXls",
          importExcelUrl: "ShoeFactoryOrder/shoeFactoryOrder/importExcel",
          
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
        fieldList.push({type:'int',value:'factoryOrderId',text:'ID'})
        fieldList.push({type:'int',value:'source',text:'来源：1=鞋蜂小程序，2=其他'})
        fieldList.push({type:'string',value:'orgCode',text:'工厂编码'})
        fieldList.push({type:'int',value:'orderId',text:'订单id'})
        fieldList.push({type:'string',value:'no',text:'订单编号'})
        fieldList.push({type:'int',value:'goodsId',text:'商品id'})
        fieldList.push({type:'int',value:'skuId',text:'规格id'})
        fieldList.push({type:'string',value:'title',text:'商品标题'})
        fieldList.push({type:'string',value:'skuTitle',text:'规格'})
        fieldList.push({type:'string',value:'phone',text:'电话'})
        fieldList.push({type:'string',value:'name',text:'姓名'})
        fieldList.push({type:'int',value:'status',text:'状态:1=已入库，2=已出库'})
        fieldList.push({type:'date',value:'factoryInTime',text:'入库时间'})
        fieldList.push({type:'date',value:'factoryOutTime',text:'出库时间'})
        fieldList.push({type:'string',value:'dealUserId',text:'操作人ID'})
        fieldList.push({type:'string',value:'dealUsername',text:'操作人名字'})
        this.superFieldList = fieldList
      }
    }
  }
</script>
<style scoped>
  @import '~@assets/less/common.less';
</style>