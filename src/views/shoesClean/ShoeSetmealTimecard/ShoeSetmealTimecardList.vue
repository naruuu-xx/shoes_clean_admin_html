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
      <a-button type="primary" icon="download" @click="handleExportXls('shoe_setmeal_timecard')">导出</a-button>
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

    <shoe-setmeal-timecard-modal ref="modalForm" @ok="modalFormOk"></shoe-setmeal-timecard-modal>
  </a-card>
</template>

<script>

  import '@/assets/less/TableExpand.less'
  import { mixinDevice } from '@/utils/mixin'
  import { JeecgListMixin } from '@/mixins/JeecgListMixin'
  import ShoeSetmealTimecardModal from './modules/ShoeSetmealTimecardModal'

  export default {
    name: 'ShoeSetmealTimecardList',
    mixins:[JeecgListMixin, mixinDevice],
    components: {
      ShoeSetmealTimecardModal
    },
    data () {
      return {
        description: 'shoe_setmeal_timecard管理页面',
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
            title:'套餐次卡兑换关系ID',
            align:"center",
            dataIndex: 'setmealTimecardId'
          },
          {
            title:'平台：1=福州小洁',
            align:"center",
            dataIndex: 'platform'
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
            title:'次卡id',
            align:"center",
            dataIndex: 'timecardId'
          },
          {
            title:'一份套餐兑换次卡数量',
            align:"center",
            dataIndex: 'timecardNum'
          },
          {
            title:'备注',
            align:"center",
            dataIndex: 'note'
          },
          {
            title:'添加人ID',
            align:"center",
            dataIndex: 'addUserId'
          },
          {
            title:'最后修改人ID（首次添加为添加人id）',
            align:"center",
            dataIndex: 'editUserId'
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
          list: "/shoeSetmealTimecard/shoeSetmealTimecard/list",
          delete: "/shoeSetmealTimecard/shoeSetmealTimecard/delete",
          deleteBatch: "/shoeSetmealTimecard/shoeSetmealTimecard/deleteBatch",
          exportXlsUrl: "/shoeSetmealTimecard/shoeSetmealTimecard/exportXls",
          importExcelUrl: "shoeSetmealTimecard/shoeSetmealTimecard/importExcel",
          
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
        fieldList.push({type:'int',value:'setmealTimecardId',text:'套餐次卡兑换关系ID'})
        fieldList.push({type:'int',value:'platform',text:'平台：1=福州小洁'})
        fieldList.push({type:'string',value:'setmeal',text:'套餐内容'})
        fieldList.push({type:'string',value:'keyword',text:'套餐标识'})
        fieldList.push({type:'int',value:'timecardId',text:'次卡id'})
        fieldList.push({type:'int',value:'timecardNum',text:'一份套餐兑换次卡数量'})
        fieldList.push({type:'string',value:'note',text:'备注'})
        fieldList.push({type:'string',value:'addUserId',text:'添加人ID'})
        fieldList.push({type:'string',value:'editUserId',text:'最后修改人ID（首次添加为添加人id）'})
        this.superFieldList = fieldList
      }
    }
  }
</script>
<style scoped>
  @import '~@assets/less/common.less';
</style>