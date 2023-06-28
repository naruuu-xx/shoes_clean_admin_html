<template>
  <a-card :bordered="false">
    <!-- 查询区域 -->
    <div class="table-page-search-wrapper">
      <a-form layout="inline" @keyup.enter.native="searchQuery">
        <a-row :gutter="24">
          <a-col :xl="3" :lg="7" :md="8" :sm="24">
            <a-form-item label=" 申请人">
              <a-input placeholder="请输入 申请人" v-model="queryParam.courierName" autocomplete="off"></a-input>
            </a-form-item>
          </a-col>
          <a-col :xl="3" :lg="7" :md="8" :sm="24">
            <a-form-item label=" 状态">
<!--              <a-input placeholder="请输入 申请人" v-model="queryParam.name" autocomplete="off"></a-input>-->
              <a-select v-model="queryParam.status" >
                <a-select-option v-for="item in statusOptionList" :value="item.value" :key="item.value">{{item.name}}</a-select-option>
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
        rowKey="courierWithdrawalId"
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
          <img v-else :src="getImgView(text)" :preview="record.courierWithdrawalId" height="25px" alt="" style="max-width:80px;font-size: 12px;font-style: italic;"/>
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
          <a @click="handleDetail(record)">详情</a>

          <a-divider type="vertical" v-if="'0' === record.status" />

          <a v-if="'0' === record.status" v-has="'courierWithdrawal:audit'" @click="handleAudit(record)">审核</a>

          <a-divider type="vertical" v-if="'1' === record.status" />

          <a v-if="'1' === record.status" v-has="'courierWithdrawal:transfer'" @click="handleTransfer(record)">确认</a>

        </span>

      </a-table>
    </div>

    <shoe-courier-withdrawal-modal ref="modalForm" @ok="modalFormOk"></shoe-courier-withdrawal-modal>

    <shoe-courier-withdrawal-detail ref="modalDetails" @ok="modalFormOk"></shoe-courier-withdrawal-detail>

    <shoe-courier-withdrawal-audit ref="modalAudit" @ok="modalFormOk"></shoe-courier-withdrawal-audit>

    <shoe-courier-withdrawal-transfer ref="modalTransfer" @ok="modalFormOk"></shoe-courier-withdrawal-transfer>

  </a-card>
</template>

<script>

  import '@/assets/less/TableExpand.less'
  import { mixinDevice } from '@/utils/mixin'
  import { JeecgListMixin } from '@/mixins/JeecgListMixin'
  import ShoeCourierWithdrawalModal from './modules/ShoeCourierWithdrawalModal'
  import {filterDictTextByCache} from "../../../components/dict/JDictSelectUtil";
  import ShoeCourierWithdrawalDetail from "./modules/ShoeCourierWithdrawalDetail";
  import ShoeCourierWithdrawalAudit from "./modules/ShoeCourierWithdrawalAudit";
  import ShoeCourierWithdrawalTransfer from "./modules/ShoeCourierWithdrawalTransfer";
  import XfSelect from '@/components/Xf/XfSelect'

  export default {
    name: 'ShoeCourierWithdrawalList',
    mixins:[JeecgListMixin, mixinDevice],
    components: {
      ShoeCourierWithdrawalTransfer,
      ShoeCourierWithdrawalAudit,
      ShoeCourierWithdrawalDetail,
      ShoeCourierWithdrawalModal,
      XfSelect
    },
    data () {
      return {
        description: 'shoe_courier_withdrawal管理页面',
        queryParam:{
          status:''
        },
        // 表头
        columns: [
          {
            title:' 区域',
            align:"center",
            dataIndex: 'departName'
          },
          {
            title:'申请人',
            align:"center",
            dataIndex: 'name'
          },
          {
            title:'提现金额',
            align:"center",
            dataIndex: 'amountTemp'
          },
          {
            title: '实际到账金额',
            align: "center",
            dataIndex: 'realwithdrawal'
          },
          {
            title: '手续费率',
            align: "center",
            dataIndex: 'withdrawalRatio',
            customRender: (text) => {
              return `${parseFloat((text || 0) * 100).toFixed(2)}%`
            },
          },
          {
            title:'申请时间',
            align:"center",
            dataIndex: 'createTime',
          },
          {
            title:'审核时间',
            align:"center",
            dataIndex: 'auditTime',
            customRender:function (text) {
              return text === null? "-" :text;
            }
          },
          {
            title:'提现时间',
            align:"center",
            dataIndex: 'transferTime',
            customRender:function (text) {
              return text === null? "-" :text;
            }
          },
          {
            title:'操作人',
            align:"center",
            dataIndex: 'operator'
          },
          {
            title:'状态',
            align:"center",
            dataIndex: 'status',
            customRender: (text) => {
              return filterDictTextByCache('shoe_courier_withdrawal_status', text);
            },
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
          list: "/ShoeCourierWithdrawal/shoeCourierWithdrawal/queryList",
        },
        dictOptions:{},
        superFieldList:[],
        statusOptionList: [
          {"value":"", "name":"全部"}, {"value":"0", "name":"审核中"}, {"value":"1", "name":"提现中"},
          {"value":"2", "name":"审核失败"}, {"value":"3", "name":"已提现"}
        ],
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
      initDictConfig(){
      },
      getSuperFieldList(){
        let fieldList=[];
        fieldList.push({type:'int',value:'courierWithdrawalId',text:'配送提现id '})
        fieldList.push({type:'int',value:'courierId',text:'配送员id'})
        fieldList.push({type:'int',value:'amount',text:'提现金额'})
        fieldList.push({type:'int',value:'type',text:'类型:1=银行'})
        fieldList.push({type:'string',value:'status',text:'状态:0=审核中，1=提现中，2=审核失败，3=已提现'})
        fieldList.push({type:'string',value:'note',text:'备注'})
        fieldList.push({type:'string',value:'cardNo',text:'卡号'})
        fieldList.push({type:'string',value:'openBank',text:'开户行'})
        fieldList.push({type:'string',value:'cardName',text:'持卡人'})
        fieldList.push({type:'string',value:'bankAddress',text:'银行地址'})
        fieldList.push({type:'date',value:'auditTime',text:'审核时间'})
        fieldList.push({type:'date',value:'transferTime',text:'转账时间'})
        fieldList.push({type:'string',value:'auditUserId',text:'审核人id'})
        fieldList.push({type:'string',value:'auditName',text:'审核人'})
        fieldList.push({type:'string',value:'transferUserId',text:'确认转账人id'})
        fieldList.push({type:'string',value:'transferName',text:'确认转账人'})
        this.superFieldList = fieldList
      },
      handleDetail(record){
        this.$refs.modalDetails.show(record);
      },
      handleAudit(record){
        this.$refs.modalAudit.show(record);
      },
      handleTransfer(record){
        this.$refs.modalTransfer.show(record);
      }
    }
  }
</script>
<style scoped>
  @import '~@assets/less/common.less';
</style>