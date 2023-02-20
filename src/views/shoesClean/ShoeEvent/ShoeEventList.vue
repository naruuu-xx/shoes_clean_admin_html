<template>
  <a-card :bordered="false">
    <!-- 查询区域 -->
    <div class="table-page-search-wrapper">
      <a-form layout="inline" @keyup.enter.native="searchQuery">
        <a-row :gutter="24">
          <a-col :xl="4" :lg="7" :md="8" :sm="24">
            <a-form-item label="活动名称">
              <a-input placeholder="请输入名称" v-model="queryParam.name"></a-input>
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
    <!-- 查询区域-END -->

    <!-- 操作按钮区域 -->
    <div class="table-operator">
<!--      <a-button @click="handleAdd" type="primary" icon="plus">新增</a-button>-->
<!--      <a-button type="primary" icon="download" @click="handleExportXls('shoe_coupon')">导出</a-button>-->
<!--      <a-upload name="file" :showUploadList="false" :multiple="false" :headers="tokenHeader" :action="importExcelUrl" @change="handleImportExcel">-->
<!--        <a-button type="primary" icon="import">导入</a-button>-->
<!--      </a-upload>-->
      <!-- 高级查询区域 -->
<!--      <j-super-query :fieldList="superFieldList" ref="superQueryModal" @handleSuperQuery="handleSuperQuery"></j-super-query>-->
<!--      <a-dropdown v-if="selectedRowKeys.length > 0">-->
<!--        <a-menu slot="overlay">-->
<!--          <a-menu-item key="1" @click="batchDel"><a-icon type="delete"/>删除</a-menu-item>-->
<!--        </a-menu>-->
<!--        <a-button style="margin-left: 8px"> 批量操作 <a-icon type="down" /></a-button>-->
<!--      </a-dropdown>-->
    </div>

    <!-- table区域-begin -->
    <div>
<!--      <div class="ant-alert ant-alert-info" style="margin-bottom: 16px;">-->
<!--        <i class="anticon anticon-info-circle ant-alert-icon"></i> 已选择 <a style="font-weight: 600">{{ selectedRowKeys.length }}</a>项-->
<!--        <a style="margin-left: 24px" @click="onClearSelected">清空</a>-->
<!--      </div>-->

      <a-table
        ref="table"
        size="middle"
        :scroll="{x:true}"
        bordered
        rowKey="couponId"
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
          <img v-else :src="getImgView(text)" :preview="record.couponId" height="25px" alt="" style="max-width:80px;font-size: 12px;font-style: italic;"/>
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

        <span  slot="action" slot-scope="text, record">
          <a v-if="record.eventName=='每周五自动发放卡包'" @click="cardBagSelect(record.id, record.couponId)">设置</a>

          <a v-if="record.eventName=='拉新活动'" @click="couponSelect(record.id, record.couponId)">优惠券设置</a>
          <a-divider v-if="record.eventName=='拉新活动'" type="vertical" />
          <a v-if="record.eventName=='拉新活动'" @click="queryEventDetail">查看详情</a>

        </span>


        <span slot="statusAction" slot-scope="text, record">
          <a-switch v-model:checked="record.eventStatus" @click="switchChange(record.eventStatusGroup, record.eventStatusName, record.eventStatus)" />
        </span>
      </a-table>

<!--      <a-row type="flex" justify="space-around" align="middle" style="border-top: 1px solid #000000;border-bottom: 1px solid #000000">-->
<!--        <a-col :span="6"><div class="tableHeader">活动名称</div></a-col>-->
<!--        <a-col :span="6"><div class="tableHeader">参加人数</div></a-col>-->
<!--        <a-col :span="6"><div class="tableHeader">状态</div></a-col>-->
<!--        <a-col :span="6"><div class="tableHeader">操作</div></a-col>-->
<!--      </a-row>-->
<!--      <a-row type="flex" justify="space-around" align="middle" :key="index" v-for="(item,index) in eventList" style="border-bottom: 1px solid #000000">-->
<!--        <a-col :span="6"><div class="tableCell">{{item.eventName}}</div></a-col>-->
<!--        <a-col :span="6"><div class="tableCell">{{item.participationNum}}</div></a-col>-->
<!--        <a-col :span="6"><div class="tableCell"><a-switch v-model:checked="item.eventStatus" @click="switchChange(item.eventStatusGroup, item.eventStatusName, item.eventStatus)" /></div></a-col>-->
<!--        <a-col :span="6">-->
<!--          <div class="tableCell" v-if="item.id === 1">-->
<!--            <a @click="couponSelect(item.id, item.couponId)">优惠券设置</a>-->
<!--            <a-divider type="vertical" />-->
<!--            <a @click="queryEventDetail">查看详情</a>-->
<!--          </div>-->
<!--          <div class="tableCell" v-else>-->
<!--          </div>-->
<!--        </a-col>-->
<!--      </a-row>-->
    </div>

