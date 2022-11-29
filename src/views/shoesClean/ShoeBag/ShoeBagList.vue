<template>
  <a-card :bordered="false">
    <!-- 查询区域 -->
    <div class="table-page-search-wrapper">
      <a-form layout="inline" @keyup.enter.native="searchQuery">
        <a-row :gutter="24">
          <a-col :xl="4" :lg="7" :md="8" :sm="24">
            <a-form-item label="袋子编码">
              <a-input placeholder="请输入袋子编码" v-model="queryParam.bagCode" ></a-input>

            </a-form-item>
          </a-col>
          <a-col :xl="3" :lg="7" :md="8" :sm="24">
            <a-form-item label="状态">
<!--              <a-input placeholder="请输入状态:0=异常,1=正常" v-model="queryParam.status"></a-input>-->
              <a-select v-model="queryParam.status" :allowClear='true'>
                <a-select-option v-for="item in statusOptionList" :value="item.value" :key="item.value">{{item.name}}</a-select-option>
              </a-select>
            </a-form-item>
          </a-col>
          <a-col :xl="3" :lg="7" :md="8" :sm="24">
            <a-form-item label="使用状态">
<!--              <a-input placeholder="请输入使用状态:0=空闲,1=使用中" v-model="queryParam.useStatus"></a-input>-->
              <a-select v-model="queryParam.useStatus" :allowClear='true'>
                <a-select-option v-for="item in useStatusOptionList" :value="item.value" :key="item.value">{{item.name}}</a-select-option>
              </a-select>
            </a-form-item>
          </a-col>
<!--          <template v-if="toggleSearchStatus">-->
<!--            <a-col :xl="6" :lg="7" :md="8" :sm="24">-->
<!--              <a-form-item label="使用状态">-->
<!--                <a-input placeholder="请输入使用状态:0=空闲,1=使用中" v-model="queryParam.useStatus"></a-input>-->
<!--              </a-form-item>-->
<!--            </a-col>-->
<!--          </template>-->
          <a-col :xl="6" :lg="7" :md="8" :sm="24">
            <span style="float: left;overflow: hidden;" class="table-page-search-submitButtons">
              <a-button type="primary" @click="searchQuery" icon="search">查询</a-button>
              <a-button type="primary" @click="searchReset" icon="reload" style="margin-left: 8px">重置</a-button>
<!--              <a @click="handleToggleSearch" style="margin-left: 8px">-->
<!--                {{ toggleSearchStatus ? '收起' : '展开' }}-->
<!--                <a-icon :type="toggleSearchStatus ? 'up' : 'down'"/>-->
<!--              </a>-->
            </span>
          </a-col>
        </a-row>
      </a-form>
    </div>
    <!-- 查询区域-END -->

    <!-- 操作按钮区域 -->
    <div class="table-operator">
      <a-button @click="addBag" type="primary" icon="plus">新增袋子</a-button>
      <a-button v-if="selectedRowKeys.length > 0" @click="printMultiple">一键打印</a-button>
      <a-button v-if="selectedRowKeys.length > 0" @click="batchDel">批量删除</a-button>
<!--      <a-button type="primary" icon="download" @click="handleExportXls('shoe_bag')">导出</a-button>-->
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
        rowKey="bagId"
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
          <img v-else :src="getImgView(text)" :preview="record.bagId" height="25px" alt="" style="max-width:80px;font-size: 12px;font-style: italic;"/>
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
          <a @click="handlprint(record)">打印</a>
          <a-divider type="vertical" />
          <a @click="handleEdit(record)">状态</a>
          <a-divider type="vertical" />
          <a-popconfirm title="确定删除吗?" @confirm="() => handleDelete(record.bagId)">
            <a>删除</a>
          </a-popconfirm>

<!--          <a-divider type="vertical" />-->
<!--          <a-dropdown>-->
<!--            <a class="ant-dropdown-link">更多 <a-icon type="down" /></a>-->
<!--            <a-menu slot="overlay">-->
<!--              <a-menu-item>-->
<!--                <a @click="handleDetail(record)">详情</a>-->
<!--              </a-menu-item>-->
<!--              <a-menu-item>-->
<!--                <a-popconfirm title="确定删除吗?" @confirm="() => handleDelete(record.bagId)">-->
<!--                  <a>删除</a>-->
<!--                </a-popconfirm>-->
<!--              </a-menu-item>-->
<!--            </a-menu>-->
<!--          </a-dropdown>-->
        </span>

      </a-table>
    </div>

    <shoe-bag-modal ref="modalForm" @ok="modalFormOk"></shoe-bag-modal>
    <shoe-bag-add-modal ref="shoeBagAdd" @ok="modalFormOk"></shoe-bag-add-modal>
  </a-card>
</template>

