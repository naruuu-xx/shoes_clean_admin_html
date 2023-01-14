<template>
  <a-card :bordered="false">
    <!-- 查询区域 -->
    <div class="table-page-search-wrapper">
      <a-form layout="inline" @keyup.enter.native="searchQuery">
        <a-row :gutter="24">
          <a-col :xl="6" :lg="7" :md="8" :sm="24">
            <a-form-item label="订单编号">
              <a-input placeholder="请输入订单编号" v-model="queryParam.noP"></a-input>
            </a-form-item>
          </a-col>
          <a-col :xl="6" :lg="7" :md="8" :sm="24">
            <a-form-item label="下单人">
              <a-select v-model="queryParam.scene" style="width: 180px">
                <a-select-option v-for="item in sceneOptionList" :value="item.value" :key="item.value">
                  {{ item.name }}
                </a-select-option>
              </a-select>
            </a-form-item>
          </a-col>

          <a-col :xl="6" :lg="7" :md="8" :sm="24">
            <a-form-item label="订单状态">
              <a-select v-model="queryParam.status" style="width: 180px">
                <a-select-option v-for="item in statusOptionList" :value="item.value" :key="item.value">
                  {{ item.name }}
                </a-select-option>
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


    <!-- table区域-begin -->
    <div>


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


      </a-table>
    </div>

    <shoe-expressage-order-modal ref="modalForm" @ok="modalFormOk"></shoe-expressage-order-modal>
  </a-card>
</template>

<script>

  import '@/assets/less/TableExpand.less'
  import { mixinDevice } from '@/utils/mixin'
  import { JeecgListMixin } from '@/mixins/JeecgListMixin'
  import ShoeExpressageOrderModal from './modules/ShoeExpressageOrderModal'
  import {filterDictTextByCache} from "@comp/dict/JDictSelectUtil";

  export default {
    name: 'ShoeExpressageOrderList1',
    mixins:[JeecgListMixin, mixinDevice],
    components: {
      ShoeExpressageOrderModal
    },
    data () {
      return {
        description: 'shoe_expressage_order管理页面1',
        sceneOptionList: [{"value":"0", "name":"全部"}, {"value":"1", "name":"用户"}, {"value":"2", "name":"工厂"}],
        statusOptionList: [{"value":"0", "name":"全部"}, {"value":"1", "name":"已取消"}, {"value":"2", "name":"未下单"}, {"value":"3", "name":"已下单"},{"value":"4", "name":"下单中"}],
        // 表头
        columns: [
          {
            title:'订单编号',
            align:"center",
            dataIndex: 'noP'
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
            dataIndex: 'manName'
          },
          {
            title:'手机号',
            align:"center",
            dataIndex: 'manMobile'
          },
          {
            title:'鞋子数',
            align:"center",
            dataIndex: 'num'
          },
          {
            title:'下单人',
            align:"center",
            dataIndex: 'scene',
            customRender: (text) => {
              return filterDictTextByCache('shoeExpressageOrder:scene', text);
            },
          },
          {
            title:'订单状态',
            align:"center",
            dataIndex: 'status',
            customRender: (text) => {
              return filterDictTextByCache('shoeExpressageOrder:status', text);
            },
          },
          {
            title:'失败原因',
            align:"center",
            dataIndex: 'note'
          }
        ],
        url: {
          list: "/shoeExpressageOrder/list",

          
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
        fieldList.push({type:'int',value:'expressageOrderId',text:'快递订单ID',dictCode:''})
        fieldList.push({type:'string',value:'kuaidi100OrderId',text:'快递100订单ID',dictCode:''})
        fieldList.push({type:'int',value:'orderPId',text:'关联父订单ID',dictCode:''})
        fieldList.push({type:'int',value:'scene',text:'场景：1=用户寄出，2=工厂寄出',dictCode:''})
        fieldList.push({type:'int',value:'status',text:'状态:0=下单中，1=下单成功，2=下单失败，3=已取消',dictCode:''})
        fieldList.push({type:'int',value:'hasFail',text:'是否发生过下单失败：0=否，1=是',dictCode:''})
        fieldList.push({type:'string',value:'kuaidiName',text:'快递公司名称',dictCode:''})
        fieldList.push({type:'string',value:'kuaidicom',text:'快递公司编码',dictCode:''})
        fieldList.push({type:'string',value:'recManName',text:'收件人名姓名',dictCode:''})
        fieldList.push({type:'string',value:'recManMobile',text:'收件人的手机号',dictCode:''})
        fieldList.push({type:'string',value:'recManPrintAddr',text:'收件人所在完整地址',dictCode:''})
        fieldList.push({type:'string',value:'sendManName',text:'寄件人姓名',dictCode:''})
        fieldList.push({type:'string',value:'sendManMobile',text:'寄件人的手机号',dictCode:''})
        fieldList.push({type:'string',value:'sendManPrintAddr',text:'寄件人所在的完整地址',dictCode:''})
        fieldList.push({type:'string',value:'res',text:'下单返回结果',dictCode:''})
        fieldList.push({type:'string',value:'kuaidinum',text:'快递单号',dictCode:''})
        fieldList.push({type:'string',value:'weight',text:'计费重量，单位：kg',dictCode:''})
        fieldList.push({type:'BigDecimal',value:'defprice',text:'标准运费，单位：元',dictCode:''})
        fieldList.push({type:'BigDecimal',value:'freight',text:'折后运费，单位：元',dictCode:''})
        fieldList.push({type:'int',value:'expressSheetType',text:'面单类型：0=不打印，1=设备打印，2=生成图片短链回调',dictCode:''})
        fieldList.push({type:'string',value:'expressSheet',text:'面单',dictCode:''})
        fieldList.push({type:'string',value:'note',text:'备注',dictCode:''})
        fieldList.push({type:'date',value:'successTime',text:'成功时间'})
        fieldList.push({type:'date',value:'failTime',text:'失败时间'})
        fieldList.push({type:'date',value:'cancelTime',text:'取消时间'})
        fieldList.push({type:'string',value:'taskId',text:'快递100回调任务id',dictCode:''})
        this.superFieldList = fieldList
      }
    }
  }
</script>
<style scoped>
  @import '~@assets/less/common.less';
</style>