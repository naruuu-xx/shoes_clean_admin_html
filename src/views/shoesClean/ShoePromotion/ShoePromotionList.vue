<template>
  <a-card :bordered="false">
    <!-- 查询区域 -->
    <div class="table-page-search-wrapper">
      <a-form layout="inline" @keyup.enter.native="searchQuery">
        <a-row :gutter="24">
          <a-col :xl="4" :lg="7" :md="8" :sm="24">
            <a-form-item label=" 推广渠道">
              <a-input placeholder="请输入推广渠道" v-model="queryParam.channel" :allowClear="true"></a-input>
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
      <a-button @click="handleAdd" type="primary" icon="plus">新增</a-button>
      <!-- 高级查询区域 -->
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
        rowKey="promotionId"
        :columns="columns"
        :dataSource="dataSource"
        :pagination="ipagination"
        :loading="loading"
        :rowSelection="{selectedRowKeys: selectedRowKeys, onChange: onSelectChange}"
        class="j-table-force-nowrap"
        @change="handleTableChange">


        <span slot="action" slot-scope="text, record">
          <a @click="previewModel(record)">推广码</a>
          <a-divider type="vertical" />
          <a @click="handleEdit(record)">编辑</a>

          <a-divider type="vertical" />
          <a-dropdown>
            <a class="ant-dropdown-link">更多 <a-icon type="down" /></a>
            <a-menu slot="overlay">
              <a-menu-item>
                <a @click="handleDetail(record)">详情</a>
              </a-menu-item>
              <a-menu-item>
                <a-popconfirm title="确定删除吗?" @confirm="() => handleDelete(record.promotionId)">
                  <a >删除</a>
                </a-popconfirm>
              </a-menu-item>
            </a-menu>
          </a-dropdown>
        </span>

      </a-table>

      <a-modal :visible="previewVisible" :footer="null" @cancel="handleModelCancel()">
        <img alt="example" style="width: 100%" :src="previewImage"/>
      </a-modal>
    </div>

    <shoe-promotion-modal ref="modalForm" @ok="modalFormOk"></shoe-promotion-modal>
  </a-card>
</template>

<script>

  import '@/assets/less/TableExpand.less'
  import { mixinDevice } from '@/utils/mixin'
  import { JeecgListMixin } from '@/mixins/JeecgListMixin'
  import ShoePromotionModal from './modules/ShoePromotionModal'
  import { filterDictTextByCache } from '@comp/dict/JDictSelectUtil'

  export default {
    name: 'ShoePromotionList',
    mixins:[JeecgListMixin, mixinDevice],
    components: {
      ShoePromotionModal
    },
    data () {
      return {
        description: 'shoe_promotion管理页面',
        // 表头
        columns: [
          {
            title:'推广渠道名称',
            align:"center",
            dataIndex: 'channel'
          },
          {
            title: '推广渠道类型',
            align: 'center',
            dataIndex: 'typeText',
          },
          {
            title:'推广链接',
            align:"center",
            dataIndex: 'url'
          },
          {
            title: '创建时间',
            align: 'center',
            dataIndex: 'createTime'
          },
          {
            title:'推广状态',
            align:"center",
            dataIndex: 'status',
            customRender: (text) => {
              return filterDictTextByCache('promotion_status', text);
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
          list: "/shoes/shoePromotion/list",
          delete: "/shoes/shoePromotion/delete",
          deleteBatch: "/shoes/shoePromotion/deleteBatch",
          exportXlsUrl: "/shoes/shoePromotion/exportXls",
          importExcelUrl: "shoes/shoePromotion/importExcel",

        },
        dictOptions:{},
        superFieldList:[],
        previewVisible:false,
        previewImage:"",
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
        fieldList.push({type:'string',value:'channel',text:'推广渠道名称',dictCode:''})
        fieldList.push({type:'int',value:'type',text:'推广渠道类型（1=推广人，2=其他）',dictCode:''})
        fieldList.push({type:'string',value:'url',text:'推广链接',dictCode:''})
        fieldList.push({type:'string',value:'qrcode',text:'推广二维码',dictCode:''})
        fieldList.push({type:'int',value:'userId',text:'推广人绑定用户id',dictCode:''})
        fieldList.push({type:'int',value:'status',text:'推广状态（0=禁用，1=启用）',dictCode:''})
        this.superFieldList = fieldList
      },
      handleModelCancel() {
        let that = this;
        that.previewVisible = false;
        that.previewImage = "";
      },
      previewModel(record) {
        let that = this;
        that.previewVisible = true;
        that.previewImage = record.qrcode;
      },
    }
  }
</script>
<style scoped>
  @import '~@assets/less/common.less';
</style>