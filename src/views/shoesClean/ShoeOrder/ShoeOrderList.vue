<template>
  <a-card :bordered="false">
    <!-- 查询区域 -->
    <div class="table-page-search-wrapper">
      <a-form layout="inline" @keyup.enter.native="searchQuery">
        <a-row :gutter="24">
          <a-col :xl="4" :lg="7" :md="4" :sm="12">
            <a-form-item label="订单编号">
              <a-input placeholder="请输入订单编号" v-model="queryParam.no"></a-input>
            </a-form-item>
          </a-col>
          <a-col :xl="3" :lg="7" :md="8" :sm="24">
            <a-form-item label="手机号">
              <a-input placeholder="请输入手机号" v-model="queryParam.phone"></a-input>
            </a-form-item>
          </a-col>
          <a-col :xl="4" :lg="7" :md="8" :sm="24">
            <a-form-item label="机柜名称">
              <a-input placeholder="请输入机柜名称" v-model="queryParam.lockerName"></a-input>
            </a-form-item>
          </a-col>
          <a-col :xl="4" :lg="7" :md="8" :sm="24">
            <a-form-item label="订单状态">
              <a-select v-model="queryParam.status">
                <a-select-option v-for="item in statusOptionList" :value="item.value" :key="item.value">
                  {{ item.name }}
                </a-select-option>
              </a-select>
            </a-form-item>
          </a-col>
          <a-col :xl="3" :lg="7" :md="8" :sm="24">
            <a-form-item label="订单类型">
              <a-select v-model="queryParam.type">
                <a-select-option v-for="item in typeOptionList" :value="item.value" :key="item.value">
                  {{ item.name }}
                </a-select-option>
              </a-select>
            </a-form-item>
          </a-col>
          <!--          <a-col :xl="4" :lg="7" :md="8" :sm="24">-->
          <!--            <a-form-item label="机柜名称">-->
          <!--              <a-select v-model="queryParam.lockerId" style="width: 180px">-->
          <!--                <a-select-option v-for="item in statusOptionList" :value="item.value" :key="item.value">{{item.name}}</a-select-option>-->
          <!--              </a-select>-->
          <!--            </a-form-item>-->
          <!--          </a-col>-->
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
      <a-button type="primary" icon="download" @click="handleExportXls('订单列表')" v-if="selectedRowKeys.length > 0">
        导出选中订单
      </a-button>
      <!--      <a-button type="primary" icon="download" @click="handleExportXls('订单列表')">导出全部订单</a-button>-->
      <!--      <a-upload name="file" :showUploadList="false" :multiple="false" :headers="tokenHeader" :action="i mportExcelUrl" @change="handleImportExcel">-->
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
        <i class="anticon anticon-info-circle ant-alert-icon"></i> 已选择 <a
        style="font-weight: 600">{{ selectedRowKeys.length }}</a>项
        <a style="margin-left: 24px" @click="onClearSelected">清空</a>
      </div>

      <a-table
        ref="table"
        size="middle"
        :scroll="{x:true}"
        bordered
        rowKey="orderId"
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
          <img v-else :src="getImgView(text)" :preview="record.orderId" height="25px" alt=""
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
          <a @click="handleOrderDetail(record)">查看详情</a>

<!--           <a-divider v-if="record.type==='self' && record.status==='10'" type="vertical" v-has="'order:getCode'"/>-->

<!--          <a-popover trigger="click" placement="top" v-has="'order:getCode'">-->
<!--              <template #content>-->
<!--                <p align="center">取件码</p>-->
<!--                 <p align="center" class="textCode">{{ selfCode }}</p>-->
<!--               </template>-->
<!--          <a v-if="record.type==='self' && record.status==='10'" @click="getSelfCode(record)">取件码</a>-->
<!--          </a-popover>-->

          <a-divider v-if="record.type==='service' && record.status==='12'" type="vertical" v-has="'order:getCode'"/>

          <a-popover trigger="click" placement="top" v-has="'order:getCode'">

              <template #content>
                <p align="center">取件码</p>
                 <p align="center" class="textCode">{{ serviceCode }}</p>
               </template>
          <a v-if="record.type==='service' && record.status==='12'" @click="getServiceCode(record)">取件码</a>
          </a-popover>

          <a-divider v-if="'9' === record.status" type="vertical"/>
          <a v-if="'9' === record.status" @click="handleOrderFinish(record)">完单</a>

        </span>

      </a-table>
    </div>

    <shoe-order-modal ref="modalForm" @ok="modalFormOk"></shoe-order-modal>
    <shoe-order-detail ref="shoeOrderDetail" @ok="modalFormOk"></shoe-order-detail>
    <shoe-refund-detail ref="shoeRefundDetail" @ok="modalFormOk"></shoe-refund-detail>
    <handle-order-finish-modal ref="handleOrderFinishModal" @ok="modalFormOk"></handle-order-finish-modal>
    <shoe-order-detail11 ref="ShoeOrderDetails" @ok="modalFormOk"></shoe-order-detail11>
  </a-card>
