<template>
  <a-card :bordered="false">
    <!-- 查询区域 -->
    <div class="table-page-search-wrapper">
      <a-form layout="inline" @keyup.enter.native="searchQuery">
        <a-row :gutter="24">
          <a-col :xl="4" :lg="7" :md="8" :sm="24">
            <a-form-item label="订单编号">
              <a-input placeholder="请输入订单编号" v-model="queryParam.no"></a-input>
            </a-form-item>
          </a-col>
          <a-col :xl="4" :lg="7" :md="8" :sm="24">
            <a-form-item label="手机号">
              <a-input placeholder="请输入手机号" v-model="queryParam.phone"></a-input>
            </a-form-item>
          </a-col>
          <a-col :xl="3" :lg="7" :md="8" :sm="24">
            <a-form-item label="订单状态">
              <a-select v-model="queryParam.status">
                <a-select-option v-for="item in statusOptionList" :value="item.value" :key="item.value">{{item.name}}</a-select-option>
              </a-select>
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
      <a-button type="primary" icon="download" @click="handleExportXls('订单列表')" v-if="selectedRowKeys.length > 0">导出订单</a-button>
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
      <div class="ant-alert ant-alert-info" style="margin-bottom: 16px;">
        <i class="anticon anticon-info-circle ant-alert-icon"></i> 已选择 <a style="font-weight: 600">{{ selectedRowKeys.length }}</a>项
        <a style="margin-left: 24px" @click="onClearSelected">清空</a>
      </div>

      <a-table
        ref="table"
        size="middle"
        :scroll="{x:true}"
        bordered
        rowKey="orderExceptionId"
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
          <img v-else :src="getImgView(text)" :preview="record.orderExceptionId" height="25px" alt="" style="max-width:80px;font-size: 12px;font-style: italic;"/>
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
          <a v-if="0 === record.status" @click="handleOrder(record)">处理</a>
          <a v-if="1 === record.status || 2 === record.status" @click="handleDetail(record)">查看详情</a>
        </span>

      </a-table>
    </div>

    <shoe-order-exception-modal ref="shoeOrderExceptionModal" @ok="modalFormOk"></shoe-order-exception-modal>
    <shoe-order-exception-detail-modal ref="shoeOrderExceptionDetailModal" @ok="modalFormOk"></shoe-order-exception-detail-modal>


  </a-card>
</template>

