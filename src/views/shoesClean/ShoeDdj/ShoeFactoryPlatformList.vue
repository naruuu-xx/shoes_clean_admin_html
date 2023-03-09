<template>
  <a-card :bordered="false">
    <!-- 查询区域 -->
    <div class="table-page-search-wrapper">
      <a-form layout="inline" @keyup.enter.native="searchQuery">
        <a-row :gutter="24">
          <a-col :xl="4" :lg="7" :md="8" :sm="24">
            <a-form-item label="活动名称">
              <a-input placeholder="请输入名称" v-model="queryParam.name"></a-input>
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

    </div>

    <!-- table区域-begin -->
    <div>


      <a-table
        ref="table"
        size="middle"
        :scroll="{x:true}"
        bordered
        rowKey="platformId"
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
          <img v-else :src="getImgView(text)" :preview="record.couponId" height="25px" alt="" style="max-width:80px;font-size: 12px;font-style: italic;"/>
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

        <span  slot="action" slot-scope="text, record">
          <a @click="update(record.platformId)">编辑</a>
          <a-divider type="vertical" />
           <a-popconfirm title="确定删除吗?" @confirm="() => handleDelete(record.platformId)">
            <a>删除</a>
          </a-popconfirm>

        </span>

      </a-table>


    </div>

<!--    <shoe-coupon-modal ref="modalForm" @ok="modalFormOk"></shoe-coupon-modal>-->

    <shoe-factory-platform-add ref="shoeFactoryPlatformAdd" @ok="queryEventList"></shoe-factory-platform-add>
    <shoe-factory-platform-update ref="shoeFactoryPlatformUpdate" @ok="queryEventList"></shoe-factory-platform-update>
  </a-card>
</template>

<script>

  import '@/assets/less/TableExpand.less'
  import { mixinDevice } from '@/utils/mixin'
  import { JeecgListMixin } from '@/mixins/JeecgListMixin'
  import {filterDictTextByCache} from "../../../components/dict/JDictSelectUtil";
  import {httpAction} from "../../../api/manage";
  import ShoeFactoryPlatformAdd from "@views/shoesClean/ShoeDdj/modules/ShoeFactoryPlatformAdd";
  import ShoeFactoryPlatformUpdate from "@views/shoesClean/ShoeDdj/modules/ShoeFactoryPlatformUpdate";

  export default {
    name: 'ShoeFactoryPlatformList',
    mixins:[JeecgListMixin, mixinDevice],
    components: {
      ShoeFactoryPlatformAdd,
      ShoeFactoryPlatformUpdate
    },
    data () {
      return {
        description: '活动管理页面',
        dataSource: '',
        // 表头
        columns: [
          {
            title:'ID',
            align:"center",
            dataIndex: 'platformId'
          },
          {
            title:'来源',
            align:"center",
            dataIndex: 'name'
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
          list: "/shoeFactoryPlatform/list",
          delete: "/shoeFactoryPlatform/delete",


        },
        dictOptions:{},
        superFieldList:[],
        eventList: [],
        form: {
          name: ''
        },
      }
    },
    created() {
      this.getSuperFieldList();
      //调用查询活动列表接口
      this.queryEventList();
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
      queryEventList() {
        httpAction("/shoeFactoryPlatform/list", null, "get").then((res) => {
          if (res.success) {
            this.dataSource = res.result.records;
            this.ipagination.total = res.result.total;
          }
        })
      },
      update(id){
        this.$refs.shoeFactoryPlatformUpdate.show(id)
      },
      handleAdd(){
        this.$refs.shoeFactoryPlatformAdd.show()
      },

      delete(platformId){
        httpAction("/shoeFactoryPlatform/delete", platformId, "delete").then((res) => {
          if (res.success) {
            this.dataSource = res.result.records;
            this.ipagination.total = res.result.total;
          }
        })
      },
    }
  }
</script>
<style scoped>
  @import '~@assets/less/common.less';

  .tableHeader{
    font-size: 16px;
    text-align:center;
    margin: 16px 0 16px 0;
  }
  .tableCell{
    font-size: 14px;
    text-align:center;
    margin: 14px 0 14px 0;
  }
</style>