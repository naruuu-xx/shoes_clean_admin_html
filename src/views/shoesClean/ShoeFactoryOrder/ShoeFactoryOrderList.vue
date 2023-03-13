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
              <a-select v-model="queryParam.factoryStatus">
                <a-select-option v-for="item in statusOptionList" :value="item.value" :key="item.value">{{item.name}}</a-select-option>
              </a-select>
            </a-form-item>
          </a-col>
          <a-col :xl="4" :lg="7" :md="8" :sm="24">
            <a-form-item label="订单来源">
              <a-select v-model="queryParam.source">
                <a-select-option v-for="item in sourceOptionList" :value="item.value" :key="item.value">{{item.name}}</a-select-option>
              </a-select>
            </a-form-item>
          </a-col>
          <a-col :xl="3" :lg="7" :md="8" :sm="24">
            <a-form-item label="订单类型">
              <a-select v-model="queryParam.type">
                <a-select-option v-for="item in TypeOptionList" :value="item.value" :key="item.value">{{item.name}}</a-select-option>
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
<!--      <a-button type="primary" icon="download" @click="handleExportXls('订单列表')" v-if="selectedRowKeys.length > 0">导出订单</a-button>-->
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
        rowKey="factoryOrderId"
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
          <img v-else :src="getImgView(text)" :preview="record.factoryOrderId" height="25px" alt="" style="max-width:80px;font-size: 12px;font-style: italic;"/>
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
          <a @click="handleFactoryOrderDetail(record)">查看详情</a>
        </span>

      </a-table>
    </div>

<!--    <shoe-order-modal ref="modalForm" @ok="modalFormOk"></shoe-order-modal>-->
<!--    <shoe-order-detail ref="shoeOrderDetail" @ok="modalFormOk"></shoe-order-detail>-->
    <shoe-factory-order-detail-modal ref="shoeFactoryOrderDetailModal" @ok="modalFormOk"></shoe-factory-order-detail-modal>

  </a-card>
</template>

<script>

  import '@/assets/less/TableExpand.less'
  import { mixinDevice } from '@/utils/mixin'
  import { JeecgListMixin } from '@/mixins/JeecgListMixin'
  import {filterDictTextByCache} from "../../../components/dict/JDictSelectUtil";
  import ShoeFactoryOrderDetailModal from "./modules/ShoeFactoryOrderDetailModal";
  import {httpAction} from "../../../api/manage";

  export default {
    name: 'ShoeOrderList',
    mixins:[JeecgListMixin, mixinDevice],
    components: {
      ShoeFactoryOrderDetailModal
    },
    data () {
      return {
        description: 'shoe_order管理页面',
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
            title:'入库时间',
            align:"center",
            dataIndex: 'factoryInTime'
          },
          {
            title:'出库时间',
            align:"center",
            dataIndex: 'factoryOutTime',
            customRender: (text) => {
              let result = text;
              if (result === null) {
                result = "——————————";
              }
              return result;
            }
          },
          {
            title:'订单状态',
            align:"center",
            dataIndex: 'status',
            customRender: (text) => {
              return filterDictTextByCache('shoe_factory_order_status', text);
            }
          },
          {
            title:'订单来源',
            align:"center",
            dataIndex: 'orderSource',
            // customRender: (text) => {
            //   return filterDictTextByCache('shoe_factory_order_source', text);
            // }
          },
          {
            title:'订单类型',
            align:"center",
            dataIndex: 'type',
            customRender: (text) => {
              return filterDictTextByCache('shoe_factory_order_type', text);
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
          list: "/ShoeOrder/shoeOrder/queryFactoryOrderList",
          // exportXlsUrl: "/ShoeOrder/shoeOrder/exportXls",
        },
        dictOptions:{},
        superFieldList:[],
        statusOptionList: [{"value":"", "name":"全部"}, {"value":"1", "name":"已入库"}, {"value":"2", "name":"已出库"}],
        sourceOptionList: [],
        TypeOptionList: [{"value":"", "name":"全部"}, {"value":"locker", "name":"机柜订单"}, {"value":"expressage", "name":"快递订单"}, {"value":"site", "name":"站点订单"}, {"value":"other", "name":"其他订单"} ]
      }
    },
    created() {
      this.getSuperFieldList();
      this.getSourceOptionList();
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
      handleFactoryOrderDetail(record){
        this.$refs.shoeFactoryOrderDetailModal.show(record);
      },
      getSourceOptionList() {
        let url = "/ShoeFactoryOrder/shoeFactoryOrder/getFactoryPlatformList?type=" + 0;

        httpAction(url, null, "get").then((res) => {
          this.sourceOptionList = res.result.map((item, index, arr) => {
            let c = {value : item.platformId, name : item.name}
            return c;
          })
        })
      }
    }
  }
</script>
<style scoped>
  @import '~@assets/less/common.less';
</style>