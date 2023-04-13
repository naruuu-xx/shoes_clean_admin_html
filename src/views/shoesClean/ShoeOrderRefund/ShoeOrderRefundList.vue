<template>
  <a-card :bordered="false">
    <!-- 查询区域 -->
    <div class="table-page-search-wrapper">
      <a-form layout="inline" @keyup.enter.native="searchQuery">
        <a-row :gutter="24">
          <a-col :xl="4" :lg="7" :md="4" :sm="12">
            <a-form-item label="订单编号">
              <a-input placeholder="请输入订单编号" v-model="queryParam.no" ></a-input>
            </a-form-item>
          </a-col>
          <a-col :xl="4" :lg="7" :md="8" :sm="24">
            <a-form-item label="手机号">
              <a-input placeholder="请输入手机号" v-model="queryParam.phone"></a-input>
            </a-form-item>
          </a-col>

          <a-col :xl="4" :lg="7" :md="8" :sm="24">
            <a-form-item label="退款原因">
              <a-input placeholder="请输入手机号" v-model="queryParam.reason"></a-input>
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
      <div class="ant-alert ant-alert-info" style="margin-bottom: 16px;">
        <i class="anticon anticon-info-circle ant-alert-icon"></i> 已选择 <a style="font-weight: 600">{{ selectedRowKeys.length }}</a>项
        <a style="margin-left: 24px" @click="onClearSelected">清空</a>
      </div>

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
        :rowSelection="{selectedRowKeys: selectedRowKeys, onChange: onSelectChange}"
        class="j-table-force-nowrap"
        @change="handleTableChange">

        <template slot="htmlSlot" slot-scope="text">
          <div v-html="text"></div>
        </template>
        <template slot="imgSlot" slot-scope="text,record">
          <span v-if="!text" style="font-size: 12px;font-style: italic;">无图片</span>
          <img v-else :src="getImgView(text)" :preview="record.id" height="25px" alt="" style="max-width:80px;font-size: 12px;font-style: italic;"/>
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
          <a @click="handleRefundDetail(record)">详情</a>
        </span>

      </a-table>
    </div>

    <shoe-order-refund-modal ref="modalForm" @ok="modalFormOk"></shoe-order-refund-modal>
    <shoe-order-refund-detail ref="shoeOrderRefundDetail" @ok="modalFormOk"></shoe-order-refund-detail>
  </a-card>
</template>

<script>

  import '@/assets/less/TableExpand.less'
  import { mixinDevice } from '@/utils/mixin'
  import { JeecgListMixin } from '@/mixins/JeecgListMixin'
  import ShoeOrderRefundModal from './modules/ShoeOrderRefundModal'
  import ShoeOrderRefundDetail from '@views/shoesClean/ShoeOrderRefund/modules/ShoeOrderRefundDetail'

  export default {
    name: 'ShoeOrderRefundList',
    mixins:[JeecgListMixin, mixinDevice],
    components: {
      ShoeOrderRefundModal,
      ShoeOrderRefundDetail
    },
    data () {
      return {
        description: 'shoe_order_refund管理页面',
        // 表头
        columns: [
          {
            title:'订单编号',
            align:"center",
            dataIndex: 'no'
          },
          {
            title:'商品名称',
            align:"center",
            dataIndex: 'title'
          },
          {
            title:'商品规格',
            align:"center",
            dataIndex: 'skuTitle'
          },
          {
            title:'订单类型',
            align:"center",
            dataIndex: 'type',
          customRender: (text, record) => {
              if(text ==='self'){
                return '自行存取'
              }
              else if (text === 'service'){
                return '上门取件'
              }
              else if (text === 'site_self'){
                return '站点存取'
              }
              else if (text === 'site'){
                return '站点上门'
              }
          }
          },
          {
            title:'实付金额',
            align:"center",
            dataIndex: 'actualPrice',
            customRender: (text, record) => {
              return text/100 ;
            }
          },
          {
            title:'用户姓名',
            align: "center",
            dataIndex: 'nickname'
          },
          {
            title: '手机号',
            align: "center",
            dataIndex: 'phone'
          },

          {
            title:'退款原因 ',
            align:"center",
            dataIndex: 'reason'
          },
          {
            title:'订单状态',
            align:"center",
            dataIndex: 'refundStatus',
            customRender: (text, record) => {
              if (text === '0') {
                return '退款中'
              }
              if (text === '1') {
                return '退款成功'
              }
              if (text === '2') {
                return '退款失败'
              }
            }
          },
          {
            title:'退款时间',
            align:"center",
            dataIndex: 'refundTime',
          },
          {
            title:'操作人',
            align:"center",
            dataIndex: 'sysUserName'
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
          list: "/shoes/shoeOrderRefund/list",
          delete: "/shoes/shoeOrderRefund/delete",
          deleteBatch: "/shoes/shoeOrderRefund/deleteBatch",
          exportXlsUrl: "/shoes/shoeOrderRefund/exportXls",
          importExcelUrl: "shoes/shoeOrderRefund/importExcel",

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
      initDictConfig(){
      },
      getSuperFieldList(){
        let fieldList=[];
        fieldList.push({type:'int',value:'orderRefundId',text:'订单退款ID'})
        fieldList.push({type:'int',value:'orderPId',text:'父订单ID'})
        fieldList.push({type:'int',value:'orderId',text:'子订单ID'})
        fieldList.push({type:'string',value:'outTradeNo',text:'商户订单号'})
        fieldList.push({type:'string',value:'outRefundNo',text:'商户退款单号'})
        fieldList.push({type:'int',value:'actualPrice',text:'订单实付金额'})
        fieldList.push({type:'int',value:'refundPrice',text:'退款金额'})
        fieldList.push({type:'int',value:'scene',text:'退款场景：0=超时自动取消退款，1=用户申请退款，2=后台发起退款'})
        fieldList.push({type:'string',value:'reason',text:'退款原因 '})
        fieldList.push({type:'int',value:'refundStatus',text:'退款状态:0=退款中，1=退款成功，2=退款失败'})
        fieldList.push({type:'date',value:'successTime',text:'退款成功时间'})
        fieldList.push({type:'string',value:'sysUserId',text:'操作人'})
        fieldList.push({type:'string',value:'note',text:'备注'})
        fieldList.push({type:'string',value:'description',text:'退款说明'})
        this.superFieldList = fieldList
      },

      handleRefundDetail(record){

        this.$refs.shoeOrderRefundDetail.show(record);
      }
    }
  }
</script>
<style scoped>
  @import '~@assets/less/common.less';
</style>