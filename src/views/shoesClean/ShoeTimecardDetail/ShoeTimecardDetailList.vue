<template>
  <a-card :bordered="false">
    <!-- 查询区域 -->
    <div class="table-page-search-wrapper">
      <a-form layout="inline" @keyup.enter.native="searchQuery">
        <a-row :gutter="24">
          <a-col :xl="6" :lg="7" :md="8" :sm="24">
            <a-form-item label="手机号">
              <a-input placeholder="请输入手机号" v-model="queryParam.phone"></a-input>
            </a-form-item>
          </a-col>
          <a-col :xl="6" :lg="7" :md="8" :sm="24">
            <a-form-item label="用户名称">
              <a-input placeholder="请输入用户名称" v-model="queryParam.nickname"></a-input>
            </a-form-item>
          </a-col>
          <a-col :xl="6" :lg="7" :md="8" :sm="24">
            <a-form-item label="鞋蜂卡名称">
              <a-input placeholder="请输入鞋蜂卡名称" v-model="queryParam.name"></a-input>
            </a-form-item>
          </a-col>
          <a-col :xl="6" :lg="7" :md="8" :sm="24">
            <a-form-item label="来源">
              <a-select v-model="queryParam.source">
                <a-select-option v-for="item in sourceOptionList" :value="item.value" :key="item.value">
                  {{ item.name }}
                </a-select-option>
              </a-select>
            </a-form-item>
          </a-col>
          <a-col :xl="3" :lg="7" :md="8" :sm="24">
            <a-form-item label="来源">
              <a-select v-model="queryParam.status">
                <a-select-option v-for="item in statusOptionList" :value="item.value" :key="item.value">
                  {{ item.name }}
                </a-select-option>
              </a-select>
            </a-form-item>
          </a-col>
          <a-col :xl="3" :lg="7" :md="8" :sm="24">
            <a-form-item label="冻结状态">
              <a-select v-model="queryParam.timecardStatus">
                <a-select-option v-for="item in timecardStatusOptionList" :value="item.value" :key="item.value">
                  {{ item.name }}
                </a-select-option>
              </a-select>
            </a-form-item>
          </a-col>
          <a-col :xl="6" :lg="7" :md="8" :sm="24">
            <a-form-item label="开始时间">
              <a-range-picker v-model="queryParam.createTime"/>
            </a-form-item>
          </a-col>
          <a-col :xl="6" :lg="7" :md="8" :sm="24">
            <a-form-item label="过期时间">
              <a-range-picker v-model="queryParam.finishTime"/>
            </a-form-item>
          </a-col>
          <a-col :xl="6" :lg="7" :md="8" :sm="24">
            <a-button type="primary" @click="searchQuery" icon="search">查询</a-button>
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
        rowKey="id"
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

import '@/assets/less/TableExpand.less'
import {mixinDevice} from '@/utils/mixin'
import {JeecgListMixin} from '@/mixins/JeecgListMixin'
import moment from 'moment';
import {filterDictTextByCache} from "../../../components/dict/JDictSelectUtil";

export default {
  name: 'ShoeSetmealTimecardExchangeList',
  mixins: [JeecgListMixin, mixinDevice],
  components: {},
  data() {
    return {
      description: 'shoe_setmeal_timecard_exchange管理页面',
      // 表头
      columns: [
        {
          title: '手机号',
          align: "center",
          dataIndex: 'phone'
        },
        {
          title: '用户名称',
          align: "center",
          dataIndex: 'nickname'
        },
        {
          title: '来源',
          align: "center",
          dataIndex: 'source',
          customRender: (text) => {
            return filterDictTextByCache('shoe_user_timecard_source', text);
          },
        },
        {
          title: '鞋蜂卡名称',
          align: "center",
          dataIndex: 'name' 
        },
        {
          title: '使用双数',
          align: "center",
          dataIndex: 'usedNum'
        },
        {
          title: '剩余双数',
          align: "center",
          customRender:function (text, record){
            return record.num - record.usedNum;
          }
        },
        {
          title: '状态',
          align: "center",
          dataIndex: "status",
          customRender:function (text){
            return filterDictTextByCache('shoe_user_timecard_status', text);
          }
        },
        {
          title: '冻结状态',
          align: "center",
          dataIndex: "timecardStatus",
          customRender: (text) => {
            if (text == 0) {
              text = '冻结'
            } else text = '正常'
            return text;
          },
        },
        {
          title: '开始时间',
          align: "center",
          dataIndex: 'startTime',
        },
        {
          title: '过期时间',
          align: "center",
          dataIndex: 'endTime',
        },
      ],
      url: {
        list: "/shoeTimecardDetail/list",
      },
      dictOptions: {},
      queryParam: {
        createTime: [],
        createTimeLeft: '',
        createTimeRight: '',
        finishTimeLeft: '',
        finishTime: [],
      },
      statusOptionList: [
        {"value": "", "name": "全部"}, {"value": "0", "name": "未使用"}, {"value": "1", "name": "使用中"},
        {"value": "2", "name": "已使用"}
      ],
      sourceOptionList: [
        {"value": "", "name": "全部"}, {"value": "1", "name": "小程序购买"}, {"value": "2", "name": "兑换码兑换"},
        {"value": "3", "name": "三方平台"},{"value": "4", "name": "他人赠送"},{"value": "5", "name": "团购兑换"},{"value": "6", "name": "后台派发"}
      ],
      timecardStatusOptionList: [
        {"value": "", "name": "全部"}, {"value": "1", "name": "正常"}, {"value": "0", "name": "冻结"}
      ],
    }
  },
  created() {
  },
  watch: {
    'queryParam.createTime': {
      handler(newV) {
        if (newV.length) {
          this.queryParam.createTimeLeft = moment(newV[0]).format('YYYY-MM-DD')
          this.queryParam.createTimeright = moment(newV[1]).format('YYYY-MM-DD')
        } else {
          this.queryParam.createTimeLeft = ""
          this.queryParam.createTimeright = ""
        }
      },
      // immediate: true
    },
    'queryParam.finishTime': {
      handler(newV) {
        if (newV.length) {
          this.queryParam.finishTimeLeft = moment(newV[0]).format('YYYY-MM-DD')
          this.queryParam.finishTimeright = moment(newV[1]).format('YYYY-MM-DD')
        } else {
          this.queryParam.finishTimeLeft = ""
          this.queryParam.finishTimeright = ""
        }
      },
      // immediate: true
    }
  },
  computed: {
    importExcelUrl: function () {
      return `${window._CONFIG['domianURL']}/${this.url.importExcelUrl}`;
    },
  },
  methods: {
    initDictConfig() {
    },
  }
}
</script>
<style scoped>
@import '~@assets/less/common.less';
</style>