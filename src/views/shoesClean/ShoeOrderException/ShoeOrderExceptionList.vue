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
      <!-- <a-button type="primary" icon="download" @click="handleExportXls('订单列表')" v-if="selectedRowKeys.length > 0">导出订单</a-button> -->
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
          <a-divider v-if="2 === record.status && 1 === record.dealType" type="vertical" />
          <a v-if="2 === record.status && 1 === record.dealType" @click="handleCreateWashedMark(record)">打印水洗唛</a>
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
  import {downFile} from "../../../api/manage";

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
        this.superFieldList = fieldList
      },
      handleOrder(record){
        this.$refs.shoeOrderExceptionModal.show(record);
      },
      handleDetail(record){
        this.$refs.shoeOrderExceptionDetailModal.show(record);
      },
      handleCreateWashedMark(record){
        let data = {
          "no": record.no
        }

        downFile("/ShoeFactoryOrder/shoeFactoryOrder/createWashedMark", data, "post").then((res) => {
          if (!res) {
            this.$message.warning(res.message)
            return
          }
          const content = res;
          // 主要的是在这里的转换，必须要加上{ type: 'application/pdf' }
          // 要不然无法进行打印
          const blob = new Blob([content], { type: 'application/pdf' });
          //=========================================================
          var date = (new Date()).getTime();
          var ifr = document.createElement('iframe');
          ifr.style.frameborder = 'no';
          ifr.style.display = 'none';
          ifr.style.pageBreakBefore = 'always';
          ifr.setAttribute('download', 'printPdf' + date + '.pdf');
          ifr.setAttribute('id', 'printPdf' + date + '.pdf');
          ifr.src = window.URL.createObjectURL(blob);
          document.body.appendChild(ifr);

          this.doPrint('printPdf' + date + '.pdf')
          window.URL.revokeObjectURL(ifr.src) // 释放URL 对象
          //=========================================================
          // this.$message.success("入库成功");
          this.confirmLoading = false;
        })
      },
      // 打印
      doPrint(val) {
        var ordonnance = document.getElementById(val).contentWindow;
        setTimeout(() => {
          // window.print()
          ordonnance.print();
        }, 0)
      }
    }
  }
</script>
<style scoped>
  @import '~@assets/less/common.less';
</style>