<script>

  import '@/assets/less/TableExpand.less'
  import { mixinDevice } from '@/utils/mixin'
  import { JeecgListMixin } from '@/mixins/JeecgListMixin'
  import ShoeBagModal from './modules/ShoeBagModal'
  import {filterDictTextByCache} from "../../../components/dict/JDictSelectUtil";
  import shoeBagAddModal from "./modules/shoeBagAddModal";
  import {downFile, getAction} from "../../../api/manage";

  export default {
    name: 'ShoeBagList',
    mixins:[JeecgListMixin, mixinDevice],
    components: {
      ShoeBagModal,
      shoeBagAddModal
    },
    data () {
      return {
        description: 'shoe_bag管理页面',
        // 表头
        columns: [
          // {
          //   title: '#',
          //   dataIndex: '',
          //   key:'rowIndex',
          //   width:60,
          //   align:"center",
          //   customRender:function (t,r,index) {
          //     return parseInt(index)+1;
          //   }
          // },
          // {
          //   title:'ID',
          //   align:"center",
          //   dataIndex: 'bagId'
          // },
          // {
          //   title:'工厂编码',
          //   align:"center",
          //   dataIndex: 'orgCode'
          // },
          {
            title:'袋子编码',
            align:"center",
            dataIndex: 'bagCode'
          },
          {
            title:'袋子状态',
            align:"center",
            dataIndex: 'status',
            customRender: (text) => {
              return filterDictTextByCache('shoe_bag_status', text);
            }
          },
          {
            title:'使用情况',
            align:"center",
            dataIndex: 'useStatus',
            customRender: (text) => {
              return filterDictTextByCache('shoe_bag_use_status', text);
            }
          },
          {
            title:'录入时间',
            align:"center",
            dataIndex: 'createTime',
            // customRender:function (text) {
            //   return !text?"":(text.length>10?text.substr(0,10):text)
            // }
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
          // list: "/ShoeBag/shoeBag/list",
          list: "/ShoeBag/shoeBag/queryList",
          delete: "/ShoeBag/shoeBag/delete",
          deleteBatch: "/ShoeBag/shoeBag/deleteBatch",
          exportXlsUrl: "/ShoeBag/shoeBag/exportXls",
          importExcelUrl: "ShoeBag/shoeBag/importExcel",

        },
        dictOptions:{},
        superFieldList:[],
        statusOptionList: [{"value":"0", "name":"异常"}, {"value":"1", "name":"正常"}],
        useStatusOptionList: [{"value":"0", "name":"空闲"}, {"value":"1", "name":"使用中"}],
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
        fieldList.push({type:'int',value:'bagId',text:'ID',dictCode:''})
        fieldList.push({type:'string',value:'orgCode',text:'工厂编码',dictCode:''})
        fieldList.push({type:'string',value:'bagCode',text:'袋子编码',dictCode:''})
        fieldList.push({type:'int',value:'status',text:'状态',dictCode:''})
        fieldList.push({type:'int',value:'useStatus',text:'使用状态',dictCode:''})
        fieldList.push({type:'date',value:'createTime',text:'创建时间'})
        this.superFieldList = fieldList
      },
      handlprint(record){
        console.log(record);
        let bagCode = record.bagCode;
        let data = {
          "bagCode": bagCode
        }
        downFile("/ShoeBag/shoeBag/printBagCodeByOne", data, "post").then((res) => {
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
        })
      },
      addBag(){
        this.$refs.shoeBagAdd.show();
      },
      printMultiple(){
        var ids = "";
        console.log(this.selectedRowKeys);
        for (var a = 0 ; a < this.selectedRowKeys.length ; a ++) {
          ids += this.selectedRowKeys[a] + ",";
        }
        console.log(ids);
        let data = {
          "bagIds": ids
        };
        downFile("/ShoeBag/shoeBag/printBagCodeByMultiple", data, "post").then((res) => {
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
          // ifr.setAttribute('download', 'printPdf' + date + '.pdf');
          ifr.setAttribute('id', 'printPdf' + date + '.pdf');
          ifr.src = window.URL.createObjectURL(blob);
          document.body.appendChild(ifr);

          this.doPrint('printPdf' + date + '.pdf')
          window.URL.revokeObjectURL(ifr.src) // 释放URL 对象
          //=========================================================
        })
      },
      // 打印
      doPrint(val) {
        var ordonnance = document.getElementById(val).contentWindow;
        setTimeout(() => {
          // window.print()
          ordonnance.print();
          this.pdfLoading = false;
        }, 100)
      },
      testPrint(){
        downFile("/ShoeBag/shoeBag/printWashedMark", null, "post").then((res) => {
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
        })
      },
    }
  }
</script>
<style scoped>
  @import '~@assets/less/common.less';
</style>