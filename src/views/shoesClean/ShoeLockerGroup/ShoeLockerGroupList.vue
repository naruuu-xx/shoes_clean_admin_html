<template>
  <a-card :bordered="false">
    <!-- 查询区域 -->
    <div class="table-page-search-wrapper">
      <a-form layout="inline" @keyup.enter.native="searchQuery">
        <a-row :gutter="24">
          <a-col :xl="6" :lg="7" :md="8" :sm="24">
            <a-form-item label="分组名称">
              <a-input placeholder="请输入分组名称" v-model="queryParam.name"></a-input>
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


                <a-popconfirm title="确定删除吗?" @confirm="() => handleDelete(record.lockerGroupId)">
                  <a>删除</a>
                </a-popconfirm>

        </span>

      </a-table>
    </div>

    <shoe-locker-group-modal ref="modalForm" @ok="modalFormOk"></shoe-locker-group-modal>
  </a-card>
</template>

<script>

  import '@/assets/less/TableExpand.less'
  import { mixinDevice } from '@/utils/mixin'
  import { JeecgListMixin } from '@/mixins/JeecgListMixin'
  import ShoeLockerGroupModal from './modules/ShoeLockerGroupModal'

  export default {
    name: 'ShoeLockerGroupList',
    mixins:[JeecgListMixin, mixinDevice],
    components: {
      ShoeLockerGroupModal
    },
    data () {
      return {
        description: 'shoe_locker_group管理页面',
        // 表头
        columns: [
          {
            title:'分组名称',
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
          list: "/shoeLockerGroup/list",
          delete: "/shoeLockerGroup/delete",

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
        fieldList.push({type:'int',value:'lockerGroupId',text:'机柜分组ID',dictCode:''})
        fieldList.push({type:'string',value:'name',text:'分组名称',dictCode:''})
        fieldList.push({type:'int',value:'weight',text:'权重',dictCode:''})
        this.superFieldList = fieldList
      }
    }
  }
</script>
<style scoped>
  @import '~@assets/less/common.less';
</style>