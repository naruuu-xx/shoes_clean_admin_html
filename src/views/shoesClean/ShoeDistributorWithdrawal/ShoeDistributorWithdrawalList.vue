<template>
  <a-card :bordered="false">
    <!-- 查询区域 -->
    <div class="table-page-search-wrapper">
      <a-form layout="inline" @keyup.enter.native="searchQuery">
        <a-row :gutter="24">
          <a-col :xl="6" :lg="7" :md="8" :sm="24">
            <a-form-item label="申请人">
              <a-input placeholder="请输入申请人" v-model="queryParam.name"></a-input>
            </a-form-item>
          </a-col>
          <a-col :xl="6" :lg="7" :md="8" :sm="24">
            <a-form-item label="订单状态">

              <a-select v-model="queryParam.status" style="width: 180px">
                <a-select-option v-for="item in statusOptionList" :value="item.value" :key="item.value">
                  {{ item.name }}
                </a-select-option>
              </a-select>
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
      <div class="ant-alert ant-alert-info" style="margin-bottom: 16px;">
        <i class="anticon anticon-info-circle ant-alert-icon"></i> 已选择 <a style="font-weight: 600">{{ selectedRowKeys.length }}</a>项
        <a style="margin-left: 24px" @click="onClearSelected">清空</a>
      </div>

      <a-table
        ref="table"
        size="middle"
        :scroll="{x:true}"
        bordered
        rowKey="distributorWithdrawalId"
        :columns="columns"
        :dataSource="dataSource"
        :pagination="ipagination"
        :loading="loading"
        :rowSelection="{selectedRowKeys: selectedRowKeys, onChange: onSelectChange}"
        class="j-table-force-nowrap"
        @change="handleTableChange">

        <span slot="action" slot-scope="text, record">
          <a @click="showDetail(record)" v-has="'Withdrawal:Detail'">详情</a>

          <a-divider type="vertical" v-if="record.status=='审核中'" v-has="'Withdrawal:Audit'"/>
          <a @click="handleAudit(record)" v-if="record.status=='审核中'" v-has="'Withdrawal:Audit'">审核</a>
          <a-divider type="vertical" v-if="record.status=='提现中'" v-has="'Withdrawal:Transfer'"/>
          <a @click="handleTransfer(record)" v-if="record.status=='提现中'" v-has="'Withdrawal:Transfer'">确认</a>
        </span>

      </a-table>
    </div>

    <shoe-distributor-withdrawal-detail ref="shoeDistributorWithdrawalDetail"></shoe-distributor-withdrawal-detail>
    <shoe-distributor-audit ref="shoeDistributorAudit" @ok="modalFormOk"></shoe-distributor-audit>
    <shoe-distributor-transfer ref="shoeDistributorTransfer" @ok="modalFormOk"></shoe-distributor-transfer>

  </a-card>
</template>

<script>

  import '@/assets/less/TableExpand.less'
  import { mixinDevice } from '@/utils/mixin'
  import { JeecgListMixin } from '@/mixins/JeecgListMixin'
  import ShoeDistributorWithdrawalDetail from "./modules/ShoeDistributorWithdrawalDetail";
  import ShoeDistributorAudit from "./modules/ShoeDistributorAudit";
  import ShoeDistributorTransfer from "./modules/ShoeDistributorTransfer";

  export default {
    name: 'ShoeDistributorWithdrawalList',
    mixins:[JeecgListMixin, mixinDevice],
    components: {
      ShoeDistributorWithdrawalDetail,
      ShoeDistributorAudit,
      ShoeDistributorTransfer
    },
    data () {
      return {
        statusOptionList: [{"value": "0", "name": "审核中"}, {"value": "1", "name": "提现中"}, {"value": "2", "name": "审核失败"}, {"value": "3", "name": "已提现"}],
        // 表头
        columns: [
          {
            title:'申请人',
            align:"center",
            dataIndex: 'name'
          },
          {
            title:'提现金额',
            align:"center",
            dataIndex: 'amount'
          },
          {
            title:'申请时间',
            align:"center",
            dataIndex: 'createTime'
          },
          {
            title:'审核时间',
            align:"center",
            dataIndex: 'auditTime',
            customRender: (text) => {
              return text? text : "————————";
            },
          },
          {
            title:'转账时间',
            align:"center",
            dataIndex: 'transferTime',
            customRender: (text) => {
              return text? text : "————————";
            },
          },
          {
            title:'审核人',
            align:"center",
            dataIndex: 'auditName',
            customRender: (text) => {
              return text? text : "————";
            },
          },
          {
            title: '状态',
            align: "center",
            dataIndex: 'status',
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
          list: "/shoeDistributor/shoeDistributor/withdrawalList",
        },
        dictOptions:{},
        superFieldList:[],
      }
    },
    created() {
    this.getSuperFieldList();
    },
    computed: {
    },
    methods: {
      initDictConfig(){
      },
      getSuperFieldList(){
        let fieldList=[];
        fieldList.push({type:'int',value:'promotionWithdrawalId',text:'提现id'})
        fieldList.push({type:'int',value:'promotionId',text:'推广人id'})
        fieldList.push({type:'int',value:'amount',text:'提现金额'})
        fieldList.push({type:'int',value:'type',text:'类型：1=银行卡'})
        fieldList.push({type:'int',value:'status',text:'状态：0=审核中，1=提现中，2=审核失败,3=已提现'})
        fieldList.push({type:'string',value:'cardNo',text:'银行卡号'})
        fieldList.push({type:'string',value:'bank',text:'银行'})
        fieldList.push({type:'string',value:'openBank',text:'开户行'})
        fieldList.push({type:'string',value:'cardName',text:'持卡人'})
        fieldList.push({type:'string',value:'note',text:'备注'})
        fieldList.push({type:'date',value:'auditTime',text:'审核时间'})
        fieldList.push({type:'date',value:'transferTime',text:'转账时间'})
        fieldList.push({type:'string',value:'auditUserId',text:'审核人id'})
        fieldList.push({type:'string',value:'auditName',text:'审核人'})
        fieldList.push({type:'string',value:'transferUserId',text:'确认转账人id'})
        fieldList.push({type:'string',value:'transferName',text:'确认转账人'})
        this.superFieldList = fieldList
      },
      showDetail(record) {
        this.$refs.shoeDistributorWithdrawalDetail.show(record);
      },
      handleAudit(record) {
        this.$refs.shoeDistributorAudit.show(record);
      },
      handleTransfer(record) {
        this.$refs.shoeDistributorTransfer.show(record);
      }
    }
  }
</script>
<style scoped>
  @import '~@assets/less/common.less';
</style>