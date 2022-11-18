<template>
  <a-card :bordered="false">
    <!-- 查询区域 -->
    <div class="table-page-search-wrapper">
      <a-form layout="inline" @keyup.enter.native="searchQuery">
        <a-row :gutter="24">
          <a-col :xl="6" :lg="7" :md="8" :sm="24">
            <a-form-item label="机柜编号">
              <a-input placeholder="请输入机柜编号" v-model="queryParam.lockerCode"></a-input>
            </a-form-item>
          </a-col>
          <a-col :xl="6" :lg="7" :md="8" :sm="24">
            <a-form-item label="操作类型">
<!--              <a-input placeholder="请输入操作类型" v-model="queryParam.operationType"></a-input>-->
              <a-select v-model="queryParam.operationType">
                <a-select-option v-for="i in operationTypeList" :value="i.operationType+''" :key="i.operationType">{{i.operationType}}</a-select-option>
              </a-select>
            </a-form-item>
          </a-col>
          <a-col :xl="6" :lg="7" :md="8" :sm="24">
            <span style="float: left;overflow: hidden;" class="table-page-search-submitButtons">
              <a-button type="primary" @click="searchQuery" icon="search">查询</a-button>
              <a-button type="primary" @click="searchReset" icon="reload" style="margin-left: 8px">重置</a-button>
              <!--              <a @click="handleToggleSearch" style="margin-left: 8px">-->
              <!--                {{ toggleSearchStatus ? '收起' : '展开' }}-->
              <!--                <a-icon :type="toggleSearchStatus ? 'up' : 'down'"/>-->
              <!--              </a>-->
            </span>
          </a-col>
        </a-row>
      </a-form>
    </div>
    <!-- 查询区域-END -->

    <!-- 操作按钮区域 -->
    <div class="table-operator">
      <!--      <a-button @click="handleAdd" type="primary" icon="plus">新增</a-button>-->
      <!--      <a-button type="primary" icon="download" @click="handleExportXls('shoe_locker_log')">导出</a-button>-->
      <!--      <a-upload name="file" :showUploadList="false" :multiple="false" :headers="tokenHeader" :action="importExcelUrl" @change="handleImportExcel">-->
      <!--        <a-button type="primary" icon="import">导入</a-button>-->
      <!--      </a-upload>-->
      <!-- 高级查询区域 -->
      <!--      <j-super-query :fieldList="superFieldList" ref="superQueryModal" @handleSuperQuery="handleSuperQuery"></j-super-query>-->
      <a-dropdown v-if="selectedRowKeys.length > 0">
        <a-menu slot="overlay">
          <a-menu-item key="1" @click="batchDel">
            <a-icon type="delete"/>
            删除
          </a-menu-item>
        </a-menu>
        <a-button style="margin-left: 8px"> 批量操作
          <a-icon type="down"/>
        </a-button>
      </a-dropdown>
    </div>

    <!-- table区域-begin -->
    <div>
      <div class="ant-alert ant-alert-info" style="margin-bottom: 16px;">
        <i class="anticon anticon-info-circle ant-alert-icon"></i> 已选择 <a
        style="font-weight: 600">{{ selectedRowKeys.length }}</a>项
        <a style="margin-left: 24px" @click="onClearSelected">清空</a>
      </div>

      <a-table
        ref="table"
        size="middle"
        :scroll="{x:true}"
        bordered
        rowKey="logId"
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
        <template slot="imgSlot" slot-scope="text,record">
          <span v-if="!text" style="font-size: 12px;font-style: italic;">无图片</span>
          <img v-else :src="getImgView(text)" :preview="record.logId" height="25px" alt=""
               style="max-width:80px;font-size: 12px;font-style: italic;"/>
        </template>
        <template slot="fileSlot" slot-scope="text">
          <span v-if="!text" style="font-size: 12px;font-style: italic;">无文件</span>
          <a-button
            v-else
            :ghost="true"
            type="primary"
            icon="download"
            size="small"
            @click="downloadFile(text)">
            下载
          </a-button>
        </template>

        <span slot="action" slot-scope="text, record">
          <a @click="handleEdit(record)">编辑</a>

          <a-divider type="vertical"/>
          <a-dropdown>
            <a class="ant-dropdown-link">更多 <a-icon type="down"/></a>
            <a-menu slot="overlay">
              <a-menu-item>
                <a @click="handleDetail(record)">详情</a>
              </a-menu-item>
              <a-menu-item>
                <a-popconfirm title="确定删除吗?" @confirm="() => handleDelete(record.logId)">
                  <a>删除</a>
                </a-popconfirm>
              </a-menu-item>
            </a-menu>
          </a-dropdown>
        </span>

      </a-table>
    </div>

    <shoe-locker-log-modal ref="modalForm" @ok="modalFormOk"></shoe-locker-log-modal>
  </a-card>
