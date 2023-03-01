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


      <a-table
        ref="table"
        size="middle"
        :scroll="{x:true}"
        bordered
        rowKey="investorsWithdrawalId"
        :columns="columns"
        :dataSource="dataSource"
        :pagination="ipagination"
        :loading="loading"

        class="j-table-force-nowrap"
        @change="handleTableChange">


        <span slot="action" slot-scope="text, record">
          <a @click="showDetail(record)" v-has="'Withdrawal:Detail'">详情</a>

          <a-divider type="vertical" v-if="record.status==0" v-has="'Withdrawal:Audit'"/>
          <a @click="handleAudit(record)" v-if="record.status==0" v-has="'Withdrawal:Audit'">审核</a>
          <a-divider type="vertical" v-if="record.status==1" v-has="'Withdrawal:Transfer'"/>
          <a @click="handleTransfer(record)" v-if="record.status==1" v-has="'Withdrawal:Transfer'">确认</a>
        </span>

      </a-table>
    </div>
    <ShoeInvestorsWithdrawalDetail ref="ShoeInvestorsWithdrawalDetail"></ShoeInvestorsWithdrawalDetail>
    <ShoeInvestorsAudit ref="ShoeInvestorsAudit" @ok="modalFormOk"></ShoeInvestorsAudit>
    <ShoeInvestorsTransfer ref="ShoeInvestorsTransfer" @ok="modalFormOk"></ShoeInvestorsTransfer>
  </a-card>
</template>

<script>
import {mixinDevice} from '@/utils/mixin'
import {JeecgListMixin} from '@/mixins/JeecgListMixin'
import '@/assets/less/TableExpand.less'
import {filterDictTextByCache, filterMultiDictText} from '@comp/dict/JDictSelectUtil'
import {getFileAccessHttpUrl, httpAction} from '@api/manage'
import ShoeInvestorsWithdrawalDetail from "@views/shoesClean/ShoeInvestors/modules/ShoeInvestorsWithdrawalDetail";
import ShoeInvestorsAudit from "@views/shoesClean/ShoeInvestors/modules/ShoeInvestorsAudit";
import ShoeInvestorsTransfer from "@views/shoesClean/ShoeInvestors/modules/ShoeInvestorsTransfer";

export default {
  name: "ShoeInvestorsWithdrawalList",
  mixins: [JeecgListMixin, mixinDevice],
  components: {
    ShoeInvestorsWithdrawalDetail,
    ShoeInvestorsAudit,
    ShoeInvestorsTransfer
  },
  data() {
    return {
      dataSource: [],
      statusOptionList: [{"value": "0", "name": "审核中"}, {"value": "1", "name": "提现中"}, {
        "value": "2",
        "name": "审核失败"
      }, {"value": "3", "name": "已提现"}],
      description: 'shoe_investors_withdrawal管理页面',
      queryParam: {
        status: ''
      },
      // 表头
      columns: [
        {
          title: '申请人',
          align: "center",
          dataIndex: 'name'
        },
        {
          title: '提现金额',
          align: "center",
          dataIndex: 'amount'
        },
        {
          title: '申请时间',
          align: "center",
          dataIndex: 'createTime'
        },
        {
          title: '审核时间',
          align: "center",
          dataIndex: 'auditTime',
          customRender: (text) => {
            if (text == null) {
              let show = "-";
              return show;
            } else return text;
          },
        },
        {
          title: '提现时间',
          align: "center",
          dataIndex: 'transferTime',
          customRender: (text) => {
            if (text == null) {
              let show = "-";
              return show;
            } else return text;
          },

        },
        {
          title: '操作人',
          align: "center",
          dataIndex: 'auditName',
          customRender: (text) => {
            if (text == null) {
              let show = "-";
              return show;
            } else return text;

          },
        },
        {
          title: '状态',
          align: "center",
          dataIndex: 'status',
          customRender: (text) => {
            return filterDictTextByCache('withdrawal_status', text);
          }
        },
        {
          title: '操作',
          dataIndex: 'action',
          align: "center",
          fixed: "right",
          width: 147,
          scopedSlots: {customRender: 'action'}
        }
      ],
      url: {
        list: "/shoes/shoeInvestors/withdrawalList",
      },
    }
  },
  create() {

  },
  methods: {
    showDetail(record) {
      this.$refs.ShoeInvestorsWithdrawalDetail.show(record);
    },
    handleAudit(record) {
      this.$refs.ShoeInvestorsAudit.show(record);
    },
    handleTransfer(record) {
      this.$refs.ShoeInvestorsTransfer.show(record);
    }


  }
}
</script>


<style scoped>

</style>