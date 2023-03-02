<template>
  <a-modal v-model:visible="visible" title="二级推广人" :footer="null" width="1200px">
    <!-- 查询区域-begin -->
    <div class="table-page-search-wrapper">
      <a-form layout="inline" @keyup.enter.native="searchQuery">
        <a-row :gutter="24">
          <a-col :xl="4" :lg="7" :md="8" :sm="24">
            <a-form-item label=" 昵称">
              <a-input placeholder="请输入昵称" v-model="queryParam.nickname"></a-input>
            </a-form-item>
          </a-col>
          <a-col :xl="4" :lg="7" :md="8" :sm="24">
            <a-form-item label=" 手机号">
              <a-input placeholder="请输入手机号" v-model="queryParam.phone"></a-input>
            </a-form-item>
          </a-col>
          <a-col :xl="5" :lg="7" :md="8" :sm="24">
                <span style="float: left;overflow: hidden;" class="table-page-search-submitButtons">
                  <a-button type="primary" @click="initDataByDIY2" icon="search">查询</a-button>
                  <a-button type="primary" @click="searchReset2" icon="reload" style="margin-left: 8px">重置</a-button>
                </span>
          </a-col>
        </a-row>
      </a-form>
    </div>

    <!-- table区域-begin -->
    <div>
      <a-table
        ref="table"
        size="middle"
        :scroll="{x:true}"
        bordered
        rowKey="distributorId"
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
          title:'昵称',
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