<template>
  <div style="background-color: #FFFFFF">
  <a-table
    ref="table"
    size="middle"
    :scroll="{x:true}"
    bordered
    rowKey="promotionId"
    :columns="columns"
    :dataSource="dataSource"
    :pagination="ipagination"
    :loading="loading"
    class="j-table-force-nowrap"
    @change="handleTableChange">

    <span slot="action" slot-scope="text, record">
           <router-link :to=" '/shoesClean/ShoeInvestors/ShoeInvestorsInfoList/'+record.investorsId">详情</router-link>
    </span>
  </a-table>
  </div>
</template>

<script>
import {httpAction} from "@api/manage";
import { mixinDevice } from '@/utils/mixin'
import { JeecgListMixin } from '@/mixins/JeecgListMixin'

export default {
  name: "ShoeInvestorsTeamInfoList",
  mixins:[JeecgListMixin, mixinDevice],
  data() {
    return {
      description: 'shoe_investors管理页面',
      dataSource:[],
      // 表头
      columns: [

        {
          title: '受益人',
          align: "center",
          dataIndex: 'name'
        },
        {
          title: '机柜数',
          align: "center",
          dataIndex: 'num'
        },
        {
          title: '总订单',
          align: 'center',
          dataIndex: 'orderNum'
        },
        {
          title: '总收益',
          align: "center",
          dataIndex: 'income'
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
    }
  },
  created() {
    this.getList(this.$route.params.investorsId);
  },
  methods: {
    getList(investorsId) {

      httpAction("/shoes/shoeInvestors/TeamList?id="+investorsId, null, "get").then((res) => {
        if (res) {
          this.dataSource = res.result.records;
          console.log(res.result);
        }
      })
    }
  }
}
</script>

<style scoped>
@import '~@assets/less/common.less';
</style>