<!--    <shoe-coupon-modal ref="modalForm" @ok="modalFormOk"></shoe-coupon-modal>-->

    <coupon-select-modal ref="couponSelectModal" @ok="queryEventList"></coupon-select-modal>
    <user-pull-detail-modal ref="userPullDetailModal"></user-pull-detail-modal>
    <AutoSendCardBagSelectModal ref="autoSendCardBagSelectModal"></AutoSendCardBagSelectModal>
  </a-card>
</template>

<script>

  import '@/assets/less/TableExpand.less'
  import { mixinDevice } from '@/utils/mixin'
  import { JeecgListMixin } from '@/mixins/JeecgListMixin'
  import {filterDictTextByCache} from "../../../components/dict/JDictSelectUtil";
  import {httpAction} from "../../../api/manage";
  import CouponSelectModal from "./modules/CouponSelectModal";
  import UserPullDetailModal from "./modules/UserPullDetailModal";
  import AutoSendCardBagSelectModal from "@views/shoesClean/ShoeEvent/modules/AutoSendCardBagSelectModal";

  export default {
    name: 'ShoeCouponList',
    mixins:[JeecgListMixin, mixinDevice],
    components: {
      CouponSelectModal,
      UserPullDetailModal,
      AutoSendCardBagSelectModal
    },
    data () {
      return {
        description: '活动管理页面',
        // 表头
        columns: [
          {
            title:'活动名称',
            align:"center",
            dataIndex: 'eventName'
          },
          {
            title:'参与人数',
            align:"center",
            dataIndex: 'participationNum'
          },
          {
            title:'状态',
            align:"center",
            // dataIndex: 'statusAction',
            scopedSlots: { customRender: 'statusAction' }
          },
          {
            title: '操作',
            dataIndex: 'action',
            align:"center",
            fixed:"right",
            width:147,
            scopedSlots: { customRender: 'action' }
          }
        ],
        url: {
          list: "/ShoeEvent/ShoeEvent/queryEventList",
          // delete: "/ShoeCoupon/shoeCoupon/delete",
          // deleteBatch: "/ShoeCoupon/shoeCoupon/deleteBatch",
          // exportXlsUrl: "/ShoeCoupon/shoeCoupon/exportXls",
          // importExcelUrl: "ShoeCoupon/shoeCoupon/importExcel",

        },
        dictOptions:{},
        superFieldList:[],
        eventList: []
      }
    },
    created() {
      this.getSuperFieldList();
      //调用查询活动列表接口
      this.queryEventList();
    },
    computed: {
      importExcelUrl: function(){
        return `${window._CONFIG['domianURL']}/${this.url.importExcelUrl}`;
      },
    },
    methods: {
      initDictConfig(){
      },
      getSuperFieldList(){
        let fieldList=[];
        this.superFieldList = fieldList
      },
      queryEventList() {
        httpAction("/ShoeEvent/ShoeEvent/queryEventList", null, "get").then((res) => {
          if (res.success) {
            this.eventList = res.result;
          }
        })
      },
      switchChange(eventStatusGroup, eventStatusName, eventStatus) {
        //请求接口，更改活动开关
        let data = {
          "eventStatusGroup": eventStatusGroup,
          "eventStatusName": eventStatusName,
          "eventStatus": eventStatus
        }
        httpAction("/ShoeEvent/ShoeEvent/updateEventStatus", data, "post").then((res) => {
          if (res.success){
            this.$message.success(res.message);
            this.queryEventList();
          }
        });
      },
      couponSelect(id,couponId){
        this.$refs.couponSelectModal.show(id,couponId);
        this.queryEventList();
      },
      cardBagSelect(id,couponId){
        this.$refs.autoSendCardBagSelectModal.show(id,couponId);
        this.queryEventList();
      },
      queryEventDetail(){
        this.$refs.userPullDetailModal.show();
        this.queryEventList();
      }
    }
  }
</script>
<style scoped>
  @import '~@assets/less/common.less';

  .tableHeader{
    font-size: 16px;
    text-align:center;
    margin: 16px 0 16px 0;
  }
  .tableCell{
    font-size: 14px;
    text-align:center;
    margin: 14px 0 14px 0;
  }
</style>