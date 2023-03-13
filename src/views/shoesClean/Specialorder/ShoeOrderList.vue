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
          <a-col :xl="4" :lg="7" :md="8" :sm="24">
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
          <a-col :xl="4" :lg="7" :md="8" :sm="24">
            <a-form-item label="订单类型">
              <a-select v-model="queryParam.type">
                <a-select-option v-for="item in typeOptionList" :value="item.value" :key="item.value">
                  {{ item.name }}
                </a-select-option>
              </a-select>
            </a-form-item>
          </a-col>
          <a-col :xl="6" :lg="7" :md="8" :sm="24">
            <a-form-item label="订单时间">
              <a-range-picker v-model="queryParam.finishTime" />
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
      <a-space>
        <a-popconfirm placement="bottom" title="是否批量改为洗护中" ok-text="是" cancel-text="否" @confirm="onChangeState(1)"
          @cancel="cancel" :disabled="selectedRowKeys.length == 0 || type != 1">
          <a-button type="primary" :disabled="selectedRowKeys.length == 0 || type != 1">
            批量转换
          </a-button>
        </a-popconfirm>
        <a-popconfirm placement="bottom" title="是否批量改为已完单" ok-text="是" cancel-text="否" @confirm="onChangeState(2)"
          @cancel="cancel" :disabled="selectedRowKeys.length == 0 || type != 6">
          <a-button type="primary" :disabled="selectedRowKeys.length == 0 || type != 6">
            批量完单
          </a-button>
        </a-popconfirm>

        </a-button>
      </a-space>
    </div>

    <!-- table区域-begin -->
    <div>
      <div class="ant-alert ant-alert-info" style="margin-bottom: 16px;">
        <i class="anticon anticon-info-circle ant-alert-icon"></i> 已选择 <a style="font-weight: 600">{{
          selectedRowKeys.length }}</a>项
        <a style="margin-left: 24px" @click="onClearSelected">清空</a>
      </div>

      <a-table ref="table" size="middle" :scroll="{x:true}" bordered rowKey="orderId" :columns="columns"
        :dataSource="dataSource" :pagination="ipagination" :loading="loading" class="j-table-force-nowrap"
        :rowSelection="{columnTitle:'选择',
        fixed:true,
        selectedRowKeys:selectedRowKeys,
        onChange:selecteChange
        }" @change="handleTableChange">

        <template slot="htmlSlot" slot-scope="text">
          <div v-html="text"></div>
        </template>
        <template slot="imgSlot" slot-scope="text,record">
          <span v-if="!text" style="font-size: 12px;font-style: italic;">无图片</span>
          <img v-else :src="getImgView(text)" :preview="record.orderId" height="25px" alt=""
            style="max-width:80px;font-size: 12px;font-style: italic;" />
        </template>
        <template slot="fileSlot" slot-scope="text">
          <span v-if="!text" style="font-size: 12px;font-style: italic;">无文件</span>
          <a-button v-else :ghost="true" type="primary" icon="download" size="small" @click="downloadFile(text)">
            下载
          </a-button>
        </template>

        <span slot="action" slot-scope="text, record">
          <a-space>
            <a @click="handleOrderDetail(record)">查看详情</a>
            <a-popconfirm v-if="record.status == 6" title="是否改为已完单" ok-text="是" cancel-text="否" @confirm="onChangeState(2,record.orderId)" @cancel="cancel">
              <a>完单</a>
            </a-popconfirm>
            <a-popconfirm v-if="record.status == 1" title="是否改为洗护中" ok-text="是" cancel-text="否" @confirm="onChangeState(1,record.orderId)" @cancel="cancel">
              <a>转换</a>
            </a-popconfirm>

          </a-space>
        </span>

      </a-table>
    </div>
    <shoe-order-detail ref="shoeOrderDetail" @ok="modalFormOk"></shoe-order-detail>
    <handle-order-finish-modal ref="handleOrderFinishModal" @ok="modalFormOk"></handle-order-finish-modal>

    <!-- <a-modal v-model="visible" title="Basic Modal" @ok="handleOk">
      <p>Some contents...</p>
      <p>Some contents...</p>
      <p>Some contents...</p>
    </a-modal> -->
  </a-card>
</template>

