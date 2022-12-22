<template>
  <a-card :bordered="false">
    <!-- 查询区域 -->
    <div class="table-page-search-wrapper">
      <a-form layout="inline" @keyup.enter.native="searchQuery">
        <a-row :gutter="24">
          <a-col :md="6" :sm="8">
            <a-form-item label="订单编号">
              <a-input placeholder="请输入订单编号" v-model="queryParam.no"></a-input>
            </a-form-item>
          </a-col>
          <a-col :md="6" :sm="8">
            <a-form-item label="机柜名称">
              <a-input placeholder="请输入机柜名称" v-model="queryParam.name"></a-input>
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
  name: "ShoeInvestorsInfoList",
  mixins:[JeecgListMixin, mixinDevice],

  data() {
    return {
      description: 'shoe_investors管理页面',
      dataSource:[],
      statusOptionList: [{"value":"0", "name":"未入账"}, {"value":"1", "name":"已入账"}, {"value":"2", "name":"已退款"}],
      url: {
        list: "/shoes/shoeInvestors/InvestorsList",
      },
      // 表头
      columns: [

        {
          title: '订单编号',
          align: "center",
          dataIndex: 'no'
        },
        {
          title: '机柜名称',
          align: "center",
          dataIndex: 'name'
        },
        {
          title: '机柜收益',
          align: 'center',
          dataIndex: 'percentage',
          customRender: (text) => {
            let percentage = (text * 100).toFixed(0) + "%";
            return percentage;
          },
        },
        {
          title: '实付金额',
          align: "center",
          dataIndex: 'actualPrice'
        },
        {
          title: '订单状态',
          align: "center",
          dataIndex: 'status',
          customRender: (text) => {
            return filterDictTextByCache('investors_order_status', text);
          }
        },

        {
          title: '收益金额',
          align: "center",
          dataIndex: 'incomeAmount'
        },
      ],
    }
  },
  create() {
    //this.getList(this.$route.params.investorsId);
    // console.log("=======",this.queryParam)
    // this.queryParam.id=this.$route.params.investorsId;
  },
  methods: {
    // getList(investorsId) {
    //   //this.url.list = "/shoes/shoeInvestors/InvestorsList?id="+investorsId,
    //   httpAction("/shoes/shoeInvestors/InvestorsList?investorsId="+investorsId, null, "get").then((res) => {
    //     if (res) {
    //       this.dataSource = res.result;
    //       console.log(res.result);
    //
    //     }
    //   })
    // },

  }
}
</script>

<style scoped>
@import '~@assets/less/common.less';
</style>