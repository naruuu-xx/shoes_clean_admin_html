<template>
  <a-card :bordered="false">
    <!-- 查询区域 -->
    <div class="table-page-search-wrapper">
      <a-form layout="inline" @keyup.enter.native="searchQuery">
        <a-row :gutter="24">
          <a-col :xl="6" :lg="7" :md="8" :sm="24">
            <a-form-item label="商品名称">
              <a-input placeholder="请输入商品名称" v-model="queryParam.title"></a-input>
            </a-form-item>
          </a-col>

          <a-col :xl="6" :lg="7" :md="8" :sm="24">
            <a-form-item label="商品类型">
              <!--              <a-input placeholder="请输入操作类型" v-model="queryParam.operationType"></a-input>-->
              <a-select v-model="queryParam.type" :allowClear="true">
                <a-select-option v-for="i in typeList" :value="i.type" :key="i.type">{{i.type}}</a-select-option>
              </a-select>
            </a-form-item>
          </a-col>
          <a-col :xl="6" :lg="7" :md="8" :sm="24">
            <a-form-item label="商品状态">
              <!--              <a-input placeholder="请输入操作类型" v-model="queryParam.operationType"></a-input>-->
              <a-select v-model="queryParam.statusText"  :allowClear = "true">
                <a-select-option v-for="i in statusList" :value="i.statusText" :key="i.status">{{i.statusText}}</a-select-option>
              </a-select>
            </a-form-item>
          </a-col>
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
      <a-button @click="handleAdd" type="primary" icon="plus">新增</a-button>
<!--      <a-button type="primary" icon="download" @click="handleExportXls('shoe_goods')">导出</a-button>-->
<!--      <a-upload name="file" :showUploadList="false" :multiple="false" :headers="tokenHeader" :action="importExcelUrl" @change="handleImportExcel">-->
<!--        <a-button type="primary" icon="import">导入</a-button>-->
<!--      </a-upload>-->
      <!-- 高级查询区域 -->
      <j-super-query :fieldList="superFieldList" ref="superQueryModal" @handleSuperQuery="handleSuperQuery"></j-super-query>
      <a-dropdown v-if="selectedRowKeys.length > 0">
        <a-menu slot="overlay">
<!--          <template v-if="!matchState(record.goodsId,/[12]/)">-->
            <a-menu-item key="1" @click="batchDel"><a-icon type="delete"/>删除</a-menu-item>
<!--          </template>-->

        </a-menu>
        <a-button style="margin-left: 8px"> 批量操作 <a-icon type="down" /></a-button>
      </a-dropdown>
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
        rowKey="goodsId"
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
<!--          <video v-else-if="text.indexOf('mp4')>0" :src="getImgView(text)" :onclick="text" style="max-width:80px;font-size: 12px;font-style: italic;" ></video>-->
          <img :src="getImgView(text)" :preview="record.goodsId" height="25px" alt="" style="max-width:80px;font-size: 12px;font-style: italic;"/>
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
          <a @click="handleEdit(record)">编辑</a>

          <a-divider type="vertical" />
          <a-dropdown>
            <a class="ant-dropdown-link">更多 <a-icon type="down" /></a>
            <a-menu slot="overlay">
              <a-menu-item>
                <a @click="handleDetail(record)">详情</a>
              </a-menu-item>
              <template v-if="!matchState(record.goodsId,/[12]/)">
                <a-menu-item>
                <a-popconfirm title="确定删除吗?" @confirm="() => handleDelete(record.goodsId)">
                  <a>删除</a>
                </a-popconfirm>
              </a-menu-item>
              </template>

            </a-menu>
          </a-dropdown>
        </span>

      </a-table>
    </div>

    <shoe-goods-modal ref="modalForm" @ok="modalFormOk"></shoe-goods-modal>
  </a-card>
</template>

