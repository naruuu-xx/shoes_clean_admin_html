<template>
  <a-card :bordered="false">
    <!-- 查询区域 -->
    <div class="table-page-search-wrapper">
      <a-form layout="inline" @keyup.enter.native="searchQuery">
        <a-row :gutter="24">
<!--          <a-col :xl="6" :lg="7" :md="8" :sm="24">-->
<!--            <a-form-item label=" ID">-->
<!--              <a-input placeholder="请输入 ID" v-model="queryParam.logisticsId"></a-input>-->
<!--            </a-form-item>-->
<!--          </a-col>-->
          <a-col :xl="4" :lg="7" :md="8" :sm="24">
            <a-form-item label=" 姓名">
              <a-input placeholder="请输入 姓名" v-model="queryParam.name"></a-input>
            </a-form-item>
          </a-col>
          <a-col :xl="4" :lg="7" :md="8" :sm="24">
            <a-form-item label=" 手机号（账号）">
              <a-input placeholder="请输入手机号" v-model="queryParam.phone"></a-input>
            </a-form-item>
          </a-col>
          <a-col :xl="4" :lg="7" :md="8" :sm="24" v-has="'area:list'">
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
      <a-button @click="handleAdd" type="primary" icon="plus" v-has="'add:logistics'">新增</a-button>
<!--      <a-button type="primary" icon="download" @click="handleExportXls('shoe_logistics')">导出</a-button>-->
<!--      <a-upload name="file" :showUploadList="false" :multiple="false" :headers="tokenHeader" :action="importExcelUrl" @change="handleImportExcel">-->
<!--        <a-button type="primary" icon="import">导入</a-button>-->
<!--      </a-upload>-->
      <!-- 高级查询区域 -->
<!--      <j-super-query :fieldList="superFieldList" ref="superQueryModal" @handleSuperQuery="handleSuperQuery"></j-super-query>-->
      <a-dropdown v-if="selectedRowKeys.length > 0">
        <a-menu slot="overlay">
          <a-menu-item key="1" @click="batchDel"><a-icon type="delete"/>删除</a-menu-item>
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
        rowKey="logisticsId"
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
          <a @click="handleEdit(record)">编辑</a>

          <a-divider type="vertical" />
          <a-dropdown>
            <a class="ant-dropdown-link">更多 <a-icon type="down" /></a>
            <a-menu slot="overlay">
<!--              <a-menu-item>-->
<!--                <a @click="handleDetail(record)">详情</a>-->
<!--              </a-menu-item>-->
              <a-menu-item>
                <a href="javascript:;" @click="handleChangePassword(record.phone)">密码</a>
              </a-menu-item>
              <a-menu-item>
                <a-popconfirm title="确定删除吗?" @confirm="() => handleDelete(record.logisticsId)">
                  <a>删除</a>
                </a-popconfirm>
              </a-menu-item>
            </a-menu>
          </a-dropdown>
        </span>

      </a-table>
    </div>

    <shoe-logistics-modal ref="modalForm" @ok="modalFormOk"></shoe-logistics-modal>
    <password-modal ref="passwordmodal" @ok="passwordModalOk"></password-modal>
  </a-card>
</template>

<script>

  import '@/assets/less/TableExpand.less'
  import { mixinDevice } from '@/utils/mixin'
  import { JeecgListMixin } from '@/mixins/JeecgListMixin'
  import ShoeLogisticsModal from './modules/ShoeLogisticsModal'
  import {filterMultiDictText} from '@/components/dict/JDictSelectUtil'
  import PasswordModal from './modules/PasswordModal'
  import XfSelect from '@/components/Xf/XfSelect'

  export default {
    name: 'ShoeLogisticsList',
    mixins:[JeecgListMixin, mixinDevice],
    components: {
      ShoeLogisticsModal,
      PasswordModal,
      XfSelect
    },
    data () {
      return {
        description: 'shoe_logistics管理页面',
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
            title:' ID',
            align:"center",
            dataIndex: 'logisticsId'
          },
          {
            title:' 姓名',
            align:"center",
            dataIndex: 'name'
          },
          {
            title:' 区域',
            align:"center",
            dataIndex: 'departName'
          },
          {
            title: '快递柜数',
            align:"center",
            dataIndex: 'lockerNum',
          },
          {
            title:' 手机号（账号）',
            align:"center",
            dataIndex: 'phone'
          },
          {
            title:' 状态 ',
            align:"center",
            dataIndex: 'status',
            customRender: (text) => (filterMultiDictText(this.dictOptions['status'], text)),
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
          // list: "/shoes/shoeLogistics/list",
          list: "/shoes/shoeLogistics/queryList",
          delete: "/shoes/shoeLogistics/delete",
          deleteBatch: "/shoes/shoeLogistics/deleteBatch",
          exportXlsUrl: "/shoes/shoeLogistics/exportXls",
          importExcelUrl: "shoes/shoeLogistics/importExcel",

        },
        dictOptions:{},
        superFieldList:[],
      }
    },
    created() {
      this.$set(this.dictOptions, 'status', [{text:'正常',value:'1'},{text:'禁用',value:'0'}])
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
        fieldList.push({type:'int',value:'logisticsId',text:' ID',dictCode:''})
        fieldList.push({type:'string',value:'name',text:' 姓名',dictCode:''})
        fieldList.push({type:'string',value:'phone',text:' 手机号（账号）',dictCode:''})
        fieldList.push({type:'switch',value:'status',text:' 状态 '})
        this.superFieldList = fieldList
      },
      handleChangePassword(phone) {
        this.$refs.passwordmodal.show(phone);
      },
      passwordModalOk(){

      }
    }
  }
</script>
<style scoped>
  @import '~@assets/less/common.less';
</style>