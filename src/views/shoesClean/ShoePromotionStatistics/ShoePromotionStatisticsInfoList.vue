<template>
  <a-card :bordered="false">

    <div style="background-color: #FFFFFF; padding: 20px;">
      <a-row :gutter="16">
        <a-col :span="6">
          <a-card title="总数" :bordered="false" >
            <p>{{this.infoList.count}}</p>
          </a-card>
        </a-col>
        <a-col :span="6">
          <a-card title="今日" :bordered="false">
            <p>{{ this.infoList.todayCount }}</p>
          </a-card>
        </a-col>
        <a-col :span="6">
          <a-card title="本月" :bordered="false">
            <p>{{ this.infoList.monthCount }}</p>
          </a-card>
        </a-col>
        <a-col :span="6">
          <a-card title="今年" :bordered="false">
            <p>{{this.infoList.yearCount}}</p>
          </a-card>
        </a-col>
      </a-row>
    </div>

    <br/>
    <!-- 查询区域 -->
<!--    <div class="table-page-search-wrapper">-->
<!--      <a-form layout="inline" @keyup.enter.native="searchQuery">-->
<!--        <a-row :gutter="24">-->
<!--          <a-col>-->
<!--            <a-form-item label="注册时间开始范围">-->
<!--              <a-date-picker  v-model="queryParam.createTimeLeft" />-->
<!--            </a-form-item>-->
<!--          </a-col>-->
<!--          <a-col>-->
<!--            <a-form-item label="注册时间结束范围">-->
<!--              <a-date-picker v-model="queryParam.createTimeRight"/>-->
<!--            </a-form-item>-->
<!--          </a-col>-->
<!--          <a-col :xl="6" :lg="7" :md="8" :sm="24">-->
<!--            <span style="float: left;overflow: hidden;" class="table-page-search-submitButtons">-->
<!--              <a-button type="primary" @click="searchQuery" icon="search">查询</a-button>-->
<!--              <a-button type="primary" @click="searchReset" icon="reload" style="margin-left: 8px">重置</a-button>-->
<!--            </span>-->
<!--          </a-col>-->
<!--        </a-row>-->
<!--      </a-form>-->
<!--    </div>-->
    <div>
<!--      <div class="ant-alert ant-alert-info" style="margin-bottom: 16px;">-->
<!--        <i class="anticon anticon-info-circle ant-alert-icon"></i> 已选择 <a style="font-weight: 600">{{ selectedRowKeys.length }}</a>项-->
<!--        <a style="margin-left: 24px" @click="onClearSelected">清空</a>-->
<!--      </div>-->

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

      </a-table>
    </div>

    <shoe-promotion-statistics-modal ref="modalForm" @ok="modalFormOk"></shoe-promotion-statistics-modal>
  </a-card>
</template>

<script>

import '@/assets/less/TableExpand.less'
import { mixinDevice } from '@/utils/mixin'
import { JeecgListMixin } from '@/mixins/JeecgListMixin'
import ShoePromotionStatisticsModal from './modules/ShoePromotionStatisticsModal'
import { getAction, httpAction } from '@api/manage'
export default {
  name: 'ShoePromotionStatisticsList',
  mixins:[JeecgListMixin, mixinDevice],
  components: {
    ShoePromotionStatisticsModal
  },
  data () {
    return {
      description: '推广统计详情页面',
      // 表头
      columns: [
        {
          title:'昵称',
          align:"center",
          dataIndex: 'nickname'
        },
        {
          title:'头像',
          align:"center",
          dataIndex: 'avatar',
        scopedSlots: {customRender: 'imgSlot'}
        },
        {
          title: '注册时间',
          align:'center',
          dataIndex:'createTime'
        },
        {
          title: '下单状态',
          align:'center',
          dataIndex:'status'
        },
        {
          title: '下单时间',
          align:'center',
          dataIndex:'orderTime'
        },
        {
          title:'完成时间',
          align: 'center',
          dataIndex: 'finishTime'
        },
      ],
      url: {
        list: "/shoes/shoePromotionStatistics/infoList?promotionId="+ this.$route.params.promotionId,
        delete: "/shoes/shoePromotionStatistics/delete",
        deleteBatch: "/shoes/shoePromotionStatistics/deleteBatch",
        exportXlsUrl: "/shoes/shoePromotionStatistics/exportXls",
        importExcelUrl: "shoes/shoePromotionStatistics/importExcel",
      },
      dictOptions:{},
      superFieldList:[],
      infoList:[],

    }
  },
  created() {
    this.getSuperFieldList();
    this.getInfoList(this.$route.params.promotionId);

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
      fieldList.push({type:'int',value:'promotionId',text:'推广渠道id'})
      fieldList.push({type:'int',value:'promotionNum',text:'推广人数'})
      fieldList.push({type:'date',value:'date',text:'日期'})
      this.superFieldList = fieldList
    },
    getInfoList(promotionId) {

      httpAction("/shoes/shoePromotionStatistics/queryById?id="+promotionId,"", "get").then((res)=>{
        if(res){
          console.log(res.result);
          this.infoList = res.result;

        }
      })
    },
  },
}
</script>
<style scoped>
@import '~@assets/less/common.less';
</style>