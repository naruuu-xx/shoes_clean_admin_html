<template>
  <a-modal v-model:visible="courierHistoryVisible" title="配送员订单" :footer="null" width="1200px">
        <div class="table-page-search-wrapper">
          <a-form layout="inline" @keyup.enter.native="searchQuery">
            <a-row :gutter="24">
              <a-col :xl="4" :lg="7" :md="8" :sm="24">
                <a-form-item label=" 姓名:">
                  {{ name }}
                </a-form-item>
              </a-col>

              <a-col :xl="5" :lg="7" :md="8" :sm="24">
                <a-form-item label=" 订单编号">
                  <a-input placeholder="请输入 订单编号" v-model="queryParam.noc"></a-input>
                </a-form-item>
              </a-col>
<!--              <a-col :xl="6" :lg="7" :md="8" :sm="24">-->
<!--                <a-form-item label=" 开始时间">-->
<!--                  <a-input placeholder="请输入 开始时间" v-model="queryParam.startTime"></a-input>-->
<!--                </a-form-item>-->
<!--              </a-col>-->
<!--              <a-col :xl="6" :lg="7" :md="8" :sm="24">-->
<!--                <a-form-item label=" 结束时间">-->
<!--                  <a-input placeholder="请输入 结束时间" v-model="queryParam.endTime"></a-input>-->
<!--                </a-form-item>-->
<!--              </a-col>-->
              <a-col :xl="5" :lg="7" :md="8" :sm="24">
                <a-form-item label="接单时间">
                  <j-date placeholder="请选择时间" v-model="queryParam.createStartTime"></j-date>
                </a-form-item>
              </a-col>
              <a-col :xl="6" :lg="7" :md="8" :sm="24">
                <a-form-item label="接单截止时间">
                  <j-date placeholder="请选择时间" v-model="queryParam.createEndTime"></j-date>
                </a-form-item>
              </a-col>
              <a-col :xl="6" :lg="7" :md="8" :sm="24">
                <a-form-item label="订单状态">

                  <a-select v-model="queryParam.status" style="width: 130px;">
                    <a-select-option v-for="item in statusOptionList" :value="item.value" :key="item.value">
                      {{ item.name }}
                    </a-select-option>
                  </a-select>
                </a-form-item>
              </a-col>
<!--              <a-col :xl="7" :lg="7" :md="8" :sm="24">-->
<!--                <a-form-item label="接单时间">-->
<!--                  <a-range-picker @change="onChange" />-->
<!--                </a-form-item>-->
<!--              </a-col>-->
<!--              <a-col :xl="7" :lg="7" :md="8" :sm="24">-->
<!--                <a-form-item label="开始时间">-->
<!--                  <a-range-picker @change="onChange2" />-->
<!--                </a-form-item>-->
<!--              </a-col>-->

              <a-col :xl="5" :lg="7" :md="8" :sm="24">
                <a-form-item label="完成时间">
                  <j-date placeholder="请选择时间" v-model="queryParam.startTime"></j-date>
                </a-form-item>
              </a-col>
              <a-col :xl="6" :lg="7" :md="8" :sm="24">
                <a-form-item label="完成截止时间">
                  <j-date placeholder="请选择时间" v-model="queryParam.endTime"></j-date>
                </a-form-item>
              </a-col>

              <template v-if="toggleSearchStatus">

              </template>
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
        rowKey="courierId"
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

<!--    <shoe-schedule-modal ref="modalForm" @ok="modalFormOkByDIY"></shoe-schedule-modal>-->
  </a-modal>
</template>

<script>

import '@/assets/less/TableExpand.less'
import { mixinDevice } from '@/utils/mixin'
import { JeecgListMixin } from '@/mixins/JeecgListMixin'
import {deleteAction, getAction} from "../../../../api/manage";
import {filterDictTextByCache} from "@comp/dict/JDictSelectUtil";


export default {
  name:"",

  courierId: "",

  mixins:[JeecgListMixin, mixinDevice],
  components: {

  },
  data () {
    return {
      description: 'shoe_schedule管理页面',
      queryParam:{},
      statusOptionList: [{"value":"0", "name":"未完成"},{"value":"2", "name":"已完成"},{"value":"3", "name":"已取消"}],
      // 表头
      columns: [
        {
          title:' 订单编号',
          align:"center",
          dataIndex: 'noc'
        },
        {
          title:' 配送费(元)',
          align:"center",
          dataIndex: 'commission',
          customRender: (text) => {
            let commission = (text/100);
            return commission;
          },
        },
        {
          title:' 用户姓名',
          align:"center",
          dataIndex: 'name'
        },
        {
          title:' 用户手机号',
          align:"center",
          dataIndex: 'phone'
        },
        {
          title:' 订单状态',
          align:"center",
          dataIndex: 'status',
          customRender: (text) => {
            return filterDictTextByCache('courier_order_status', text);
          }
        },
        {
          title:' 接单时间',
          align:"center",
          dataIndex: 'createTime'
        },
        {
          title:' 完成时间',
          align:"center",
          dataIndex: 'putTime'
        },
      ],
      dictOptions:{},
      superFieldList:[],
      courierHistoryVisible: false,
      courierId: null,
      dataSource: [],
      ipagination: { total: 0},
      loading:false,
      url: {
        list: "/shoeCourier/shoeCourier/queryHistoryList",
      },
    }
  },

  methods: {
    initDataByDIY(courierId,name) {
      this.name=name;
      this.queryParam.id = courierId;
      this.courierId=courierId;
      getAction(this.url.list+"?id="+courierId).then((res) => {
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
        "id": this.courierId,
        "noc":this.queryParam.noc,
        "putStartTime":this.queryParam.startTime,
        "putEndTime":this.queryParam.endTime,
        "createStartTime":this.queryParam.createStartTime,
        "createEndTime":this.queryParam.createEndTime,
        "status":this.queryParam.status,
      }
      //getAction(this.url.list+"?id="+this.courierId+"&noc="+this.queryParam.noc+"&putStartTime="+this.queryParam.startTime+"&putEndTime="+this.queryParam.endTime).then((res) => {
        getAction(this.url.list,data).then((res) => {
        if (res.success) {
          //把数据传入dataSource
          this.dataSource = res.result.records;
          this.ipagination.total = res.result.total;
        }
      })
    },
  }
}
</script>
<style scoped>
@import '~@assets/less/common.less';
</style>