<script>

  import '@/assets/less/TableExpand.less'
  import { mixinDevice } from '@/utils/mixin'
  import { JeecgListMixin } from '@/mixins/JeecgListMixin'
  import ShoeGoodsModal from './modules/ShoeGoodsModal'
  import { filterMultiDictText } from '@comp/dict/JDictSelectUtil'
  import { getFileAccessHttpUrl, httpAction } from '@api/manage'

  export default {
    name: 'ShoeGoodsList',
    mixins:[JeecgListMixin, mixinDevice],
    components: {
      ShoeGoodsModal
    },
    data () {
      function typerender(text) {
        if(text === "ordinary"){
          return "普洗";
        }
        else if(text === "fine"){
          return "精洗";
        }
        else{
          return "修复";
        }
      }

      function imagerender(text) {
        if(text && text.indexOf(",")>0){
          text = text.substring(0,text.indexOf(","))
        }
        return getFileAccessHttpUrl(text)
      }

      return {
        description: 'shoe_goods管理页面',
        // 表头
        columns: [
          {
            title:'商品名称',
            align:"center",
            dataIndex: 'title'
          },
          {
            title:'类型',
            align:"center",
            dataIndex: 'type',
            customRender:(text) => (typerender(text)),
          },
          {
            title:'主图',
            align:"center",
            dataIndex: 'image',
            scopedSlots: {customRender: 'imgSlot'},
            // customRender:(text) => (imagerender(text)),
          },
          // {
          //   title:'描述',
          //   align:"center",
          //   dataIndex: 'describe'
          // },
          // {
          //   title:'详情',
          //   align:"center",
          //   dataIndex: 'content'
          // },
          {
            title:'销量',
            align:"center",
            dataIndex: 'sale'
          },
          {
            title:'浏览量',
            align:"center",
            dataIndex: 'pv'
          },
          {
            title:'权重',
            align:"center",
            dataIndex: 'weight'
          },
          {
            title:'状态',
            align:"center",
            dataIndex: 'status',
            customRender: (text) => (filterMultiDictText(this.dictOptions['status'], text)),
          },
          // {
          //   title:'删除状态:0=正常,1=删除',
          //   align:"center",
          //   dataIndex: 'delFlag'
          // },
          // {
          //   title:'删除时间',
          //   align:"center",
          //   dataIndex: 'deleteTime',
          //   customRender:function (text) {
          //     return !text?"":(text.length>10?text.substr(0,10):text)
          //   }
          // },
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
          list: "/shoes/shoeGoods/list",
          delete: "/shoes/shoeGoods/delete",
          deleteBatch: "/shoes/shoeGoods/deleteBatch",
          exportXlsUrl: "/shoes/shoeGoods/exportXls",
          importExcelUrl: "shoes/shoeGoods/importExcel",

        },
        dictOptions:{},
        superFieldList:[],
        typeList:[],
        statusList:[]
      }
    },
    created() {
    this.getSuperFieldList();
    this.goodsTypeList();
    this.goodsStatusList();
    this.$set(this.dictOptions, 'status', [{text:'上架',value:'1'},{text:'下架',value:'0'}]);
    console.log("----------------");
    console.log(this.statusList);
    },
    computed: {
      importExcelUrl: function(){
        return `${window._CONFIG['domianURL']}/${this.url.importExcelUrl}`;
      },
    },
    methods: {
      initDictConfig(){
      },

      /**
       *v-if多判断条件
       */
      matchState(state = '', reg) {
        return !!String(state).match(reg)//返回true/false
      },
      getSuperFieldList(){
        let fieldList=[];
        fieldList.push({type:'int',value:'goodsId',text:'ID'})
        fieldList.push({type:'string',value:'type',text:'类型:ordinary=普洗,fine=精洗,repair=修复'})
        fieldList.push({type:'string',value:'title',text:'商品名称'})
        fieldList.push({type:'string',value:'image',text:'主图'})
        fieldList.push({type:'string',value:'describe',text:'描述'})
        fieldList.push({type:'string',value:'content',text:'详情'})
        fieldList.push({type:'int',value:'sale',text:'销量'})
        fieldList.push({type:'int',value:'pv',text:'浏览量'})
        fieldList.push({type:'int',value:'weight',text:'权重'})
        fieldList.push({type:'int',value:'status',text:'状态:0=下架,1=上架'})
        fieldList.push({type:'int',value:'delFlag',text:'删除状态:0=正常,1=删除'})
        fieldList.push({type:'date',value:'deleteTime',text:'删除时间'})
        this.superFieldList = fieldList
      },
      goodsTypeList(){
        httpAction("/shoes/shoeGoodsSku/typeList", null, "get").then((res) => {
          if (res){

            this.typeList = res;
          }
        })
      },
      goodsStatusList(){
        httpAction("/shoes/shoeGoodsSku/statusList", null, "get").then((res) => {
          if (res){

            this.statusList = res;
          }
        })
      }
    }

  }
</script>
<style scoped>
  @import '~@assets/less/common.less';
</style>