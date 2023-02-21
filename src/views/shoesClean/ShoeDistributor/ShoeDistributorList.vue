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
    </div>

    <!-- table区域-begin -->
    <div>
      <a-table
        ref="table"
        size="middle"
        :scroll="{x:true}"
        bordered
        rowKey="distributorId"
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
                <a-popconfirm title="确定删除吗?" @confirm="() => handleDelete(record.distributorId)">
                  <a>删除</a>
                </a-popconfirm>
              </a-menu-item>
            </a-menu>
          </a-dropdown>
        </span>

      </a-table>
    </div>

    <shoe-distributor-modal ref="modalForm" @ok="modalFormOk"></shoe-distributor-modal>
  </a-card>
</template>

<script>

  import '@/assets/less/TableExpand.less'
  import { mixinDevice } from '@/utils/mixin'
  import { JeecgListMixin } from '@/mixins/JeecgListMixin'
  import ShoeDistributorModal from './modules/ShoeDistributorModal'

  export default {
    name: 'ShoeDistributorList',
    mixins:[JeecgListMixin, mixinDevice],
    components: {
      ShoeDistributorModal
    },
    data () {
      return {
        description: 'shoe_distributor管理页面',
        // 表头
        columns: [
          {
            title:'推广人',
            align:"center",
            dataIndex: 'name'
          },
          {
            title:'推广码',
            align:"center",
            dataIndex: 'qrcode'
          },
          {
            title:'团队码',
            align:"center",
            dataIndex: 'teamQrcode'
          },
          {
            title:'创建时间',
            align:"center",
            dataIndex: 'createTime'
          },
          {
            title:'状态',
            align:"center",
            dataIndex: 'status'
          },
          {
            title:'收益比例',
            align:"center",
            dataIndex: 'percentage'
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
          list: "/shoeDistributor/shoeDistributor/list",
          delete: "/shoeDistributor/shoeDistributor/delete",
          deleteBatch: "/shoeDistributor/shoeDistributor/deleteBatch",
          exportXlsUrl: "/shoeDistributor/shoeDistributor/exportXls",
          importExcelUrl: "shoeDistributor/shoeDistributor/importExcel",

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
        fieldList.push({type:'int',value:'distributorId',text:'推广人id'})
        fieldList.push({type:'int',value:'pDistributorId',text:'上级推广人id'})
        fieldList.push({type:'int',value:'leave',text:'层级（推广人专属），1=一级，2=二级'})
        fieldList.push({type:'string',value:'name',text:'名称'})
        fieldList.push({type:'string',value:'phone',text:'电话'})
        fieldList.push({type:'int',value:'source',text:'来源：1=后台添加，2=一级推广人邀请，3=二级升一级'})
        fieldList.push({type:'string',value:'qrcode',text:'推广码'})
        fieldList.push({type:'string',value:'teamQrcode',text:'团队码'})
        fieldList.push({type:'int',value:'userId',text:'推广人绑定用户id'})
        fieldList.push({type:'number',value:'percentage',text:'佣金比例'})
        fieldList.push({type:'int',value:'isDistribute',text:'是否参与分佣，0=否，1=是'})
        fieldList.push({type:'int',value:'teamNum',text:'团队人数'})
        fieldList.push({type:'int',value:'num',text:'推广总人数'})
        fieldList.push({type:'string',value:'note',text:'推广人备注'})
        fieldList.push({type:'int',value:'income',text:'总收入'})
        fieldList.push({type:'int',value:'amount',text:'账户余额'})
        fieldList.push({type:'int',value:'withdrawalingAmount',text:'提现中金额'})
        fieldList.push({type:'string',value:'cardNo',text:'银行卡号'})
        fieldList.push({type:'string',value:'bank',text:'银行'})
        fieldList.push({type:'string',value:'openBank',text:'开户行'})
        fieldList.push({type:'string',value:'cardName',text:'持卡人'})
        fieldList.push({type:'int',value:'upgradeStatus',text:'二级推广人升级记录：0未升级，1已升级'})
        fieldList.push({type:'int',value:'status',text:'状态（0=禁用，1=启用）'})
        fieldList.push({type:'string',value:'addUserId',text:'添加人'})
        fieldList.push({type:'string',value:'editUserId',text:'最后修改人'})
        fieldList.push({type:'int',value:'delFlag',text:'是否删除（0=正常，1=删除）'})
        fieldList.push({type:'date',value:'deleteTime',text:'删除时间'})
        this.superFieldList = fieldList
      }
    }
  }
</script>
<style scoped>
  @import '~@assets/less/common.less';
</style>