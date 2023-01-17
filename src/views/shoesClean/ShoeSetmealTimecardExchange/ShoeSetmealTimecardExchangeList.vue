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
          <!--          <a-col :xl="6" :lg="7" :md="8" :sm="24">-->
          <!--            <a-form-item label="平台名称">-->
          <!--              <a-input placeholder="请输入平台名称" v-model="queryParam.platform"></a-input>-->
          <!--            </a-form-item>-->
          <!--          </a-col>-->
          <a-col :xl="6" :lg="7" :md="8" :sm="24">
            <a-form-model-item label="平台名称" :labelCol="labelCol" :wrapperCol="wrapperCol">
              <a-select style="width: 120px" v-model="queryParam.platform">
                <a-select-option :value="item.id" v-for="(item,index) in platformList" :key="index">
                  {{ item.name }}
                </a-select-option>
              </a-select>
            </a-form-model-item>
          </a-col>


          <a-col :xl="6" :lg="7" :md="8" :sm="24">
            <a-form-item label="套餐名称">
              <a-input placeholder="请输入套餐名称" v-model="queryParam.setmeal"></a-input>
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
        class="j-table-force-nowrap">

      </a-table>
    </div>

    <shoe-setmeal-timecard-exchange-modal ref="modalForm" @ok="modalFormOk"></shoe-setmeal-timecard-exchange-modal>
  </a-card>
</template>

<script>
import '@/assets/less/TableExpand.less'
import {mixinDevice} from '@/utils/mixin'
import {JeecgListMixin} from '@/mixins/JeecgListMixin'
import ShoeSetmealTimecardExchangeModal from './modules/ShoeSetmealTimecardExchangeModal'

import '@/assets/less/TableExpand.less'
import {mixinDevice} from '@/utils/mixin'
import {JeecgListMixin} from '@/mixins/JeecgListMixin'
import ShoeSetmealTimecardExchangeModal from './modules/ShoeSetmealTimecardExchangeModal'
import {filterDictTextByCache} from "@comp/dict/JDictSelectUtil"

export default {
  name: 'ShoeSetmealTimecardExchangeList',
  mixins: [JeecgListMixin, mixinDevice],
  components: {
    ShoeSetmealTimecardExchangeModal
  },
  data() {
    return {
      description: 'shoe_setmeal_timecard_exchange管理页面',
      // 表头
      columns: [
        {
          title: '用户手机号码',
          align: "center",
          dataIndex: 'phone'
        },
        {
          title: '平台名称',
          align: "center",
          dataIndex: 'platform'
        },
        {
          title: '套餐名称',
          align: "center",
          dataIndex: 'setmeal'
        },
        {
          title: '是否兑换',
          align: "center",
          dataIndex: 'status'
        },
        {
          title: '购买时间',
          align: "center",
          dataIndex: 'exchangeTime',
          customRender: function (text) {
            return !text ? "" : (text.length > 10 ? text.substr(0, 10) : text)
          }
        },
        {
          title: '手机号',
          align: "center",
          dataIndex: 'phone'
        },
        {
          title: '平台名称',
          align: "center",
          dataIndex: 'platform',
          customRender: (text) => {
            return filterDictTextByCache('setmeal:exchange:name', text);
          }
        },
        {
          title: '套餐名称',
          align: "center",
          dataIndex: 'setmeal'
        },
        {
          title: '鞋蜂卡名称',
          align: "center",
          dataIndex: 'name'
        },
        {
          title: '是否兑换',
          align: "center",
          dataIndex: 'status',
          customRender: (text) => {
            return filterDictTextByCache('setmeal:exchange:status', text);
          }
        },
        {
          title: '购买时间',
          align: "center",
          dataIndex: 'createTime'

        },
        {
          title: '兑换时间',
          align: "center",
          dataIndex: 'exchangeTime'
        }
      ],
    url: {
      list: "/shoeSetmealTimecardExchange/shoeSetmealTimecardExchange/list",
        delete: "/shoeSetmealTimecardExchange/shoeSetmealTimecardExchange/delete",
        deleteBatch: "/shoeSetmealTimecardExchange/shoeSetmealTimecardExchange/deleteBatch",
        exportXlsUrl: "/shoeSetmealTimecardExchange/shoeSetmealTimecardExchange/exportXls",
        importExcelUrl: "shoeSetmealTimecardExchange/shoeSetmealTimecardExchange/importExcel",

      },
      platformList: [
        {
          name: '洁小兔',
          id: 1,
        },
      ],
      dictOptions: {},
    }
  },
  created() {
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