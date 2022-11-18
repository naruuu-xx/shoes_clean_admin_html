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
<!--    <div class="table-operator">-->
<!--      <a-button @click="handleAdd" type="primary" icon="plus">新增</a-button>-->
<!--      <a-button type="primary" icon="download" @click="handleExportXls('shoe_config')">导出</a-button>-->
<!--      <a-upload name="file" :showUploadList="false" :multiple="false" :headers="tokenHeader" :action="importExcelUrl" @change="handleImportExcel">-->
<!--        <a-button type="primary" icon="import">导入</a-button>-->
<!--      </a-upload>-->
<!--      &lt;!&ndash; 高级查询区域 &ndash;&gt;-->
<!--      <j-super-query :fieldList="superFieldList" ref="superQueryModal" @handleSuperQuery="handleSuperQuery"></j-super-query>-->
<!--      <a-dropdown v-if="selectedRowKeys.length > 0">-->
<!--        <a-menu slot="overlay">-->
<!--          <a-menu-item key="1" @click="batchDel"><a-icon type="delete"/>删除</a-menu-item>-->
<!--        </a-menu>-->
<!--        <a-button style="margin-left: 8px"> 批量操作 <a-icon type="down" /></a-button>-->
<!--      </a-dropdown>-->
<!--    </div>-->

    <!-- table区域-begin -->
    <div>

      <a-table
        ref="table"
        size="middle"
        :scroll="{x:true}"
        bordered
        rowKey="name"
        :columns="columns"
        :dataSource="dataSource"
        :pagination="false"
        :loading="loading"
        class="j-table-force-nowrap"
        @change="handleTableChange">

        <template slot="htmlSlot" slot-scope="text">
          <div v-html="text"></div>
        </template>
        <template slot="imgSlot" slot-scope="text,record">
          <span v-if="!text" style="font-size: 12px;font-style: italic;">无图片</span>
          <img v-else :src="getImgView(text)" :preview="record.name" height="25px" alt="" style="max-width:80px;font-size: 12px;font-style: italic;"/>
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
        </span>

      </a-table>
    </div>

    <shoe-config-modal ref="modalForm" @ok="modalFormOk"></shoe-config-modal>
  </a-card>
</template>

<script>

  import '@/assets/less/TableExpand.less'
  import { mixinDevice } from '@/utils/mixin'
  import { JeecgListMixin } from '@/mixins/JeecgListMixin'
  import ShoeConfigModal from './modules/ShoeConfigModal'

  export default {
    name: 'ShoeConfigList',
    mixins:[JeecgListMixin, mixinDevice],
    components: {
      ShoeConfigModal
    },
    data () {
      return {
        description: 'shoe_config管理页面',
        // 表头
        columns: [
          // {
          //   title:'名称',
          //   align:"center",
          //   dataIndex: 'name'
          // },
          // {
          //   title:'值',
          //   align:"center",
          //   dataIndex: 'value'
          // },
          // {
          //   title:'分组',
          //   align:"center",
          //   dataIndex: 'group'
          // },
          {
            title:'板块名称',
            align:"center",
            dataIndex: 'comment',
          },
          {
            title: '操作',
            dataIndex: 'action',
            align:"center",
            fixed:"right",
            width:350,
            scopedSlots: { customRender: 'action' }
          }
        ],
        url: {
          list: "/ShoeConfig/shoeConfig/getContentManagementList",
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
        fieldList.push({type:'string',value:'name',text:'名称'})
        fieldList.push({type:'string',value:'value',text:'值'})
        fieldList.push({type:'string',value:'group',text:'分组'})
        this.superFieldList = fieldList
      },
      handleEdit(record) {
        this.$refs.modalForm.edit(record);
      }
    }
  }
</script>
<style scoped>
  @import '~@assets/less/common.less';
</style>