<template>
  <a-card :bordered="false">
    <!-- 查询区域 -->
    <div class="table-page-search-wrapper">
      <a-form layout="inline" @keyup.enter.native="searchQuery">
        <a-row :gutter="24">
          <a-col :xl="4" :lg="7" :md="8" :sm="24">
            <a-form-item label=" 推广人">
              <a-input placeholder="请输入推广人" v-model="queryParam.name" :allowClear="true"></a-input>
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
        :pagination="ipagination"
        :loading="loading"
        class="j-table-force-nowrap"
        @change="handleTableChange">

        <span slot="action" slot-scope="text, record">
          <router-link :to=" '/shoesClean/ShoeDistributorStatistics/ShoeDistributorStatisticsInfoList/'+record.distributorId+'/'+record.num+'/'+record.todayNum+'/'+record.monthNum+'/'+record.yearNum ">详情</router-link>
        </span>

      </a-table>
    </div>

  </a-card>
</template>

<script>

  import '@/assets/less/TableExpand.less'
  import { mixinDevice } from '@/utils/mixin'
  import { JeecgListMixin } from '@/mixins/JeecgListMixin'

  export default {
    name: 'ShoeDistributorStatisticsList',
    mixins:[JeecgListMixin, mixinDevice],
    components: {
    },
    data () {
      return {
        description: 'shoe_distributor_statistics管理页面',
        // 表头
        columns: [
          {
            title:'推广人',
            align:"center",
            dataIndex: 'name'
          },
          {
            title:'总数',
            align:"center",
            dataIndex: 'num'
          },
          {
            title: '今日',
            align:'center',
            dataIndex:'todayNum'
          },
          {
            title: '本月',
            align:'center',
            dataIndex:'monthNum'
          },
          {
            title: '今年',
            align:'center',
            dataIndex:'yearNum'
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
          list: "/shoeDistributor/shoeDistributor/queryDistributorStatisticsList",
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
        this.superFieldList = fieldList
      },
      jumpToDetail(record){

      }
    }
  }
</script>
<style scoped>
  @import '~@assets/less/common.less';
</style>