</template>

<script>

import '@/assets/less/TableExpand.less'
import {mixinDevice} from '@/utils/mixin'
import {JeecgListMixin} from '@/mixins/JeecgListMixin'
import ShoeLockerLogModal from './modules/ShoeLockerLogModal'
import {httpAction} from "../../../api/manage";

export default {
  name: 'ShoeLockerLogList',
  mixins: [JeecgListMixin, mixinDevice],
  components: {
    ShoeLockerLogModal
  },
  data() {
    return {
      description: 'shoe_locker_log管理页面',
      // 表头
      columns: [
        {
          title: '日志id',
          align: "center",
          // sorter: true,
          dataIndex: 'logId'
        },
        {
          title: '机柜编号',
          align: "center",
          dataIndex: 'lockerCode'
        },
        {
          title: '格子号',
          align: "center",
          dataIndex: 'gridNumber'
        },
        {
          title: '操作类型',
          align: "center",
          dataIndex: 'operationType'
        },
        {
          title: '操作详情',
          align: "center",
          dataIndex: 'operationComment'
        },
        {
          title: '时间',
          align: "center",
          dataIndex: 'createTime'
        },
        // {
        //   title: '操作',
        //   dataIndex: 'action',
        //   align:"center",
        //   fixed:"right",
        //   width:147,
        //   scopedSlots: { customRender: 'action' }
        // }
      ],
      url: {
        // list: "/ShoeLockerLog/shoeLockerLog/list",
        list: "/ShoeLockerLog/shoeLockerLog/queryList",
        delete: "/ShoeLockerLog/shoeLockerLog/delete",
        deleteBatch: "/ShoeLockerLog/shoeLockerLog/deleteBatch",
        exportXlsUrl: "/ShoeLockerLog/shoeLockerLog/exportXls",
        importExcelUrl: "ShoeLockerLog/shoeLockerLog/importExcel",

      },
      dictOptions: {},
      superFieldList: [],
      operationTypeList: [],
    }
  },
  created() {
    this.getSuperFieldList();
    this.getOperationTypeList();
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
      fieldList.push({type: 'int', value: 'logId', text: '日志id', dictCode: ''})
      fieldList.push({type: 'string', value: 'lockerCode', text: '机柜编号', dictCode: ''})
      fieldList.push({type: 'string', value: 'gridNumber', text: '格子号', dictCode: ''})
      fieldList.push({type: 'string', value: 'operationType', text: '操作类型', dictCode: ''})
      fieldList.push({type: 'string', value: 'operationComment', text: '操作详情', dictCode: ''})
      fieldList.push({type: 'date', value: 'createTime', text: '操作时间'})
      this.superFieldList = fieldList
    },
    getOperationTypeList(){
      httpAction("/ShoeLockerLog/shoeLockerLog/getOperationTypeList", null, "get").then((res) => {
        if (res.success){
          this.operationTypeList = res.result;
        }
      })
    }
  }
}
</script>
<style scoped>
@import '~@assets/less/common.less';
</style>