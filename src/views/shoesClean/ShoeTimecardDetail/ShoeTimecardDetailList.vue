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
            <a-form-item label="用户名称">
              <a-input placeholder="请输入用户名称" v-model="queryParam.userName"></a-input>
            </a-form-item>
          </a-col>
          <a-col :xl="6" :lg="7" :md="8" :sm="24">
            <a-form-item label="购买时间">
              <a-range-picker v-model="queryParam.createTime" />
            </a-form-item>
          </a-col>
          <a-col :xl="6" :lg="7" :md="8" :sm="24">
            <a-form-item label="兑换时间">
              <a-range-picker v-model="queryParam.finishTime" />
            </a-form-item>
          </a-col>
          <a-col :xl="6" :lg="7" :md="8" :sm="24">
            <a-button type="primary" @click="searchQuery" icon="search">查询</a-button>
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
        rowKey="id"
        :columns="columns"
        :dataSource="dataSource"
        :pagination="ipagination"
        :loading="loading"
        class="j-table-force-nowrap">

      </a-table>
    </div>

    <shoe-timecard-modal ref="modalForm" @ok="modalFormOk"></shoe-timecard-modal>
  </a-card>
</template>

<script>

  import '@/assets/less/TableExpand.less'
  import { mixinDevice } from '@/utils/mixin'
  import { JeecgListMixin } from '@/mixins/JeecgListMixin'
  import ShoeTimecardModal from './modules/ShoeTimecardModal'
  import moment from 'moment';

  export default {
    name: 'ShoeSetmealTimecardExchangeList',
    mixins:[JeecgListMixin, mixinDevice],
    components: {
      ShoeTimecardModal
    },
    data () {
      return {
        description: 'shoe_setmeal_timecard_exchange管理页面',
        // 表头
        columns: [
        {
            title:'用户手机号码',
            align:"center",
            dataIndex: 'phone'
          },
          {
            title:'平台名称',
            align:"center",
            dataIndex: 'platform'
          },
          {
            title:'套餐名称',
            align:"center",
            dataIndex: 'setmeal'
          },
          {
            title:'是否兑换',
            align:"center",
            dataIndex: 'status'
          },
          {
            title:'购买时间',
            align:"center",
            dataIndex: 'exchangeTime',
            customRender:function (text) {
              return !text?"":(text.length>10?text.substr(0,10):text)
            }
          },
          // {
          //   title:'兑换时间',
          //   align:"center",
          //   dataIndex: 'exchangeTime',
          //   customRender:function (text) {
          //     return !text?"":(text.length>10?text.substr(0,10):text)
          //   }
          // }
        ],
        url: {
          list: "/shoeSetmealTimecardExchange/shoeSetmealTimecardExchange/list",
          delete: "/shoeSetmealTimecardExchange/shoeSetmealTimecardExchange/delete",
          deleteBatch: "/shoeSetmealTimecardExchange/shoeSetmealTimecardExchange/deleteBatch",
          exportXlsUrl: "/shoeSetmealTimecardExchange/shoeSetmealTimecardExchange/exportXls",
          importExcelUrl: "shoeSetmealTimecardExchange/shoeSetmealTimecardExchange/importExcel",
          
        },
        dictOptions:{},
        queryParam:{
          createTime:[],
          createTimeLeft:'',
          createTimeRight:'',
          finishTimeLeft:'',
          createTimeRight:'',
          finishTime:[],
        },
      }
    },
    created() {
    },
    watch:{
    'queryParam.createTime': {
        handler(newV) {
          this.queryParam.createTimeLeft = moment(newV[0]).format('YYYY-MM-DD')
          this.queryParam.createTimeright = moment(newV[1]).format('YYYY-MM-DD')
      },
      immediate: true
    },
    'queryParam.finishTime': {
        handler(newV) {
          this.queryParam.finishTimeLeft = moment(newV[0]).format('YYYY-MM-DD')
          this.queryParam.finishTimeright = moment(newV[1]).format('YYYY-MM-DD')
      },
      immediate: true
    }
  },
    computed: {
      importExcelUrl: function(){
        return `${window._CONFIG['domianURL']}/${this.url.importExcelUrl}`;
      },
    },
    methods: {
      initDictConfig(){
      },
    }
  }
</script>
<style scoped>
  @import '~@assets/less/common.less';
</style>