<script>

  import '@/assets/less/TableExpand.less'
  import { mixinDevice } from '@/utils/mixin'
  import { JeecgListMixin } from '@/mixins/JeecgListMixin'
  import {filterDictTextByCache} from "../../../components/dict/JDictSelectUtil";
  import ShoeOrderExceptionModal from "./modules/ShoeOrderExceptionModal";
  import ShoeOrderExceptionDetailModal from "./modules/ShoeOrderExceptionDetailModal";

  export default {
    name: 'ShoeOrderExceptionList',
    mixins:[JeecgListMixin, mixinDevice],
    components: {
      ShoeOrderExceptionModal,
      ShoeOrderExceptionDetailModal
    },
    data () {
      return {
        description: 'shoe_order_exception管理页面',
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
            title:'用户姓名',
            align:"center",
            dataIndex: 'name'
          },
          {
            title:'手机号',
            align:"center",
            dataIndex: 'phone'
          },
          {
            title:'实付金额（元）',
            align:"center",
            dataIndex: 'actualPrice',
            customRender: (text) => {
              return (text * 0.01).toFixed(2);
            }
          },
          {
            title:'处理状态',
            align: "center",
            dataIndex: 'status',
            customRender: (text) => {
              return filterDictTextByCache('shoe_order_exception_status', text);
            }
          },
          {
            title:'处理方式',
            align: "center",
            dataIndex: 'dealType',
            customRender: (text) => {
              return filterDictTextByCache('shoe_order_exception_deal_type', text);
            }
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
          list: "/ShoeOrder/shoeOrder/getShoeOrderExceptionList",
          // exportXlsUrl: "/ShoeOrder/shoeOrder/exportXls",
        },
        dictOptions:{},
        superFieldList:[],
        statusOptionList: [
          {"value":"0", "name":"未处理"}, {"value":"1", "name":"处理中"}, {"value":"2", "name":"已处理"}]
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
        // fieldList.push({type:'int',value:'orderId',text:'订单ID',dictCode:''})
        // fieldList.push({type:'int',value:'orderPId',text:'父订单ID',dictCode:''})
        // fieldList.push({type:'string',value:'no',text:'订单编号',dictCode:''})
        // fieldList.push({type:'int',value:'userId',text:'用户ID',dictCode:''})
        // fieldList.push({type:'int',value:'goodsId',text:'商品ID',dictCode:''})
        // fieldList.push({type:'int',value:'skuId',text:'规格ID',dictCode:''})
        // fieldList.push({type:'string',value:'title',text:'商品名称',dictCode:''})
        // fieldList.push({type:'string',value:'skuTitle',text:'规格名称',dictCode:''})
        // fieldList.push({type:'string',value:'image',text:'商品图片',dictCode:''})
        // fieldList.push({type:'Text',value:'orderImages',text:'洗护前照片',dictCode:''})
        // fieldList.push({type:'string',value:'note',text:'订单备注',dictCode:''})
        // fieldList.push({type:'string',value:'expect',text:'期望上门取件时间',dictCode:''})
        // fieldList.push({type:'string',value:'name',text:'姓名',dictCode:''})
        // fieldList.push({type:'string',value:'phone',text:'号码',dictCode:''})
        // fieldList.push({type:'int',value:'totalPrice',text:'总金额',dictCode:''})
        // fieldList.push({type:'int',value:'price',text:'应付金额',dictCode:''})
        // fieldList.push({type:'int',value:'actualPrice',text:'实付金额',dictCode:''})
        // fieldList.push({type:'int',value:'goodsPrice',text:'商品金额',dictCode:''})
        // fieldList.push({type:'int',value:'courierPrice',text:'配送费用',dictCode:''})
        // fieldList.push({type:'int',value:'couponPrice',text:'优惠抵扣金额',dictCode:''})
        // fieldList.push({type:'string',value:'status',text:'订单状态：0=待付款，1=洗护中，2=待取件，3=已完成，4=已取消，5=退款中，6=已退款，7=异常',dictCode:''})
        // fieldList.push({type:'int',value:'beforeLockerId',text:'机柜ID（下单）',dictCode:''})
        // fieldList.push({type:'int',value:'beforeGridNo',text:'机柜格子编号（下单）',dictCode:''})
        // fieldList.push({type:'int',value:'afterLockerId',text:'机柜ID（配送）',dictCode:''})
        // fieldList.push({type:'int',value:'afterGridNo',text:'机柜格子编号（配送）',dictCode:''})
        // fieldList.push({type:'string',value:'orgCode',text:'工厂编码',dictCode:''})
        // fieldList.push({type:'string',value:'bagCode',text:'袋子编码',dictCode:''})
        // fieldList.push({type:'int',value:'hasException',text:'异常历史:0=无,1=有',dictCode:''})
        // fieldList.push({type:'string',value:'type',text:'订单类型:self=站点自寄,service=上门取件',dictCode:''})
        // fieldList.push({type:'string',value:'code',text:'自提取件码',dictCode:''})
        // fieldList.push({type:'datetime',value:'cancelTime',text:'取消时间'})
        // fieldList.push({type:'datetime',value:'payTime',text:'付款时间'})
        // fieldList.push({type:'datetime',value:'finishTime',text:'完成时间'})
        this.superFieldList = fieldList
      },
      handleOrder(record){
        this.$refs.shoeOrderExceptionModal.show(record);
      },
      handleDetail(record){
        this.$refs.shoeOrderExceptionDetailModal.show(record);
      }
    }
  }
</script>
<style scoped>
  @import '~@assets/less/common.less';
</style>