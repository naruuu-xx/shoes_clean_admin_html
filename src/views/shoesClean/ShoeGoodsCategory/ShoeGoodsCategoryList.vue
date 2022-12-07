<template>
  <a-card :bordered="false">
    <!-- 查询区域 -->
<!--    <div class="table-page-search-wrapper">-->
<!--      <a-form layout="inline" @keyup.enter.native="searchQuery">-->
<!--        <a-row :gutter="24">-->
<!--          <a-col :xl="6" :lg="7" :md="8" :sm="24">-->
<!--            <a-form-item label="分类名称">-->
<!--              <a-input placeholder="请输入分类名称" v-model="queryParam.name"></a-input>-->
<!--            </a-form-item>-->
<!--          </a-col>-->
<!--          <a-col :xl="6" :lg="7" :md="8" :sm="24">-->
<!--            <span style="float: left;overflow: hidden;" class="table-page-search-submitButtons">-->
<!--              <a-button type="primary" @click="searchQuery" icon="search">查询</a-button>-->
<!--              <a-button type="primary" @click="searchReset" icon="reload" style="margin-left: 8px">重置</a-button>-->
<!--              <a @click="handleToggleSearch" style="margin-left: 8px">-->
<!--                {{ toggleSearchStatus ? '收起' : '展开' }}-->
<!--                <a-icon :type="toggleSearchStatus ? 'up' : 'down'"/>-->
<!--              </a>-->
<!--            </span>-->
<!--          </a-col>-->
<!--        </a-row>-->
<!--      </a-form>-->
<!--    </div>-->
    <!-- 查询区域-END -->

    <!-- 操作按钮区域 -->
    <div class="table-operator">
      <a-button @click="handleAdd" type="primary" icon="plus">新增</a-button>
<!--      <a-button type="primary" icon="download" @click="handleExportXls('shoe_goods_category')">导出</a-button>-->
<!--      <a-upload name="file" :showUploadList="false" :multiple="false" :headers="tokenHeader" :action="importExcelUrl" @change="handleImportExcel">-->
<!--        <a-button type="primary" icon="import">导入</a-button>-->
<!--      </a-upload>-->
      <!-- 高级查询区域 -->
<!--      <j-super-query :fieldList="superFieldList" ref="superQueryModal" @handleSuperQuery="handleSuperQuery"></j-super-query>-->
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


        <j-tree-table
          :url="url.list"
          topValue="0"
          queryKey="id"
          :columns="columns"
          :tableProps="tableProps"
        >

          <template v-slot:action="props" >
            <!-- 可使用的参数： -->
            <!-- props.text -->
            <!-- props.record -->
            <!-- props.index -->
            <a @click="()=>handleEdit(props.record)" v-if="props.record.categoryPId === 2 || props.record.id === 2" >编辑</a> <br/>
            <a @click="()=>handleDelete(props.record.id)" v-if="props.record.categoryPId === 2 || props.record.id === 2" >删除</a>

          </template>
        </j-tree-table>

    </div>
    <shoe-goods-category-modal ref="modalForm" @ok="modalFormOk"></shoe-goods-category-modal>
  </a-card>
</template>

<script>

  import '@/assets/less/TableExpand.less'
  import { mixinDevice } from '@/utils/mixin'
  import { JeecgListMixin } from '@/mixins/JeecgListMixin'
  import ShoeGoodsCategoryModal from './modules/ShoeGoodsCategoryModal'
  import JTreeTable from '@/components/jeecg/JTreeTable'

  export default {
    name: 'ShoeGoodsCategoryList',
    mixins:[JeecgListMixin, mixinDevice],
    components: {
      ShoeGoodsCategoryModal,
      JTreeTable
    },
    data () {
      return {

        dataSource: [],
        expandedRowKeys: [],
        description: 'shoe_goods_category管理页面',
        // 表头
        columns: [
          {
            title:'分类名称',
            align:"center",
            dataIndex: 'name'
          },
          {
            title:'权重',
            align:"center",
            dataIndex: 'weight'
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
          list: "/shoes/shoeGoodsCategory/list",
          delete: "/shoes/shoeGoodsCategory/delete",
          deleteBatch: "/shoes/shoeGoodsCategory/deleteBatch",
          exportXlsUrl: "/shoes/shoeGoodsCategory/exportXls",
          importExcelUrl: "shoes/shoeGoodsCategory/importExcel",
          
        },
        dictOptions:{},
        superFieldList:[],
      }
    },
    created() {
    this.getSuperFieldList();
    this.loadData(this.url.list);
    },
    computed: {
      importExcelUrl: function(){
        return `${window._CONFIG['domianURL']}/${this.url.importExcelUrl}`;
      },

      tableProps() {
        let _this = this
        return {
          // 列表项是否可选择
          // https://vue.ant.design/components/table-cn/#rowSelection
          rowSelection: {
            selectedRowKeys: _this.selectedRowKeys,
            onChange: (selectedRowKeys) => _this.selectedRowKeys = selectedRowKeys
          }
        }
      }
    },
    methods: {
      initDictConfig(){
      },
      getSuperFieldList(){
        let fieldList=[];
        fieldList.push({type:'string',value:'name',text:'分类名称',dictCode:''})
        fieldList.push({type:'int',value:'weight',text:'权重',dictCode:''})
        this.superFieldList = fieldList
      }
    }
  }
</script>
<style scoped>
  @import '~@assets/less/common.less';
</style>