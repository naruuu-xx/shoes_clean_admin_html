<template>
  <a-card :bordered="false">
    <!-- 查询区域 -->
    <div class="table-page-search-wrapper">
      <a-form layout="inline" @keyup.enter.native="searchQuery">
        <a-row :gutter="24">
          <a-col :xl="6" :lg="7" :md="8" :sm="24">
            <a-form-item label="订单编号">
              <a-input placeholder="请输入订单编号" v-model="queryParam.no"></a-input>
            </a-form-item>
          </a-col>
          <a-col :xl="6" :lg="7" :md="8" :sm="24">
            <a-form-item label="手机号">
              <a-input placeholder="请输入手机号" v-model="queryParam.phone"></a-input>
            </a-form-item>
          </a-col>
          <a-col :xl="4" :lg="7" :md="8" :sm="24">
            <a-form-item label="订单状态">
              <a-select  v-model="queryParam.status" >
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

    <!-- 操作按钮区域 -->

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

        <span slot="action" slot-scope="text, record">
          <a @click="handleEdit(record)"  v-if="record.status=='未处理'">处理</a>
        <a @click="handleEdit(record)" v-if="record.status=='已处理'">详情</a>
        </span>

      </a-table>
    </div>

    <shoe-exception-tag-modal ref="modalForm" @ok="modalFormOk"></shoe-exception-tag-modal>
  </a-card>
</template>

<script>

  import '@/assets/less/TableExpand.less'
  import { mixinDevice } from '@/utils/mixin'
  import { JeecgListMixin } from '@/mixins/JeecgListMixin'
  import ShoeExceptionTagModal from './modules/ShoeExceptionTagModal'

  export default {
    name: 'ShoeExceptionTagList',
    mixins:[JeecgListMixin, mixinDevice],
    components: {
      ShoeExceptionTagModal
    },
    data () {
      return {
        description: 'shoe_exception_tag管理页面',
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
            title:'提交时间',
            align:"center",
            dataIndex: 'createTime',
            customRender:function (text) {
              return !text?"-":(text.length>10?text.substr(0,10):text)
            }
          },
          {
            title:'状态',
            align:"center",
            dataIndex: 'status'
          },
          {
            title:'处理方式',
            align:"center",
            dataIndex: 'dealType',
            customRender:function (text) {
              return !text?"-":text
            }
          },
          {
            title:'处理时间',
            align:"center",
            dataIndex: 'dealTime',
            customRender:function (text) {
              return !text?"-":(text.length>10?text.substr(0,10):text)
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
          list: "/shoeExceptionTag/list",

        },
        statusOptionList: [
          {"value": "", "name": "全部"}, {"value": "1", "name": "未处理"},
          {"value": "2", "name": "已处理"}, {"value": "3", "name": "已失效"}
          ],
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
        fieldList.push({type:'int',value:'exceptionTagId',text:'异常id',dictCode:''})
        fieldList.push({type:'int',value:'orderId',text:'订单id',dictCode:''})
        fieldList.push({type:'int',value:'dealType',text:'处理方式：1=转异常，2=继续洗',dictCode:''})
        fieldList.push({type:'date',value:'dealTime',text:'处理时间'})
        fieldList.push({type:'int',value:'status',text:'状态：0=未处理，1=已处理（订单状态非洗护中且未处理则标为已失效）',dictCode:''})
        this.superFieldList = fieldList
      }
    }
  }
</script>
<style scoped>
  @import '~@assets/less/common.less';
</style>