</template>

<script>

import '@/assets/less/TableExpand.less'
import {mixinDevice} from '@/utils/mixin'
import {JeecgListMixin} from '@/mixins/JeecgListMixin'
import ShoeOrderModal from './modules/ShoeOrderModal'
import {filterDictTextByCache} from "../../../components/dict/JDictSelectUtil";
import ShoeOrderDetail from "./modules/ShoeOrderDetail";
import ShoeOrderDetail11 from "./modules/ShoeOrderDetail11";
import ShoeRefundDetail from "./modules/ShoeRefundDetail";
import {httpAction} from "@api/manage";
import HandleOrderFinishModal from "./modules/HandleOrderFinishModal";

export default {
  name: 'ShoeOrderList',
  mixins: [JeecgListMixin, mixinDevice],
  components: {
    HandleOrderFinishModal,
    ShoeOrderModal,
    ShoeOrderDetail,
    ShoeRefundDetail,
    ShoeOrderDetail11
  },
  data() {
    return {
      description: 'shoe_order管理页面',
      serviceCode: '',
      selfCode: '',
      queryParam:{
        status:''
      },
      // 表头
      columns: [
        {
          title: '订单编号',
          align: "center",
          dataIndex: 'no'
        },
        {
          title: '商品名称',
          align: "center",
          dataIndex: 'title'
        },
        {
          title: '商品规格',
          align: "center",
          dataIndex: 'skuTitle'
        },
        {
          title: '附加服务',
          align: "center",
          dataIndex: "additionalName",
          customRender: (text, record) => {
            return text ? text : '无'
          }
        },
        {
          title: '姓名',
          align: "center",
          dataIndex: 'name'
        },
        {
          title: '号码',
          align: "center",
          dataIndex: 'phone'
        },
        {
          title: "机柜名称",
          align: "center",
          dataIndex: 'lockerName'
        },
        {
          title: '实付金额（元）',
          align: "center",
          dataIndex: 'actualPrice',
          customRender: (text) => {
            return (text * 0.01).toFixed(2);
          }
        },
        {
          title: '下单时间',
          align: "center",
          dataIndex: 'createTime'
        },
        {
          title: '订单状态',
          align: "center",
          dataIndex: 'status',
          customRender: (text) => {
            return filterDictTextByCache('shoe_order_status', text);
          }
        },
        {
          title: '订单类型',
          align: "center",
          dataIndex: 'type',
          customRender: (text) => {
            return filterDictTextByCache('shoe_order_type', text);
          }
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
        // list: "/ShoeOrder/shoeOrder/list",
        list: "/ShoeOrder/shoeOrder/queryList",
        delete: "/ShoeOrder/shoeOrder/delete",
        deleteBatch: "/ShoeOrder/shoeOrder/deleteBatch",
        exportXlsUrl: "/ShoeOrder/shoeOrder/exportXls",
        importExcelUrl: "ShoeOrder/shoeOrder/importExcel",

      },
      dictOptions: {},
      superFieldList: [],
      statusOptionList: [
        {"value": "", "name": "全部"}, {"value": "0", "name": "待付款"}, {"value": "1", "name": "已付款"},
        {"value": "2", "name": "配送员已接单（取件）"}, {"value": "3", "name": "配送员已收件"}, {
          "value": "4",
          "name": "已入柜"
        },
        {"value": "5", "name": "送工厂"}, {"value": "6", "name": "洗护中"}, {"value": "7", "name": "异常"},
        {"value": "8", "name": "退回中"}, {"value": "9", "name": "已出库"}, {"value": "10", "name": "待取件"},
        {"value": "11", "name": "配送员已接单（送件）"}, {"value": "12", "name": "配送员已取鞋"}, {
          "value": "13",
          "name": "已完成"
        },
        {"value": "14", "name": "退款中"}, {"value": "15", "name": "已退款"}, {"value": "16", "name": "已取消"},
        {"value": "17", "name": "用户已寄出"}, {"value": "18", "name": "已出库未寄出"}, {"value": "19", "name": "工厂已寄出"},
      ],
      typeOptionList: [
        {"value": "", "name": "全部"}, {"value": "self", "name": "自提"}, {
          "value": "service",
          "name": "配送"
        }, {"value": "expressage", "name": "快递"}, {"value": "site", "name": "站点"}
      ],
      lockerList: [],
    }
  },
  created() {
    this.getSuperFieldList();
    //获取机柜列表，放入下拉框
  },
  computed: {
    importExcelUrl: function () {
      return `${window._CONFIG['domianURL']}/${this.url.importExcelUrl}`;
    },
  },
  methods: {
    initDictConfig() {
    },
    getSelfCode(record) {
      //this.url.list = "/shoes/shoeInvestors/InvestorsList?id="+investorsId,
      httpAction("ShoeOrder/shoeOrder/getSelfCode?no=" + record.no, null, "get").then((res) => {
        if (res) {
          this.selfCode = res.result;
        }
      })
    },
    getServiceCode(record) {
      //this.url.list = "/shoes/shoeInvestors/InvestorsList?id="+investorsId,
      httpAction("ShoeOrder/shoeOrder/getServiceCode?orderId=" + record.orderId, null, "get").then((res) => {
        if (res) {
          this.serviceCode = res.result;
        }
      })
    },
    getSuperFieldList() {
      let fieldList = [];
      fieldList.push({type: 'int', value: 'orderId', text: '订单ID', dictCode: ''})
      fieldList.push({type: 'int', value: 'orderPId', text: '父订单ID', dictCode: ''})
      fieldList.push({type: 'string', value: 'no', text: '订单编号', dictCode: ''})
      fieldList.push({type: 'int', value: 'userId', text: '用户ID', dictCode: ''})
      fieldList.push({type: 'int', value: 'goodsId', text: '商品ID', dictCode: ''})
      fieldList.push({type: 'int', value: 'skuId', text: '规格ID', dictCode: ''})
      fieldList.push({type: 'string', value: 'title', text: '商品名称', dictCode: ''})
      fieldList.push({type: 'string', value: 'skuTitle', text: '规格名称', dictCode: ''})
      fieldList.push({type: 'string', value: 'image', text: '商品图片', dictCode: ''})
      fieldList.push({type: 'Text', value: 'orderImages', text: '洗护前照片', dictCode: ''})
      fieldList.push({type: 'string', value: 'note', text: '订单备注', dictCode: ''})
      fieldList.push({type: 'string', value: 'expect', text: '期望上门取件时间', dictCode: ''})
      fieldList.push({type: 'string', value: 'name', text: '姓名', dictCode: ''})
      fieldList.push({type: 'string', value: 'phone', text: '号码', dictCode: ''})
      fieldList.push({type: 'int', value: 'totalPrice', text: '总金额', dictCode: ''})
      fieldList.push({type: 'int', value: 'price', text: '应付金额', dictCode: ''})
      fieldList.push({type: 'int', value: 'actualPrice', text: '实付金额', dictCode: ''})
      fieldList.push({type: 'int', value: 'goodsPrice', text: '商品金额', dictCode: ''})
      fieldList.push({type: 'int', value: 'courierPrice', text: '配送费用', dictCode: ''})
      fieldList.push({type: 'int', value: 'couponPrice', text: '优惠抵扣金额', dictCode: ''})
      fieldList.push({
        type: 'string',
        value: 'status',
        text: '订单状态：0=待付款，1=洗护中，2=待取件，3=已完成，4=已取消，5=退款中，6=已退款，7=异常',
        dictCode: ''
      })
      fieldList.push({type: 'int', value: 'beforeLockerId', text: '机柜ID（下单）', dictCode: ''})
      fieldList.push({type: 'int', value: 'beforeGridNo', text: '机柜格子编号（下单）', dictCode: ''})
      fieldList.push({type: 'int', value: 'afterLockerId', text: '机柜ID（配送）', dictCode: ''})
      fieldList.push({type: 'int', value: 'afterGridNo', text: '机柜格子编号（配送）', dictCode: ''})
      fieldList.push({type: 'string', value: 'orgCode', text: '工厂编码', dictCode: ''})
      fieldList.push({type: 'string', value: 'bagCode', text: '袋子编码', dictCode: ''})
      fieldList.push({type: 'int', value: 'hasException', text: '异常历史:0=无,1=有', dictCode: ''})
      fieldList.push({type: 'string', value: 'type', text: '订单类型:self=站点自寄,service=上门取件', dictCode: ''})
      fieldList.push({type: 'string', value: 'code', text: '自提取件码', dictCode: ''})
      fieldList.push({type: 'datetime', value: 'cancelTime', text: '取消时间'})
      fieldList.push({type: 'datetime', value: 'payTime', text: '付款时间'})
      fieldList.push({type: 'datetime', value: 'finishTime', text: '完成时间'})
      this.superFieldList = fieldList
    },
    handleOrderDetail(record) {
      let orderStatus = filterDictTextByCache('shoe_order_status', record.status);
      this.$refs.shoeOrderDetail.show(record, orderStatus);
      // this.$refs.ShoeOrderDetails.show(record, orderStatus);
    },
    handleRefundDetail(record) {
      this.$refs.shoeRefundDetail.show(record);
    },
    handleOrderFinish(record){
      this.$refs.handleOrderFinishModal.show(record);
    }
  }
}
</script>
<style scoped>
@import '~@assets/less/common.less';

.textCode {
  font-size: 20px;
}
</style>