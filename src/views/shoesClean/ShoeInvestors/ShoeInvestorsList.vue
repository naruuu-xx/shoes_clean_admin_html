<template>
  <a-card :bordered="false">
    <!-- 查询区域 -->
<!--    <div class="table-page-search-wrapper">-->
<!--      <a-form layout="inline" @keyup.enter.native="searchQuery">-->
<!--        <a-row :gutter="24">-->
<!--          <a-col :xl="5" :lg="7" :md="8" :sm="24">-->
<!--            <a-form-item label="姓名">-->
<!--              <a-input placeholder="请输入姓名"  v-model="queryParam.name"></a-input>-->
<!--            </a-form-item>-->
<!--          </a-col>-->
<!--          <a-col :xl="5" :lg="7" :md="8" :sm="24">-->
<!--            <a-form-item label="手机号">-->
<!--              <a-input placeholder="请输入手机号"  v-model="queryParam.phone"></a-input>-->
<!--            </a-form-item>-->
<!--          </a-col>-->

<!--            <a-col :xl="5" :lg="7" :md="8" :sm="24">-->
<!--              <a-form-item label="身份">-->
<!--                <a-select v-model="queryParam.level" AllClear="true">-->
<!--                  <a-select-option value="1" >代理人</a-select-option>-->
<!--                  <a-select-option value="2" >投资人</a-select-option>-->
<!--                </a-select>-->
<!--              </a-form-item>-->
<!--            </a-col>-->
<!--          <a-col :xl="6" :lg="7" :md="8" :sm="24">-->
<!--            <span style="float: left;overflow: hidden;" class="table-page-search-submitButtons">-->
<!--              <a-button type="primary" @click="searchQuery" icon="search">查询</a-button>-->
<!--              <a-button type="primary" @click="searchReset" icon="reload" style="margin-left: 8px">重置</a-button>-->
<!--              <a @click="handleToggleSearch" style="margin-left: 8px">-->
<!--                {{ toggleSearchStatus ? '收起' : '展开' }}-->
<!--                <a-icon :type="toggleSearchStatus ? 'up' : 'down'"/>-->
<!--              </a>-->
<!--            </span>-->
<!--          </a-col>-->
<!--        </a-row>-->
<!--      </a-form>-->
<!--    </div>-->
    <!-- 查询区域-END -->

    <!-- 操作按钮区域 -->
    <div class="table-operator">
      <a-button @click="handleAdd" type="primary" icon="plus">新增</a-button>
<!--      <a-button type="primary" icon="download" @click="handleExportXls('shoe_investors')">导出</a-button>-->
<!--      <a-upload name="file" :showUploadList="false" :multiple="false" :headers="tokenHeader" :action="importExcelUrl" @change="handleImportExcel">-->
<!--        <a-button type="primary" icon="import">导入</a-button>-->
<!--      </a-upload>-->
<!--       高级查询区域-->
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
<!--          <a @click="handleEdit(record)">编辑</a>-->

          <a-divider type="vertical" />
<!--          <a-dropdown>-->
<!--            <a class="ant-dropdown-link">更多 <a-icon type="down" /></a>-->
<!--            <a-menu slot="overlay">-->
<!--              <a-menu-item>-->
<!--                <a @click="handleDetail(record)">详情</a>-->
<!--              </a-menu-item>-->
<!--              <a-menu-item>-->
<!--                <a-popconfirm title="确定删除吗?" @confirm="() => handleDelete(record.investorsId)">-->
<!--                  <a>删除</a>-->
<!--                </a-popconfirm>-->
<!--              </a-menu-item>-->
<!--            </a-menu>-->
<!--          </a-dropdown>-->
        </span>

      </a-table>
    </div>

    <shoe-investors-modal ref="modalForm" @ok="modalFormOk"></shoe-investors-modal>
  </a-card>
</template>

<script>

  import '@/assets/less/TableExpand.less'
  import { mixinDevice } from '@/utils/mixin'
  import { JeecgListMixin } from '@/mixins/JeecgListMixin'
  import ShoeInvestorsModal from './modules/ShoeInvestorsModal'
  import { httpAction } from '@api/manage'

  export default {
    name: 'ShoeInvestorsList',
    mixins:[JeecgListMixin, mixinDevice],
    components: {
      ShoeInvestorsModal
    },
    data () {
      return {
        description: 'shoe_investors管理页面',
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
          {
            title:'姓名',
            align:"center",
            dataIndex: 'name'
          },
          {
            title:'手机号',
            align:"center",
            dataIndex: 'phone'
          },
          {
            title:'身份',
            align:"center",
            dataIndex: 'levelText'
          },
          {
            title:'机柜数',
            align:"center",
            dataIndex: 'num'
          },
          {
            title: '订单数',
            align: 'center',
            dataIndex: 'orderNum'
          },
          {
            title:'总收益',
            align:"center",
            dataIndex: 'income'
          },
          {
            title:'余额',
            align:"center",
            dataIndex: 'amount'
          },
          // {
          //   title:'提现中金额',
          //   align:"center",
          //   dataIndex: 'withdrawalingAmount'
          // },
          {
            title:'添加人',
            align:"center",
            dataIndex: 'addUserId'
          },
          // {
          //   title: '操作',
          //   dataIndex: 'action',
          //   align:"center",
          //   fixed:"right",
          //   width:147,
          //   scopedSlots: { customRender: 'action' }
          // }
        ],
        url: {
          list: "/shoes/shoeInvestors/pageList",
          delete: "/shoes/shoeInvestors/delete",
          deleteBatch: "/shoes/shoeInvestors/deleteBatch",
          exportXlsUrl: "/shoes/shoeInvestors/exportXls",
          importExcelUrl: "/shoes/shoeInvestors/importExcel",

        },
        dictOptions:{},
        superFieldList:[],
        levelTextList:[],
      }
    },
    created() {
    this.getSuperFieldList();
    this.getLevelTextList();
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
        fieldList.push({type:'string',value:'name',text:'姓名',dictCode:''})
        fieldList.push({type:'string',value:'phone',text:'手机号',dictCode:''})
        fieldList.push({type:'sel_user',value:'level',text:'身份'})
        fieldList.push({type:'sel_search',value:'userId',text:'绑定小程序用户id',dictTable:"", dictText:'', dictCode:''})
        fieldList.push({type:'int',value:'num',text:'机柜数',dictCode:''})
        fieldList.push({type:'int',value:'income',text:'总收入',dictCode:''})
        fieldList.push({type:'int',value:'amount',text:'账户余额',dictCode:''})
        fieldList.push({type:'int',value:'withdrawalingAmount',text:'提现中金额',dictCode:''})
        fieldList.push({type:'string',value:'addUserId',text:'添加人',dictCode:''})
        this.superFieldList = fieldList
      },

      getLevelTextList(){
        httpAction("/shoes/shoeInvestors/statusList", null, "get").then((res) => {
          if (res){
            this.levelTextList = res.result;
            console.log(res.result);
          }
        })
      }
    }
  }
</script>
<style scoped>
  @import '~@assets/less/common.less';
</style>
