<template>
  <a-card :bordered="false">
    <!-- 查询区域 -->
    <div class="table-page-search-wrapper">
      <a-form layout="inline" @keyup.enter.native="searchQuery">
        <a-row :gutter="24">
          <a-col :xl="6" :lg="7" :md="8" :sm="24">
            <a-form-item label="平台：1=福州小洁">
              <a-input placeholder="请输入平台：1=福州小洁" v-model="queryParam.platform"></a-input>
            </a-form-item>
          </a-col>
          <a-col :xl="6" :lg="7" :md="8" :sm="24">
            <a-form-item label="套餐标识">
              <a-input placeholder="请输入套餐标识" v-model="queryParam.keyword"></a-input>
            </a-form-item>
          </a-col>
          <template v-if="toggleSearchStatus">
            <a-col :xl="6" :lg="7" :md="8" :sm="24">
              <a-form-item label="用户手机号码">
                <a-input placeholder="请输入用户手机号码" v-model="queryParam.phone"></a-input>
              </a-form-item>
            </a-col>
          </template>
          <a-col :xl="6" :lg="7" :md="8" :sm="24">
            <span style="float: left;overflow: hidden;" class="table-page-search-submitButtons">
              <a-button type="primary" @click="searchQuery" icon="search">查询</a-button>
              <a-button type="primary" @click="searchReset" icon="reload" style="margin-left: 8px">重置</a-button>
              <a @click="handleToggleSearch" style="margin-left: 8px">
                {{ toggleSearchStatus ? '收起' : '展开' }}
                <a-icon :type="toggleSearchStatus ? 'up' : 'down'"/>
              </a>
            </span>
          </a-col>
        </a-row>
      </a-form>
    </div>
    <!-- 查询区域-END -->

    <!-- 操作按钮区域 -->
    <div class="table-operator">
      <a-button @click="handleAdd" type="primary" icon="plus">新增</a-button>
      <a-button type="primary" icon="download" @click="handleExportXls('shoe_setmeal_timecard_exchange')">导出</a-button>
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

    <shoe-setmeal-timecard-exchange-modal ref="modalForm" @ok="modalFormOk"></shoe-setmeal-timecard-exchange-modal>
  </a-card>
</template>

<script>

  import '@/assets/less/TableExpand.less'
  import { mixinDevice } from '@/utils/mixin'
  import { JeecgListMixin } from '@/mixins/JeecgListMixin'
  import ShoeSetmealTimecardExchangeModal from './modules/ShoeSetmealTimecardExchangeModal'

  export default {
    name: 'ShoeSetmealTimecardExchangeList',
    mixins:[JeecgListMixin, mixinDevice],
    components: {
      ShoeSetmealTimecardExchangeModal
    },
    data () {
      return {
        description: 'shoe_setmeal_timecard_exchange管理页面',
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
            title:'套餐兑换次卡记录id',
            align:"center",
            dataIndex: 'setmealTimecardExchangeId'
          },
          {
            title:'平台：1=福州小洁',
            align:"center",
            dataIndex: 'platform'
          },
          {
            title:'第三方平台订单号（防重使用）',
            align:"center",
            dataIndex: 'platformOrderId'
          },
          {
            title:'套餐内容',
            align:"center",
            dataIndex: 'setmeal'
          },
          {
            title:'套餐标识',
            align:"center",
            dataIndex: 'keyword'
          },
          {
            title:'套餐数量',
            align:"center",
            dataIndex: 'num'
          },
          {
            title:'用户手机号码',
            align:"center",
            dataIndex: 'phone'
          },
          {
            title:'用户类型：1=新用户，2=老用户',
            align:"center",
            dataIndex: 'type'
          },
          {
            title:'兑换次卡ID',
            align:"center",
            dataIndex: 'timecardId'
          },
          {
            title:'兑换次卡数量',
            align:"center",
            dataIndex: 'timecardNum'
          },
          {
            title:'状态：0=未兑换，1=已兑换',
            align:"center",
            dataIndex: 'status'
          },
          {
            title:'兑换时间',
            align:"center",
            dataIndex: 'exchangeTime',
            customRender:function (text) {
              return !text?"":(text.length>10?text.substr(0,10):text)
            }
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
          list: "/shoeSetmealTimecardExchange/shoeSetmealTimecardExchange/list",
          delete: "/shoeSetmealTimecardExchange/shoeSetmealTimecardExchange/delete",
          deleteBatch: "/shoeSetmealTimecardExchange/shoeSetmealTimecardExchange/deleteBatch",
          exportXlsUrl: "/shoeSetmealTimecardExchange/shoeSetmealTimecardExchange/exportXls",
          importExcelUrl: "shoeSetmealTimecardExchange/shoeSetmealTimecardExchange/importExcel",
          
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
        fieldList.push({type:'int',value:'setmealTimecardExchangeId',text:'套餐兑换次卡记录id',dictCode:''})
        fieldList.push({type:'int',value:'platform',text:'平台：1=福州小洁',dictCode:''})
        fieldList.push({type:'string',value:'platformOrderId',text:'第三方平台订单号（防重使用）',dictCode:''})
        fieldList.push({type:'string',value:'setmeal',text:'套餐内容',dictCode:''})
        fieldList.push({type:'string',value:'keyword',text:'套餐标识',dictCode:''})
        fieldList.push({type:'int',value:'num',text:'套餐数量',dictCode:''})
        fieldList.push({type:'string',value:'phone',text:'用户手机号码',dictCode:''})
        fieldList.push({type:'int',value:'type',text:'用户类型：1=新用户，2=老用户',dictCode:''})
        fieldList.push({type:'int',value:'timecardId',text:'兑换次卡ID',dictCode:''})
        fieldList.push({type:'int',value:'timecardNum',text:'兑换次卡数量',dictCode:''})
        fieldList.push({type:'int',value:'status',text:'状态：0=未兑换，1=已兑换',dictCode:''})
        fieldList.push({type:'date',value:'exchangeTime',text:'兑换时间'})
        this.superFieldList = fieldList
      }
    }
  }
</script>
<style scoped>
  @import '~@assets/less/common.less';
</style>