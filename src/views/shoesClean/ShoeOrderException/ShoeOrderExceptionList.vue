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
            <a-form-item label="处理完成时间">
                <a-range-picker v-model="queryParam.dealFinishTime" />
            </a-form-item>
          </a-col><a-col :xl="4" :lg="7" :md="8" :sm="24" v-has="'area:list'">
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
            <a-form-item label="创建时间">
              <a-range-picker v-model="queryParam.createTime" />
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
      <a-button type="primary" icon="download" @click="handleExportXls('售后订单列表')" v-if="selectedRowKeys.length > 0">
        导出选中订单
      </a-button>
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
          <a v-has="'order:handleOrderException'" v-if="0 === record.status" @click="handleOrder(record)">处理</a>
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
  import {downFile, httpAction} from "../../../api/manage";
  import { getLodop } from '@/utils/LodopFuncs';
  import moment from 'moment';
  import XfSelect from '@/components/Xf/XfSelect'
  let Lodop;

  export default {
    name: 'ShoeOrderExceptionList',
    mixins:[JeecgListMixin, mixinDevice],
    components: {
      ShoeOrderExceptionModal,
      ShoeOrderExceptionDetailModal,
      XfSelect
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
            title:' 区域',
            align:"center",
            dataIndex: 'departName'
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
            title:'创建时间',
            align:"center",
            dataIndex: 'createTime',
          },
          {
            title:'处理完成时间',
            align:"center",
            dataIndex: 'dealFinishTime',
            customRender: (text) => {
              let date = text;
              if (null === text) {
                date = "————————"
              }
              return date;
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
          exportXlsUrl: "/ShoeOrder/shoeOrder/exportXlsException"
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
      setQueryParams () {
        let [startTime, endTime] = this.queryParam.dealFinishTime || ['', ''];
        let [startCreateTime, endCreateTime] = this.queryParam.createTime || ['', ''];

        startTime = startTime ? moment(startTime).format('YYYY-MM-DD') : "";
        endTime = endTime ? moment(endTime).format('YYYY-MM-DD') : "";

        startCreateTime = startCreateTime ? moment(startCreateTime).format('YYYY-MM-DD') : "";
        endCreateTime = endCreateTime ? moment(endCreateTime).format('YYYY-MM-DD') : "";

        return {startTime, endTime, startCreateTime, endCreateTime}
      },
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

        httpAction("/ShoeFactoryOrder/shoeFactoryOrder/createWashedMarkByInForException", data, "post").then((res) => {
          if (!res) {
            this.$message.warning(res.message)
            return
          }

          const file = res;
          // 主要的是在这里的转换，必须要加上{ type: 'application/pdf' }
          // 要不然无法进行打印
          // const blob = new Blob([file], { type: 'application/pdf' });

          // this.getBase64(blob).then(res=>{
          //   console.log(res);
          //   // res = res.replace("data:application/pdf;base64,", "");
          // });

          this.printPic(file, "水洗唛")

        })
      },
      getBase64(file) {
        return new Promise((resolve, reject) => {
          let reader = new FileReader();
          let fileResult = "";
          reader.readAsDataURL(file);
          //开始转
          reader.onload = function() {
            fileResult = reader.result;
          };
          //转 失败
          reader.onerror = function(error) {
            reject(error);
          };
          //转 结束  咱就 resolve 出去
          reader.onloadend = function() {
            resolve(fileResult);
          };
        });
      },
      /**
       *
       * @param file base64
       * @param printerName 打印机名称
       */
      printPic(file,printerName){
        LODOP = getLodop() // 获取LODOP对象的主过程
        LODOP.SET_LICENSES("","9598E18E55ADC63670695568858B9F880FD","","")
        if (LODOP != false) {
          // LODOP.SET_LICENSES("","9598E18E55ADC63670695568858B9F880FD","","");
          let timestamp = parseInt(new Date().getTime() / 1000 + '');
          LODOP.PRINT_INIT("异常订单补款补打水洗棉" + timestamp);
          LODOP.SET_PRINTER_INDEX(printerName);
          LODOP.SET_PRINT_PAGESIZE(1, "111mm", "20mm", "");
          LODOP.ADD_PRINT_PDF(0,0,"100%","100%",file);

          LODOP.PRINT()// 直接打印
          // LODOP.PREVIEW() // 打印预览
        }
      },
      /**
       * 根据打印机名称获取该打印机在系统中的序号
       * @param {Object} LODOP
       * @param printName
       */
      getPrinterIndex(LODOP, printName) {
        let num = LODOP.GET_PRINTER_COUNT();
        let index = 0;
        for (let i = 0; i < num; i++) {
          let name = LODOP.GET_PRINTER_NAME(i);
          if (printName === name) {
            index = i;
            break;
          }
        }
        return index;
      },
    }
  }
</script>
<style scoped>
  @import '~@assets/less/common.less';
</style>