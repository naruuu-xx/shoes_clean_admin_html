<template>
  <a-card :bordered="false">
    <!-- 查询区域 -->
    <div class="table-page-search-wrapper">
      <a-form layout="inline" @keyup.enter.native="searchQuery">
        <a-row :gutter="24">
          <a-col :xl="3" :lg="7" :md="8" :sm="24">
            <a-form-item label=" 姓名">
              <a-input placeholder="请输入 姓名" v-model="queryParam.name" autocomplete="off"></a-input>
            </a-form-item>
          </a-col>
          <a-col :xl="3" :lg="7" :md="8" :sm="24">
            <a-form-item label="接单状态">
              <a-select v-model="queryParam.orderStatus">
                <a-select-option :value="1" >正常接单</a-select-option>
                <a-select-option :value="0" >停止接单</a-select-option>
              </a-select>
            </a-form-item>
          </a-col>
          <a-col :xl="4" :lg="7" :md="8" :sm="24" v-has="'area:list'">
            <a-form-item label=" 区域">
              <xf-select
                style="width: 100%"
                isInternalData
                v-model="queryParam.orgCode"
                :url='`/sysDepart/getSysDepartList`'
              >
              </xf-select>
            </a-form-item>
          </a-col>
          <template v-if="toggleSearchStatus">
            <a-col :xl="6" :lg="7" :md="8" :sm="24">
              <a-form-item label=" 电话">
                <a-input placeholder="请输入 电话" v-model="queryParam.phone"  autocomplete="off"></a-input>
              </a-form-item>
            </a-col>
                        <a-col :xl="10" :lg="11" :md="12" :sm="24">
                          <a-form-item label=" 加入时间">
                            <j-date :show-time="true" date-format="YYYY-MM-DD HH:mm:ss" placeholder="请选择开始时间" class="query-group-cust" v-model="queryParam.createTime_begin"></j-date>
                            <span class="query-group-split-cust"></span>
                            <j-date :show-time="true" date-format="YYYY-MM-DD HH:mm:ss" placeholder="请选择结束时间" class="query-group-cust" v-model="queryParam.createTime_end"></j-date>
                          </a-form-item>
                        </a-col>
          </template>
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
      <a-button @click="handleAdd" type="primary" icon="plus">新增</a-button>
      <!--      <a-button type="primary" icon="download" @click="handleExportXls('shoe_courier')">导出</a-button>-->
      <!--      <a-upload name="file" :showUploadList="false" :multiple="false" :headers="tokenHeader" :action="importExcelUrl" @change="handleImportExcel">-->
      <!--        <a-button type="primary" icon="import">导入</a-button>-->
      <!--      </a-upload>-->
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
        <template slot="imgSlot" slot-scope="text,record">
          <span v-if="!text" style="font-size: 12px;font-style: italic;">无图片</span>
          <img v-else :src="getImgView(text)" :preview="record.id" height="25px" alt=""
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

          <a @click="showSchedule(record)">排班</a>

          <a-divider type="vertical"/>

          <a-dropdown>
            <a class="ant-dropdown-link">更多 <a-icon type="down"/></a>
            <a-menu slot="overlay">
<!--              <a-menu-item>-->
<!--                <a @click="unbind(record.courierId)">解绑快递柜</a>-->
<!--              </a-menu-item>-->
<!--              <a-menu-item>-->
<!--                <a @click="handleDetail(record)">详情</a>-->
<!--              </a-menu-item>-->
              <a-menu-item>
                <a href="javascript:;" @click="handleChangePassword(record.phone, record.courierId)">密码</a>
              </a-menu-item>
              <a-menu-item>
                <a href="javascript:;" @click="showHistoryList(record.courierId,record.name)">订单</a>
              </a-menu-item>

              <a-menu-item>
                <a-popconfirm title="确定删除吗?" @confirm="() => handleDelete(record.courierId)">
                  <a>删除</a>
                </a-popconfirm>
              </a-menu-item>
            </a-menu>
          </a-dropdown>
        </span>

      </a-table>
    </div>

    <shoe-courier-modal ref="modalForm" @ok="modalFormOk"></shoe-courier-modal>
    <password-modal ref="passwordmodal" @ok="passwordModalOk"></password-modal>
    <shoe-schedule-list ref="ShoeScheduleList"></shoe-schedule-list>
    <shoe-courier-history-list ref="ShoeCourierHistoryList"></shoe-courier-history-list>

    <!-- 自定义的弹窗 -->
    <a-modal v-model:visible="scheduleVisible" title="配送员排班" :footer="null">
      <a-table :dataSource="dataSource" :columns="columns" />
    </a-modal>
    <!-- 自定义的弹窗 -->
    <a-modal v-model:visible="courierHistoryVisible" title="配送员历史订单" :footer="null">
      <a-table :dataSource="dataSource" :columns="columns" />
    </a-modal>


  </a-card>
</template>

<script>