<script>
  import moment from 'moment';
  import '@/assets/less/TableExpand.less'
  import { mixinDevice } from '@/utils/mixin'
  import { JeecgListMixin } from '@/mixins/JeecgListMixin'
  import { filterDictTextByCache } from "../../../components/dict/JDictSelectUtil";
  import ShoeOrderDetail from "./modules/ShoeOrderDetail";
  import { httpAction, getAction } from "@api/manage";
  import HandleOrderFinishModal from "./modules/HandleOrderFinishModal";

  export default {
    name: 'ShoeOrderList',
    mixins: [JeecgListMixin, mixinDevice],
    components: {
      HandleOrderFinishModal,
      ShoeOrderDetail
    },
    data() {
      return {
        description: 'shoe_order管理页面',
        serviceCode: '',
        selfCode: '',
        queryParam: {
          status: '',
          finishTimeLeft: '',
          finishTimeRight: '',
          finishTime: []
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
            title: '昵称',
            align: "center",
            dataIndex: 'nickname'
          },
          {
            title: '绑定手机号',
            align: "center",
            dataIndex: 'wxPhone'
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
            scopedSlots: { customRender: 'action' }
          }
        ],
        url: {
          // list: "/ShoeOrder/shoeOrder/list",
          list: "/shoes/shoeSpecialOrder/specialOrderList",
          delete: "/ShoeOrder/shoeOrder/delete",
          deleteBatch: "/ShoeOrder/shoeOrder/deleteBatch",
          exportXlsUrl: "/ShoeOrder/shoeOrder/exportXls",
          importExcelUrl: "ShoeOrder/shoeOrder/importExcel",

        },
        dictOptions: {},
        superFieldList: [],
        statusOptionList: [
          { "value": "", "name": "全部" }, { "value": "0", "name": "待付款" }, { "value": "1", "name": "已付款" },
          { "value": "2", "name": "配送员已接单（取件）" }, { "value": "3", "name": "配送员已收件" }, {
            "value": "4",
            "name": "已入柜"
          },
          { "value": "5", "name": "送工厂" }, { "value": "6", "name": "洗护中" }, { "value": "7", "name": "异常" },
          { "value": "8", "name": "退回中" }, { "value": "9", "name": "已出库" }, { "value": "10", "name": "待取件" },
          { "value": "11", "name": "配送员已接单（送件）" }, { "value": "12", "name": "配送员已取鞋" }, {
            "value": "13",
            "name": "已完成"
          },
          { "value": "14", "name": "退款中" }, { "value": "15", "name": "已退款" }, { "value": "16", "name": "已取消" },
          { "value": "17", "name": "用户已寄出" }, { "value": "18", "name": "已出库未寄出" }, { "value": "19", "name": "工厂已寄出" },
        ],
        typeOptionList: [
          { "value": "", "name": "全部" }, { "value": "self", "name": "自提" }, {
            "value": "service",
            "name": "配送"
          }, { "value": "expressage", "name": "快递" }, { "value": "site", "name": "站点" }
        ],
        lockerList: [],
        type: '',
        visible: false
      }
    },
    created() {
      this.getSuperFieldList();
      //获取机柜列表，放入下拉框
    },
    watch: {
      'queryParam.finishTime': {
        handler(newV) {
          if (newV.length) {
            let [finishTimeLeft, finishTimeright] = newV.map(item => moment(item).format('YYYY-MM-DD'))
            this.queryParam.finishTimeLeft = finishTimeLeft
            this.queryParam.finishTimeright = finishTimeright
          } else {
            this.queryParam.finishTimeLeft = ""
            this.queryParam.finishTimeright = ""
          }
        },
        // immediate: true
      }
    },
    computed: {
      importExcelUrl: function () {
        return `${window._CONFIG['domianURL']}/${this.url.importExcelUrl}`;
      },
    },
    methods: {
      onChangeState(status, id) {
        // this.visible = true
        let form = {
          orderIds: id || this.selectedRowKeys.join(',')
        }
        
        getAction("/shoes/shoeSpecialOrder/orderStatusBatchChange", form).then((res) => {
          if (res) {
            console.log(88888,res);
            // this.selfCode = res.result;
            this.loadData();
          }
        })
        console.log(888,form);
       
      },
      selecteChange(selectedRowKeys, selectedRows) {
        let orderId = selectedRowKeys.filter(v => !this.selectedRowKeys.includes(v))[0] // 获取选中项的id
        let idx = selectedRows.findIndex(item => item.orderId == orderId) // 获取选中项的下标
        let selected = selectedRows[idx] // 选中项
        if (selected) {
          if (!this.selectedRowKeys.length) {
            this.type = selected.status
          }
          if (selected.status == this.type || this.selectedRowKeys.length == 0) {
            this.selectedRowKeys = selectedRowKeys
          } else {
            this.$message.warning("只能勾选同类型的订单！");
          }
        } else {
          this.selectedRowKeys = selectedRowKeys
        }
      },
      initDictConfig() {
      },
      getSuperFieldList() {
        let fieldList = [];
        fieldList.push({ type: 'int', value: 'orderId', text: '订单ID', dictCode: '' })
        fieldList.push({ type: 'int', value: 'orderPId', text: '父订单ID', dictCode: '' })
        fieldList.push({ type: 'string', value: 'no', text: '订单编号', dictCode: '' })
        fieldList.push({ type: 'int', value: 'userId', text: '用户ID', dictCode: '' })
        fieldList.push({ type: 'int', value: 'goodsId', text: '商品ID', dictCode: '' })
        fieldList.push({ type: 'int', value: 'skuId', text: '规格ID', dictCode: '' })
        fieldList.push({ type: 'string', value: 'title', text: '商品名称', dictCode: '' })
        fieldList.push({ type: 'string', value: 'skuTitle', text: '规格名称', dictCode: '' })
        fieldList.push({ type: 'string', value: 'image', text: '商品图片', dictCode: '' })
        fieldList.push({ type: 'Text', value: 'orderImages', text: '洗护前照片', dictCode: '' })
        fieldList.push({ type: 'string', value: 'note', text: '订单备注', dictCode: '' })
        fieldList.push({ type: 'string', value: 'expect', text: '期望上门取件时间', dictCode: '' })
        fieldList.push({ type: 'string', value: 'name', text: '姓名', dictCode: '' })
        fieldList.push({ type: 'string', value: 'phone', text: '号码', dictCode: '' })
        fieldList.push({ type: 'int', value: 'totalPrice', text: '总金额', dictCode: '' })
        fieldList.push({ type: 'int', value: 'price', text: '应付金额', dictCode: '' })
        fieldList.push({ type: 'int', value: 'actualPrice', text: '实付金额', dictCode: '' })
        fieldList.push({ type: 'int', value: 'goodsPrice', text: '商品金额', dictCode: '' })
        fieldList.push({ type: 'int', value: 'courierPrice', text: '配送费用', dictCode: '' })
        fieldList.push({ type: 'int', value: 'couponPrice', text: '优惠抵扣金额', dictCode: '' })
        fieldList.push({
          type: 'string',
          value: 'status',
          text: '订单状态：0=待付款，1=洗护中，2=待取件，3=已完成，4=已取消，5=退款中，6=已退款，7=异常',
          dictCode: ''
        })
        fieldList.push({ type: 'int', value: 'beforeLockerId', text: '机柜ID（下单）', dictCode: '' })
        fieldList.push({ type: 'int', value: 'beforeGridNo', text: '机柜格子编号（下单）', dictCode: '' })
        fieldList.push({ type: 'int', value: 'afterLockerId', text: '机柜ID（配送）', dictCode: '' })
        fieldList.push({ type: 'int', value: 'afterGridNo', text: '机柜格子编号（配送）', dictCode: '' })
        fieldList.push({ type: 'string', value: 'orgCode', text: '工厂编码', dictCode: '' })
        fieldList.push({ type: 'string', value: 'bagCode', text: '袋子编码', dictCode: '' })
        fieldList.push({ type: 'int', value: 'hasException', text: '异常历史:0=无,1=有', dictCode: '' })
        fieldList.push({ type: 'string', value: 'type', text: '订单类型:self=站点自寄,service=上门取件', dictCode: '' })
        fieldList.push({ type: 'string', value: 'code', text: '自提取件码', dictCode: '' })
        fieldList.push({ type: 'datetime', value: 'cancelTime', text: '取消时间' })
        fieldList.push({ type: 'datetime', value: 'payTime', text: '付款时间' })
        fieldList.push({ type: 'datetime', value: 'finishTime', text: '完成时间' })
        this.superFieldList = fieldList
      },
      handleOrderDetail(record) {
        let orderStatus = filterDictTextByCache('shoe_order_status', record.status);
        this.$refs.shoeOrderDetail.show(record, orderStatus);
      },
      handleOrderFinish(record) {
        this.$refs.handleOrderFinishModal.show(record);
      },
      cancel() {

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