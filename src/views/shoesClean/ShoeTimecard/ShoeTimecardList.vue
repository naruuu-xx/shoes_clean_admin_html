<template>
  <a-card :bordered="false">
    <!-- 查询区域 -->
    <div class="table-page-search-wrapper">
      <a-form layout="inline" @keyup.enter.native="searchQuery">
        <a-row :gutter="24">
          <a-col :xl="6" :lg="7" :md="8" :sm="24">
            <a-form-item label="次卡名称">
              <a-input placeholder="请输入次卡名称" v-model="queryParam.name"></a-input>
            </a-form-item>
          </a-col>
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
      <a-button type="primary" icon="download" @click="handleExportXls('shoe_timecard')">导出</a-button>
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

    <shoe-timecard-modal ref="modalForm" @ok="modalFormOk"></shoe-timecard-modal>
  </a-card>
</template>

<script>

  import '@assets/less/TableExpand.less'
  import { mixinDevice } from '@/utils/mixin'
  import { JeecgListMixin } from '@/mixins/JeecgListMixin'
  import ShoeTimecardModal from './modules/ShoeTimecardModal'

  export default {
    name: 'ShoeTimecardList',
    mixins:[JeecgListMixin, mixinDevice],
    components: {
      ShoeTimecardModal
    },
    data () {
      return {
        description: 'shoe_timecard管理页面',
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
            title:'次卡ID',
            align:"center",
            dataIndex: 'timecardId'
          },
          {
            title:'次卡名称',
            align:"center",
            dataIndex: 'name'
          },
          {
            title:'图片',
            align:"center",
            dataIndex: 'image'
          },
          {
            title:'可洗鞋数',
            align:"center",
            dataIndex: 'num'
          },
          {
            title:'有效天数',
            align:"center",
            dataIndex: 'expireDay'
          },
          {
            title:'适用商品配置：{{"goods_id": 1, "num":13,"minimum":},{"goods_id": 2, "num":10,"minimum":3}',
            align:"center",
            dataIndex: 'rangeConfig'
          },
          {
            title:'最后一次下单是否需要满足最低下单鞋子数：0=否，1=是',
            align:"center",
            dataIndex: 'useType'
          },
          {
            title:'运费减免类型：0=不减免，1=免配送费，2=免配送费或运费',
            align:"center",
            dataIndex: 'type'
          },
          {
            title:'销量',
            align:"center",
            dataIndex: 'sale'
          },
          {
            title:'状态：0=下架，1=上架,(默认上架，后台不做该功能)',
            align:"center",
            dataIndex: 'status'
          },
          {
            title:'开放小程序购买，0=否，1=是',
            align:"center",
            dataIndex: 'isShow'
          },
          {
            title:'权重',
            align:"center",
            dataIndex: 'weight'
          },
          {
            title:'备注',
            align:"center",
            dataIndex: 'note'
          },
          {
            title:'使用说明',
            align:"center",
            dataIndex: 'rules'
          },
          {
            title:'软删除标识：0=正常，1=删除',
            align:"center",
            dataIndex: 'delFlag'
          },
          {
            title:'删除时间',
            align:"center",
            dataIndex: 'deleteTime',
            customRender:function (text) {
              return !text?"":(text.length>10?text.substr(0,10):text)
            }
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
          list: "/shoeTimecard/shoeTimecard/list",
          delete: "/shoeTimecard/shoeTimecard/delete",
          deleteBatch: "/shoeTimecard/shoeTimecard/deleteBatch",
          exportXlsUrl: "/shoeTimecard/shoeTimecard/exportXls",
          importExcelUrl: "shoeTimecard/shoeTimecard/importExcel",
          
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
        fieldList.push({type:'int',value:'timecardId',text:'次卡ID',dictCode:''})
        fieldList.push({type:'string',value:'name',text:'次卡名称',dictCode:''})
        fieldList.push({type:'string',value:'image',text:'图片',dictCode:''})
        fieldList.push({type:'int',value:'num',text:'可洗鞋数',dictCode:''})
        fieldList.push({type:'int',value:'expireDay',text:'有效天数',dictCode:''})
        fieldList.push({type:'string',value:'rangeConfig',text:'适用商品配置：{{"goods_id": 1, "num":13,"minimum":},{"goods_id": 2, "num":10,"minimum":3}',dictCode:''})
        fieldList.push({type:'int',value:'useType',text:'最后一次下单是否需要满足最低下单鞋子数：0=否，1=是',dictCode:''})
        fieldList.push({type:'int',value:'type',text:'运费减免类型：0=不减免，1=免配送费，2=免配送费或运费',dictCode:''})
        fieldList.push({type:'int',value:'sale',text:'销量',dictCode:''})
        fieldList.push({type:'int',value:'status',text:'状态：0=下架，1=上架,(默认上架，后台不做该功能)',dictCode:''})
        fieldList.push({type:'int',value:'isShow',text:'开放小程序购买，0=否，1=是',dictCode:''})
        fieldList.push({type:'int',value:'weight',text:'权重',dictCode:''})
        fieldList.push({type:'string',value:'note',text:'备注',dictCode:''})
        fieldList.push({type:'Text',value:'rules',text:'使用说明',dictCode:''})
        fieldList.push({type:'int',value:'delFlag',text:'软删除标识：0=正常，1=删除',dictCode:''})
        fieldList.push({type:'date',value:'deleteTime',text:'删除时间'})
        fieldList.push({type:'string',value:'addUserId',text:'添加人ID',dictCode:''})
        fieldList.push({type:'string',value:'editUserId',text:'最后修改人ID（首次添加为添加人id）',dictCode:''})
        this.superFieldList = fieldList
      }
    }
  }
</script>
<style scoped>
  @import '~@assets/less/common.less';
</style>