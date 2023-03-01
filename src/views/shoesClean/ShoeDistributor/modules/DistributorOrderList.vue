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
        :rowSelection="{selectedRowKeys: selectedRowKeys, onChange: onSelectChange}"
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
  name: "SecondDistributorList",
  mixins:[JeecgListMixin, mixinDevice],
  data () {
    return {
      queryParam:{},
      visible: false,
      distributorId: null,
      dataSource: [],
      ipagination: { total: 0},
      loading:false,
      url: {
        list: "/shoeDistributor/shoeDistributor/querySecondDistributorList",
      },
      columns: [
        {
          title:'订单编号',
          align:"center",
          dataIndex: 'nickname'
        },
        {
          title:'手机号',
          align:"center",
          dataIndex: 'phone'
        },
        {
          title:'总推新数',
          align:"center",
          dataIndex: 'num'
        },
        {
          title:'本月推新数',
          align:"center",
          dataIndex: 'monthNum'
        },
        {
          title:'今日推新数',
          align:"center",
          dataIndex: 'todayNum'
        },
        {
          title:'总完单数',
          align:"center",
          dataIndex: 'finishNum'
        },
        {
          title:'本月完单数',
          align:"center",
          dataIndex: 'monthFinishNum'
        },
        {
          title:'今日完单数',
          align:"center",
          dataIndex: 'todayFinishNum'
        },
        {
          title:'加入时间',
          align:"center",
          dataIndex: 'createTime'
        },
      ],
    }
  },
  created() {

  },
  methods: {
    initDataByDIY(distributorId) {
      this.queryParam.distributorId = distributorId;
      this.distributorId=distributorId;
      getAction(this.url.list+"?distributorId="+distributorId).then((res) => {
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
        "distributorId": this.distributorId,
        "nickname":this.queryParam.nickname,
        "phone":this.queryParam.phone
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