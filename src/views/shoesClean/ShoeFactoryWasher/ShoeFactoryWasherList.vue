<template>
  <a-card :bordered="false">
    <!-- 查询区域 -->
    <div class="table-page-search-wrapper">
      <a-form layout="inline" @keyup.enter.native="searchQuery">
        <a-row :gutter="24">
          <a-col :xl="6" :lg="7" :md="8" :sm="24">
            <a-form-item label="洗涤员">
              <a-input placeholder="请输入洗涤员姓名" v-model="queryParam.name"></a-input>
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
      <div class="ant-alert ant-alert-info" style="margin-bottom: 16px;">
        <i class="anticon anticon-info-circle ant-alert-icon"></i> 已选择 <a style="font-weight: 600">{{ selectedRowKeys.length }}</a>项
        <a style="margin-left: 24px" @click="onClearSelected">清空</a>
      </div>

      <a-table
        ref="table"
        size="middle"
        :scroll="{x:true}"
        bordered
        rowKey="factoryWasherId"
        :columns="columns"
        :dataSource="dataSource"
        :pagination="ipagination"
        :loading="loading"
        :rowSelection="{selectedRowKeys: selectedRowKeys, onChange: onSelectChange}"
        class="j-table-force-nowrap"
        @change="handleTableChange">

<span slot="status" slot-scope="text, record">
          <a-switch v-model:checked="record.status" @click="switchChange(record.status,record.factoryWasherId)"/>
        </span>

        <span slot="action" slot-scope="text, record">
          <a @click="handleEdit(record)">编辑</a>

          <a-divider type="vertical" />

                <a-popconfirm title="确定删除吗?" @confirm="() => handleDelete(record.factoryWasherId)">
                  <a>删除</a>
                </a-popconfirm>
        </span>

      </a-table>
    </div>

    <shoe-factory-washer-modal ref="modalForm" @ok="modalFormOk"></shoe-factory-washer-modal>
  </a-card>
</template>

<script>

  import '@/assets/less/TableExpand.less'
  import { mixinDevice } from '@/utils/mixin'
  import { JeecgListMixin } from '@/mixins/JeecgListMixin'
  import ShoeFactoryWasherModal from './modules/ShoeFactoryWasherModal'
  import {httpAction} from "@api/manage";

  export default {
    name: 'ShoeFactoryWasherList',
    mixins:[JeecgListMixin, mixinDevice],
    components: {
      ShoeFactoryWasherModal
    },
    data () {
      return {
        description: 'shoe_factory_washer管理页面',
        // 表头
        columns: [

          {
            title:'id',
            align:"center",
            dataIndex: 'factoryWasherId'
          },

          {
            title:'洗涤员',
            align:"center",
            dataIndex: 'name'
          },
          {
            title:'总洗鞋数',
            align:"center",
            dataIndex: 'num'
          },

          {
            title:'启用',
            align:"center",
            scopedSlots: { customRender: 'status' }
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
          list: "/shoeFactoryWasher/list",
          delete: "/shoeFactoryWasher/delete",
          deleteBatch: "/shoeFactoryWasher/deleteBatch",

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
      switchChange(status,id){
        //请求接口，更改活动开关
        let data = {
          "status": status,
          "id": id,
        }
        httpAction("/shoeFactoryWasher/updateStatus", data, "put").then((res) => {
          if (res.success){
            this.$message.success(res.message);
            this.loadData();
          }
        });
      },
      getSuperFieldList(){
        let fieldList=[];
        fieldList.push({type:'int',value:'factoryWasherId',text:'洗护师id',dictCode:''})
        fieldList.push({type:'string',value:'orgCode',text:'工厂编码',dictCode:''})
        fieldList.push({type:'string',value:'name',text:'洗护师姓名',dictCode:''})
        fieldList.push({type:'string',value:'phone',text:'电话',dictCode:''})
        fieldList.push({type:'int',value:'num',text:'洗鞋数',dictCode:''})
        fieldList.push({type:'int',value:'status',text:'状态：0=关闭，1=开启',dictCode:''})
        fieldList.push({type:'date',value:'deleteTime',text:'删除时间'})
        fieldList.push({type:'int',value:'delFlag',text:'软删除标识:0=正常，1=删除',dictCode:''})
        this.superFieldList = fieldList
      }
    }
  }
</script>
<style scoped>
  @import '~@assets/less/common.less';
</style>