<template>
  <a-card :bordered="false">
    <!-- 查询区域 -->
    <div class="table-page-search-wrapper">
      <a-form layout="inline" @keyup.enter.native="searchQuery">
        <a-row :gutter="24">
        </a-row>
      </a-form>
    </div>
    <!-- 查询区域-END -->

    <!-- 操作按钮区域 -->
    <div class="table-operator">
      <a-button @click="handleAdd" type="primary" icon="plus">新增</a-button>
    </div>

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

        <span slot="action" slot-scope="text, record">
          <a @click="handleEdit(record)">编辑</a>
        </span>

      </a-table>
    </div>

    <shoe-setmeal-timecard-modal ref="modalForm" @ok="modalFormOk"></shoe-setmeal-timecard-modal>
  </a-card>
</template>

<script>

import '@/assets/less/TableExpand.less'
import {mixinDevice} from '@/utils/mixin'
import {JeecgListMixin} from '@/mixins/JeecgListMixin'
import ShoeSetmealTimecardModal from './modules/ShoeSetmealTimecardModal'
import {filterDictTextByCache} from "@comp/dict/JDictSelectUtil";

export default {
  name: 'ShoeSetmealTimecardList',
  mixins: [JeecgListMixin, mixinDevice],
  components: {
    ShoeSetmealTimecardModal
  },
  data() {
    return {
      description: 'shoe_setmeal_timecard管理页面',
      // 表头
      columns: [
        {
          title: '平台名称',
          align: "center",
          dataIndex: 'platform',
          customRender: (text) => {
            return filterDictTextByCache('setmealTimecard:platform', text);
          }
        },
        {
          title: '套餐名称',
          align: "center",
          dataIndex: 'setmeal'
        }, {
          title: '匹配关键词',
          align: "center",
          dataIndex: 'keyword'
        },
        {
          title: '次卡名称',
          align: "center",
          dataIndex: 'name'
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
      url: {
        list: "/shoeSetmealTimecard/list",


      },
      dictOptions: {},
      superFieldList: [],
    }
  },
  created() {
    this.getSuperFieldList();
  },
  computed: {
    importExcelUrl: function () {
      return `${window._CONFIG['domianURL']}/${this.url.importExcelUrl}`;
    },
  },
  methods: {
    initDictConfig() {
    },
    getSuperFieldList() {
      let fieldList = [];
      fieldList.push({type: 'int', value: 'setmealTimecardId', text: '套餐次卡兑换关系ID'})
      fieldList.push({type: 'int', value: 'platform', text: '平台：1=福州小洁'})
      fieldList.push({type: 'string', value: 'setmeal', text: '套餐内容'})
      fieldList.push({type: 'string', value: 'keyword', text: '套餐标识'})
      fieldList.push({type: 'int', value: 'timecardId', text: '次卡id'})
      fieldList.push({type: 'int', value: 'timecardNum', text: '一份套餐兑换次卡数量'})
      fieldList.push({type: 'string', value: 'note', text: '备注'})
      fieldList.push({type: 'string', value: 'addUserId', text: '添加人ID'})
      fieldList.push({type: 'string', value: 'editUserId', text: '最后修改人ID（首次添加为添加人id）'})
      this.superFieldList = fieldList
    }
  }
}
</script>
<style scoped>
@import '~@assets/less/common.less';
</style>