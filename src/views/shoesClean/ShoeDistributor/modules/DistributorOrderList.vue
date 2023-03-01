<template>
  <a-modal v-model:visible="visible" title="二级推广人" :footer="null" width="1200px">
    <!-- 查询区域-begin -->

    <!-- table区域-begin -->
    <div>
      <a-table
        ref="table"
        size="middle"
        :scroll="{x:true}"
        bordered
        rowKey="no"
        :columns="columns"
        :dataSource="dataSource"
        :pagination="ipagination"
        :loading="loading"
        class="j-table-force-nowrap"
        @change="handleTableChange">
        <template slot="htmlSlot" slot-scope="text">
          <div v-html="text"></div>
        </template>

      </a-table>
    </div>

  </a-modal>
</template>

<script>
import '@/assets/less/TableExpand.less'
import { mixinDevice } from '@/utils/mixin'
import { JeecgListMixin } from '@/mixins/JeecgListMixin'
import {getAction} from "../../../../api/manage";

export default {
  name: "DistributorOrderList",
  mixins:[JeecgListMixin, mixinDevice],
  data () {
    return {
      queryParam:{},
      visible: false,
      benefitDistributorId: null,
      dataSource: [],
      ipagination: { total: 0},
      loading:false,
      url: {
        list: "/shoeDistributor/shoeDistributor/queryDistributorOrderList",
      },
      columns: [
        {
          title:'订单编号',
          align:"center",
          dataIndex: 'no'
        },
        {
          title:'订单类型',
          align:"center",
          dataIndex: 'type'
        },
        {
          title:'实付金额',
          align:"center",
          dataIndex: 'actualPrice'
        },
        {
          title:'配送费/运费',
          align:"center",
          dataIndex: 'courierPrice'
        },
        {
          title:'收益比例',
          align:"center",
          dataIndex: 'percentage',
          customRender: (text) => {
            return text + '%';
          },
        },
        {
          title:'收益金额',
          align:"center",
          dataIndex: 'incomeAmount'
        },
        {
          title:'订单状态',
          align:"center",
          dataIndex: 'status'
        },
      ],
    }
  },
  created() {

  },
  methods: {
    initDataByDIY(benefitDistributorId) {
      this.queryParam.benefitDistributorId = benefitDistributorId;
      this.benefitDistributorId=benefitDistributorId;
      getAction(this.url.list+"?benefitDistributorId="+benefitDistributorId).then((res) => {
        if (res.success) {
          //把数据传入dataSource
          this.dataSource = res.result.records;
          this.ipagination.total = res.result.total;
        }
      })
    },
    searchReset2(){
      this.queryParam = {}
      this.initDataByDIY2();
    },
    initDataByDIY2() {
      let data = {
        "benefitDistributorId": this.benefitDistributorId
      }
      getAction(this.url.list,data).then((res) => {
        if (res.success) {
          //把数据传入dataSource
          this.dataSource = res.result.records;
          this.ipagination.current = 1;
          this.ipagination.total = res.result.total;
        }
      })
    },
  }
}
</script>

<style scoped>

</style>