import '@/assets/less/TableExpand.less'
import {mixinDevice} from '@/utils/mixin'
import {JeecgListMixin} from '@/mixins/JeecgListMixin'
import ShoeCourierModal from './modules/ShoeCourierModal'
import ShoeScheduleList from "./shoeSchedule/ShoeScheduleList";
import {filterDictTextByCache} from "../../../components/dict/JDictSelectUtil"
import PasswordModal from './modules/PasswordModal'
import {deleteAction} from "../../../api/manage";
import ShoeCourierHistoryList from "@views/shoesClean/shoeCourier/modules/ShoeCourierHistoryList";
import XfSelect from '@/components/Xf/XfSelect'

export default {
  name: 'ShoeCourierList',
  mixins: [JeecgListMixin, mixinDevice],
  components: {
    ShoeCourierModal,
    PasswordModal,
    ShoeScheduleList,
    ShoeCourierHistoryList,
    XfSelect
  },
  data() {
    return {
      description: 'shoe_courier管理页面',
      // 表头
      columns: [
        // {
        //   title: '#',
        //   dataIndex: '',
        //   key:'rowIndex',
        //   width:60,
        //   align:"center",
        //   customRender:function (t,r,index) {
        //     return parseInt(index)+1;
        //   }
        // },
        {
          title:' ID',
          align:"center",
          dataIndex: 'courierId'
        },
        {
          title: ' 姓名',
          align: "center",
          dataIndex: 'name'
        },
        {
          title:' 区域',
          align:"center",
          dataIndex: 'departName'
        },
        {
          title: '机柜数量',
          align: "center",
          dataIndex: 'lockerNum',
        },
        {
          title: ' 电话',
          align: "center",
          dataIndex: 'phone'
        },
        // {
        //   title:' 身份证',
        //   align:"center",
        //   dataIndex: 'idcard'
        // },
        // {
        //   title:' 密码',
        //   align:"center",
        //   dataIndex: 'password'
        // },
        {
          title: ' 总配送单数',
          align: "center",
          dataIndex: 'num'
        },
        {
          title: ' 总收入',
          align: "center",
          dataIndex: 'income',
          customRender: (text) => {
            return (text * 0.01).toFixed(2);
          }
        },
        {
          title: ' 账户金额',
          align: "center",
          dataIndex: 'amount',
          customRender: (text) => {
            return (text * 0.01).toFixed(2);
          }
        },
        {
          title: ' 可提现金额',
          align: "center",
          dataIndex: 'withdrawalAmount',
          customRender: (text) => {
            return (text * 0.01).toFixed(2);
          }
        },
        {
          title: ' 提现中金额',
          align: "center",
          dataIndex: 'withdrawalingAmount',
          customRender: (text) => {
            return (text * 0.01).toFixed(2);
          }
        },
        {
          title: ' 冻结金额',
          align: "center",
          dataIndex: 'frozenAmount',
          customRender: (text) => {
            return (text * 0.01).toFixed(2);
          }
        },
        {
          title: ' 登录状态',
          align: "center",
          dataIndex: 'status',
          customRender: (text) => {
            return filterDictTextByCache('shoe_courier_status', text);
          },
        },
        {
          title: '接单状态',
          align: "center",
          dataIndex: 'orderStatusText'
        },
        // {
        //   title: ' 删除状态',
        //   align: "center",
        //   dataIndex: 'delFlag',
        //   customRender: (text) => {
        //     return filterDictTextByCache('shoe_courier_del_flag', text);
        //   },
        // },
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
        // list: "/shoeCourier/shoeCourier/list",
        list: "/shoeCourier/shoeCourier/queryList",
        delete: "/shoeCourier/shoeCourier/delete",
        deleteBatch: "/shoeCourier/shoeCourier/deleteBatch",
        exportXlsUrl: "/shoeCourier/shoeCourier/exportXls",
        importExcelUrl: "shoeCourier/shoeCourier/importExcel",
        unbind: "/shoeCourier/shoeCourier/unbind"
      },
      dictOptions: {},
      superFieldList: [],
      scheduleVisible: false,
      courierHistoryVisible: false,

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
    handleChangePassword(phone, courierId) {
      this.$refs.passwordmodal.show(phone, courierId);
    },
    showHistoryList(courierId,name){

      this.$refs.ShoeCourierHistoryList.courierHistoryVisible = true;
      this.$refs.ShoeCourierHistoryList.initDataByDIY(courierId,name);
      this.$refs.ShoeCourierHistoryList.dataSource = [];
    },
    passwordModalOk() {
      //TODO 密码修改完成 不需要刷新页面，可以把datasource中的数据更新一下
    },
    showSchedule(record) {
      // console.log(record);
      // this.scheduleVisible = true;
      this.$refs.ShoeScheduleList.scheduleVisible = true;
      this.$refs.ShoeScheduleList.initDataByDIY(record.courierId);
      this.$refs.ShoeScheduleList.dataSource = [];
    },
    unbind(courierId){
      deleteAction(this.url.unbind, {id: courierId}).then((res) => {
        if (res.success) {
          //重新计算分页问题
          this.reCalculatePage(1)
          this.$message.success(res.message);
          this.loadData();
        } else {
          this.$message.warning(res.message);
        }
      });
    }
  }
}
</script>
<style scoped>
@import '~@assets/less/common.less';
</style>