<template>
  <a-card :bordered="false">


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


      </a-table>
    </div>
  </a-card>
</template>

<script>
import {httpAction} from "@api/manage";
import { mixinDevice } from '@/utils/mixin'
import { JeecgListMixin } from '@/mixins/JeecgListMixin'
import {filterDictTextByCache} from "@comp/dict/JDictSelectUtil";

export default {
  name: "ShoesitemanagerList",
  mixins:[JeecgListMixin, mixinDevice],

  data() {
    return {
      description: 'shoe_sitemanager管理页面',
      dataSource:[],
      url: {
        list: "/shoes/shoeLocker/sitemanagerCourierList",
      },
      // 表头
      columns: [

        {
          title: '姓名',
          align: "center",
          dataIndex: 'name'
        },
        {
          title: '账号',
          align: "center",
          dataIndex: 'phone'
        },
        {
          title: '配送单数',
          align: "center",
          dataIndex: 'num'
        },
        {
          title: '订单总额',
          align: "center",
          dataIndex: 'income'
        },
        {
          title: '账户金额',
          align: "center",
          dataIndex: 'amount'
        },
        {
          title: '可提现金额',
          align: "center",
          dataIndex: 'withdrawalAmount'
        },
        {
          title: '冻结金额',
          align: "center",
          dataIndex: 'frozenAmount'
        },
        {
          title: '状态',
          align: "center",
          dataIndex: 'status',
          customRender: (text) => {
           if (text==0){
             text="禁用"
             return text;
           }else if (text==1){
             text="启用"
             return text;
           }
          }
        },

      ],
    }
  },
  create() {
  },
  methods: {
  }
}
</script>

<style scoped>
@import '~@assets/less/common.less';
</style>