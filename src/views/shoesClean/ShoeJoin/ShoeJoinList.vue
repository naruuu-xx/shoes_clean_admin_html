<template>
  <a-card :bordered="false">
    <!-- 查询区域 -->
    <div class="table-page-search-wrapper">
      <a-form layout="inline" @keyup.enter.native="searchQuery">
        <a-row :gutter="24">
          <a-col :xl="6" :lg="7" :md="8" :sm="24">
            <a-form-item label="手机号">
              <a-input placeholder="请输入手机号" v-model="queryParam.phone"></a-input>
            </a-form-item>
          </a-col>
          <a-col :xl="6" :lg="7" :md="8" :sm="24">
            <a-form-item label="姓名">
              <a-input placeholder="请输入姓名" v-model="queryParam.name"></a-input>
            </a-form-item>
          </a-col>
            <a-col :xl="10" :lg="11" :md="12" :sm="24">
              <a-form-item label="提交时间">
                <j-date placeholder="请选择开始日期" class="query-group-cust" v-model="queryParam.createTime_begin"></j-date>
                <span class="query-group-split-cust"></span>
                <j-date placeholder="请选择结束日期" class="query-group-cust" v-model="queryParam.createTime_end"></j-date>
              </a-form-item>
            </a-col>
          <a-col :xl="6" :lg="7" :md="8" :sm="24">
            <span style="float: left;overflow: hidden;" class="table-page-search-submitButtons">
              <a-button type="primary" @click="searchQuery" icon="search">查询</a-button>
              <a-button type="primary" @click="searchReset" icon="reload" style="margin-left: 8px">重置</a-button>
<!--              <a @click="handleToggleSearch" style="margin-left: 8px">-->
<!--                {{ toggleSearchStatus ? '收起' : '展开' }}-->
<!--                <a-icon :type="toggleSearchStatus ? 'up' : 'down'"/>-->
<!--              </a>-->
            </span>
          </a-col>
        </a-row>
      </a-form>
    </div>
    <!-- 查询区域-END -->

    <!-- 操作按钮区域 -->
<!--    <div class="table-operator">-->
<!--      <a-button @click="handleAdd" type="primary" icon="plus">新增</a-button>-->
<!--      <a-button type="primary" icon="download" @click="handleExportXls('shoe_join')">导出</a-button>-->
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
<!--      <div class="ant-alert ant-alert-info" style="margin-bottom: 16px;">-->
<!--        <i class="anticon anticon-info-circle ant-alert-icon"></i> 已选择 <a style="font-weight: 600">{{ selectedRowKeys.length }}</a>项-->
<!--        <a style="margin-left: 24px" @click="onClearSelected">清空</a>-->
<!--      </div>-->

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

<!--        <template slot="htmlSlot" slot-scope="text">-->
<!--          <div v-html="text"></div>-->
<!--        </template>-->
<!--        <template slot="imgSlot" slot-scope="text,record">-->
<!--          <span v-if="!text" style="font-size: 12px;font-style: italic;">无图片</span>-->
<!--          <img v-else :src="getImgView(text)" :preview="record.id" height="25px" alt="" style="max-width:80px;font-size: 12px;font-style: italic;"/>-->
<!--        </template>-->
<!--        <template slot="fileSlot" slot-scope="text">-->
<!--          <span v-if="!text" style="font-size: 12px;font-style: italic;">无文件</span>-->
<!--          <a-button-->
<!--            v-else-->
<!--            :ghost="true"-->
<!--            type="primary"-->
<!--            icon="download"-->
<!--            size="small"-->
<!--            @click="downloadFile(text)">-->
<!--            下载-->
<!--          </a-button>-->
<!--        </template>-->

        <span slot="action" slot-scope="text, record">
          <a @click="updateOrshow(record)" v-if="record.status=='0'">编辑</a>
          <a @click="show(record)" v-if="record.status=='1'">详情</a>

<!--          <a-divider type="vertical" />-->
<!--          <a-dropdown>-->
<!--            <a class="ant-dropdown-link">更多 <a-icon type="down" /></a>-->
<!--            <a-menu slot="overlay">-->
<!--              <a-menu-item>-->
<!--                <a @click="handleDetail(record)">详情</a>-->
<!--              </a-menu-item>-->
<!--              <a-menu-item>-->
<!--                <a-popconfirm title="确定删除吗?" @confirm="() => handleDelete(record.id)">-->
<!--                  <a>删除</a>-->
<!--                </a-popconfirm>-->
<!--              </a-menu-item>-->
<!--            </a-menu>-->
<!--          </a-dropdown>-->
        </span>

      </a-table>
    </div>

    <shoe-join-modal ref="modalForm" @ok="modalFormOk"></shoe-join-modal>
    <shoe-join-show-modal ref="showModalForm" @ok="modalFormOk"></shoe-join-show-modal>
  </a-card>
</template>

<script>

  import '@/assets/less/TableExpand.less'
  import { mixinDevice } from '@/utils/mixin'
  import { JeecgListMixin } from '@/mixins/JeecgListMixin'
  import ShoeJoinModal from './modules/ShoeJoinModal'
  import ShoeJoinShowModal from './modules/ShoeJoinShowModal'

  export default {
    name: 'ShoeJoinList',
    mixins:[JeecgListMixin, mixinDevice],
    components: {
      ShoeJoinModal,
      ShoeJoinShowModal
    },
    data () {
      return {
        description: 'shoe_join管理页面',
        // 表头
        columns: [
          {
            title:'手机号',
            align:"center",
            dataIndex: 'phone'
          },
          {
            title:'姓名',
            align:"center",
            dataIndex: 'name'
          },
          {
            title:'来访原因',
            align:"center",
            dataIndex: 'reason'
          },
          {
            title:'提交时间',
            align:"center",
            dataIndex: 'createTime'
          },
          {
            title:'是否处理',
            align:"center",
            dataIndex: 'status',
            customRender:function (text) {
              if (text==0){
                text='否'
              }else if (text==1){
                text='是'
              }
              return text;
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
          list: "/shoeJoin/list",
          delete: "/shoeJoin/delete",
          
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
      updateOrshow(record){
        this.$refs.modalForm.show(record);
      },
      show(record){
        this.$refs.showModalForm.show(record);
      },
      initDictConfig(){
      },
      getSuperFieldList(){
        let fieldList=[];
        fieldList.push({type:'int',value:'joinId',text:'joinId',dictCode:''})
        fieldList.push({type:'string',value:'phone',text:'手机号',dictCode:''})
        fieldList.push({type:'string',value:'name',text:'姓名',dictCode:''})
        fieldList.push({type:'string',value:'reason',text:'来访原因',dictCode:''})
        fieldList.push({type:'string',value:'userId',text:'提交人userId',dictCode:''})
        fieldList.push({type:'string',value:'status',text:'0=未处理，1=已处理',dictCode:''})
        fieldList.push({type:'string',value:'note',text:'备注',dictCode:''})
        fieldList.push({type:'date',value:'createTime',text:'创建时间'})
        fieldList.push({type:'string',value:'openId',text:'openId',dictCode:''})
        this.superFieldList = fieldList
      }
    }
  }
</script>
<style scoped>
  @import '~@assets/less/common.less';
</style>