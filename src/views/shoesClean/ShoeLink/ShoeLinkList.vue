<template>
  <a-card :bordered="false">
    <!-- 查询区域 -->
    <div class="table-page-search-wrapper">
      <a-form layout="inline" @keyup.enter.native="searchQuery">
        <a-row :gutter="24">
          <a-col :xl="6" :lg="7" :md="8" :sm="24">
            <a-form-item label="域名">
              <a-input placeholder="请输入域名" v-model="queryParam.url"></a-input>
            </a-form-item>
          </a-col>
          <a-col :xl="6" :lg="7" :md="8" :sm="24">
            <a-form-item label="跳转类型">
              <a-select v-model="queryParam.type">
                <a-select-option v-for="item in typeOptions" :value="item.value" :key="item.value">{{item.name}}</a-select-option>
              </a-select>
            </a-form-item>
          </a-col>
            <a-col :xl="6" :lg="7" :md="8" :sm="24">
              <a-form-item label="状态">
                <a-select v-model="queryParam.status">
                  <a-select-option v-for="item in statusOptions" :value="item.value" :key="item.value">{{item.name}}</a-select-option>
                </a-select>
              </a-form-item>
            </a-col>
            <a-col :xl="6" :lg="7" :md="8" :sm="24">
              <a-form-item label="备注">
                <a-input placeholder="请输入备注" v-model="queryParam.note"></a-input>
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
        rowKey="id"
        :columns="columns"
        :dataSource="dataSource"
        :pagination="ipagination"
        :loading="loading"
        :rowSelection="{selectedRowKeys: selectedRowKeys, onChange: onSelectChange}"
        class="j-table-force-nowrap"
        @change="handleTableChange">


        <span slot="action" slot-scope="text, record">
          <a @click="handleEdit(record)">编辑</a>

          <a-divider type="vertical" />
                <a-popconfirm title="确定删除吗?" @confirm="() => handleDelete(record.linkId)">
                  <a>删除</a>
                </a-popconfirm>
        </span>

      </a-table>
    </div>

    <shoe-link-modal ref="modalForm" @ok="modalFormOk"></shoe-link-modal>
  </a-card>
</template>

<script>

  import '@/assets/less/TableExpand.less'
  import { mixinDevice } from '@/utils/mixin'
  import { JeecgListMixin } from '@/mixins/JeecgListMixin'
  import ShoeLinkModal from './modules/ShoeLinkModal'

  export default {
    name: 'ShoeLinkList',
    mixins:[JeecgListMixin, mixinDevice],
    components: {
      ShoeLinkModal
    },
    data () {
      return {
        description: 'shoe_link管理页面',
        // 表头
        columns: [

          {
            title:'域名',
            align:"center",
            dataIndex: 'url'
          },
          {
            title:'跳转类型',
            align:"center",
            dataIndex: 'type',
            customRender: (text) => {
              if (text==1){
                text = '鞋蜂小程序'
              }else if (text==2){
                text = '公众号文章'
              }
              return text
            }
          },
          {
            title:'状态',
            align:"center",
            dataIndex: 'status',
            customRender: (text) => {
              if (text==0){
                text = '停用'
              }else if (text==1){
                text = '启用'
              }
              return text
            }
          },
          {
            title:'备注',
            align:"center",
            dataIndex: 'note'
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
          list: "/shoeLink/list",
          delete: "/shoeLink/delete",
          deleteBatch: "/shoeLink/shoeLink/deleteBatch",
          exportXlsUrl: "/shoeLink/shoeLink/exportXls",
          importExcelUrl: "shoeLink/shoeLink/importExcel",
          
        },
        dictOptions:{},
        statusOptions: [{"value":"", "name":"全部"}, {"value":"1", "name":"启用"}, {"value":"0", "name":"停用"}],
        typeOptions: [{"value":"", "name":"全部"}, {"value":"1", "name":"鞋蜂小程序"}, {"value":"0", "name":"公众号文章"}],
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
        fieldList.push({type:'int',value:'linkId',text:'ID',dictCode:''})
        fieldList.push({type:'string',value:'keyword',text:'域名后缀',dictCode:''})
        fieldList.push({type:'string',value:'url',text:'完整域名',dictCode:''})
        fieldList.push({type:'int',value:'type',text:'跳转目标类型:1=鞋蜂小程序,2=公众号文章',dictCode:''})
        fieldList.push({type:'string',value:'toUrl',text:'目标地址',dictCode:''})
        fieldList.push({type:'int',value:'status',text:'状态:0=停用,1=启用',dictCode:''})
        fieldList.push({type:'string',value:'note',text:'备注',dictCode:''})
        fieldList.push({type:'int',value:'delFlag',text:'软删除标识：0=正常，1=删除',dictCode:''})
        fieldList.push({type:'date',value:'deleteTime',text:'删除时间'})
        fieldList.push({type:'string',value:'addUserId',text:'添加人id',dictCode:''})
        fieldList.push({type:'string',value:'updateUserId',text:'最后操作人姓名',dictCode:''})
        this.superFieldList = fieldList
      }
    }
  }
</script>
<style scoped>
  @import '~@assets/less/common.less';
</style>