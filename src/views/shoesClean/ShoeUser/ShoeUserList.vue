<template>
  <a-card :bordered="false">
    <!-- 查询区域 -->
    <div class="table-page-search-wrapper">
      <a-form layout="inline" @keyup.enter.native="searchQuery">
        <a-row :gutter="24">
          <a-col :xl="4" :lg="7" :md="8" :sm="24">
            <a-form-item label=" 用户昵称">
              <a-input placeholder="请输入用户昵称" v-model="queryParam.nickname" :allowClear="true"></a-input>
            </a-form-item>
          </a-col>
          <a-col :xl="4" :lg="7" :md="8" :sm="24">
            <a-form-item label=" 手机号">
              <a-input placeholder="请输入手机号" v-model="queryParam.phone" :allowClear="true"></a-input>
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
     <!-- <a-button @click="manualDistribute" type="primary">手动派发</a-button> -->
<!--      <a-button type="primary" icon="download" @click="handleExportXls('shoe_user')">导出</a-button>-->
<!--      <a-upload name="file" :showUploadList="false" :multiple="false" :headers="tokenHeader" :action="importExcelUrl" @change="handleImportExcel">-->
<!--        <a-button type="primary" icon="import">导入</a-button>-->
<!--      </a-upload>-->
<!--      &lt;!&ndash; 高级查询区域 &ndash;&gt;-->
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

<!--     TODO： 正式版发布时切记将 rowSelection 删去 -->
      <a-table
        ref="table"
        size="middle"
        :scroll="{x:true}"
        bordered
        rowKey="userId"
        :columns="columns"
        :dataSource="dataSource"
        :pagination="ipagination"
        :loading="loading"
        class="j-table-force-nowrap"
        @change="handleTableChange">

        <template slot="htmlSlot" slot-scope="text">
          <div v-html="text"></div>
        </template>
        <template slot="imgSlot" slot-scope="text,record">
          <span v-if="!text" style="font-size: 12px;font-style: italic;">无图片</span>
          <img v-else :src="getImgView(text)" :preview="record.userId" height="25px" alt="" style="max-width:80px;font-size: 12px;font-style: italic;"/>
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
          <a @click="handleDistribute(record)" v-has="'user:coupon'">派发</a>

          <a-divider type="vertical" v-has="'user:more'"/>
          <a-dropdown >
            <a class="ant-dropdown-link" v-has="'user:more'">更多 <a-icon type="down" /></a>
            <a-menu slot="overlay">
              <a-menu-item>
                <a @click="getCouponDetail(record)" v-has="'user:couponList'">优惠券列表</a>
              </a-menu-item>
            </a-menu>
          </a-dropdown>
        </span>

      </a-table>
    </div>

    <shoe-user-modal ref="modalForm" @ok="modalFormOk"></shoe-user-modal>

    <distribute-coupon-modal ref="distributeCouponModal" @ok="modalFormOk"></distribute-coupon-modal>

    <manual-distribute-coupon-modal ref="manualDistributeCouponModal" @submit="manualSubmit"></manual-distribute-coupon-modal>

    <coupon-list ref="couponList" ></coupon-list>
  </a-card>
</template>

<script>

  import '@assets/less/TableExpand.less'
  import { mixinDevice } from '@/utils/mixin'
  import { JeecgListMixin } from '@/mixins/JeecgListMixin'
  import ShoeUserModal from './modules/ShoeUserModal'
  import DistributeCouponModal from "./modules/DistributeCouponModal";
  import ManualDistributeCouponModal from "./modules/ManualDistributeCouponModal";
  import couponList from "@views/shoesClean/ShoeUser/modules/couponList";

  export default {
    name: 'ShoeUserList',
    mixins:[JeecgListMixin, mixinDevice],
    components: {
      ShoeUserModal,
      couponList,
      DistributeCouponModal,
      ManualDistributeCouponModal
    },
    data () {
      return {
        description: 'shoe_user管理页面',
        // 表头
        columns: [
          {
            title:'ID',
            align:"center",
            dataIndex: 'userId'
          },
          {
            title:'用户昵称',
            align:"center",
            dataIndex: 'nickname'
          },
          {
            title:'头像',
            align:"center",
            dataIndex: 'avatar',
            scopedSlots: {customRender: 'imgSlot'}
          },
          {
            title:'手机号码',
            align:"center",
            dataIndex: 'phone'
          },
          {
            title:'推荐人昵称',
            align:"center",
            dataIndex: 'referrer'
          },
          {
            title:'总消费金额',
            align:"center",
            dataIndex: 'actualAmount'
          },
          {
            title:'最近登录时间',
            align:"center",
            dataIndex: 'lastLoginTime',

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
          list: "/shoes/shoeUser/list",
          delete: "/shoes/shoeUser/delete",
          deleteBatch: "/shoes/shoeUser/deleteBatch",
          exportXlsUrl: "/shoes/shoeUser/exportXls",
          importExcelUrl: "shoes/shoeUser/importExcel",

        },
        dictOptions:{},
        superFieldList:[],
      }
    },
    created() {
    this.getSuperFieldList();
    },
    computed: {
      importExcelUrl: function(){
        return `${window._CONFIG['domianURL']}/${this.url.importExcelUrl}`;
      },
    },
    methods: {
      // 手动派券提交
      manualSubmit(data) {
        console.log('data',data);
        this.$refs.distributeCouponModal.show({});
      },
      initDictConfig(){
      },
      getCouponDetail(record){
        this.$refs.couponList.show(record);
      },
      getSuperFieldList(){
        let fieldList=[];
        fieldList.push({type:'string',value:'openId',text:'小程序open_id'})
        fieldList.push({type:'string',value:'pId',text:'推荐人用户id'})
        fieldList.push({type:'string',value:'nickname',text:'微信昵称'})
        fieldList.push({type:'string',value:'avatar',text:'头像'})
        fieldList.push({type:'string',value:'phone',text:'手机号码'})
        fieldList.push({type:'string',value:'payAmount',text:'总支付金额'})
        fieldList.push({type:'string',value:'actualAmount',text:'实际消费金额'})
        fieldList.push({type:'date',value:'lastLoginTime',text:'最近登录时间'})
        this.superFieldList = fieldList
      },
      handleDistribute(record) {
        this.$refs.distributeCouponModal.show(record);
      },
      manualDistribute(record) {
        this.$refs.manualDistributeCouponModal.show(record);
      }
    }
  }
</script>
<style scoped>
  @import '~@assets/less/common.less';
</style>