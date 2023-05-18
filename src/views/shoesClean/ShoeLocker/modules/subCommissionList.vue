<template>
  <a-modal v-model:visible="visible" title="机柜分佣人" :footer="null" width="1200px">
    <!-- 查询区域-begin -->
    <div class="table-page-search-wrapper">
      <a-form layout="inline" @keyup.enter.native="searchQuery">
        <a-row :gutter="24">
          <a-col :xl="5" :lg="7" :md="8" :sm="24">
            <a-form-item label="姓名">
              <a-input placeholder="输入姓名" v-model="queryParam.name"></a-input>
            </a-form-item>
          </a-col>
          <a-col :xl="5" :lg="7" :md="8" :sm="24">
            <a-form-item label="手机号">
              <a-input placeholder="输入手机号" v-model="queryParam.phone"></a-input>
            </a-form-item>
          </a-col>
          <a-col :xl="5" :lg="7" :md="8" :sm="24">
            <a-form-item label="绑定状态">
              <a-select v-model="queryParam.status" style="width: 120px" :options="statusOption">
              </a-select>
            </a-form-item>
          </a-col>
          <a-col :xl="6" :lg="7" :md="8" :sm="24">
            <a-form-item label="绑定时间">
              <a-range-picker v-model="queryParam.createTime" />
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
import '@assets/less/TableExpand.less'
import {mixinDevice} from '@/utils/mixin'
import {JeecgListMixin} from '@/mixins/JeecgListMixin'
import {getAction, httpAction} from "@api/manage";
import moment from 'moment'

export default {
  name: "subCommissionList",
  mixins: [JeecgListMixin, mixinDevice],
  data() {
    return {
      queryParam: {
        createTimeLeft: '',
        createTimeRight: '',
        createTime: [],
      },
      visible: false,
      id: null,
      dataSource: [],
      ipagination: {total: 0},
      loading: false,
      url: {
        list: "/shoes/shoeInvestors/getCommissionerList",
      },
      statusOption: [{
        label: '全部',
        value: ''
      }, {
        label: '已失效',
        value: 0
      }, {
        label: '生效中',
        value: 1
      }],
      columns: [
        {
          title: '姓名',
          align: "center",
          dataIndex: 'name'
        },
        {
          title: '手机号',
          align: "center",
          dataIndex: 'phone'
        },
        {
          title: '收益比例',
          align: "center",
          dataIndex: 'percentage'
        },{

        title: '收益总金额',
        align: "center",
        dataIndex: 'totalIncomeAmount'
        },
        {
          title: '绑定状态',
          align: "center",
          dataIndex: 'statusText'
        },
        {
          title: '绑定时间',
          align: "center",
          dataIndex: 'createTime'
        },
        {
          title: '解绑时间',
          align: "center",
          dataIndex: 'deleteTime'
        },

      ],
    }
  },
  created() {

  },
  watch: {
    'queryParam.createTime': {
      handler(newV) {
        if (newV.length) {
          let [createTimeLeft, createTimeRight] = newV.map(item => moment(item).format('YYYY-MM-DD'))
          this.queryParam.createTimeLeft = createTimeLeft
          this.queryParam.createTimeRight = createTimeRight
        } else {
          this.queryParam.createTimeLeft = ""
          this.queryParam.createTimeRight = ""
        }
      },
      // immediate: true
    },
  },
  methods: {
    show(record) {
      this.visible = true;
      this.id = record.lockerId;
      this.initDataByDIY(record);
    },
    stopStatus(record) {

    },
    startStatus(record) {

    },
    initDataByDIY(record) {
      this.queryParam.id = record.userId;
      getAction(this.url.list + "?id=" + this.id).then((res) => {
        if (res.success) {
          //把数据传入dataSource
          this.dataSource = res.result.records;
          this.ipagination.total = res.result.total;
        }
      })
    },
    searchReset2() {
      this.queryParam = {id: this.id}
      this.initDataByDIY2();
    },
    initDataByDIY2() {
      let data = {
        "id": this.id,
        "name": this.queryParam.name,
        "status": this.queryParam.status,
        "createTimeLeft": this.queryParam.createTimeLeft,
        "createTimeRight": this.queryParam.createTimeRight,
      }
      getAction(this.url.list, data).then((res) => {
        if (res.success) {
          //把数据传入dataSource
          this.dataSource = res.result.records;
          this.ipagination.current = 1;
          this.ipagination.total = res.result.total;
        }
      })
    },
    initDataByDIY3() {
      let data = {
        "id": this.id,
        "name": this.queryParam.name,
        "status": this.queryParam.status,
        "delFlag": this.queryParam.delFlag,
        "pageNo":this.ipagination.current,
        "pageSize":this.ipagination.pageSize,
      }
      getAction(this.url.list, data).then((res) => {
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

</style>