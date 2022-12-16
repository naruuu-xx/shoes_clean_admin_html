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
   <div class="table-page-search-wrapper">
     <a-form layout="inline" @keyup.enter.native="searchQuery">
       <a-row :gutter="24">
         <a-col :xl="10" :lg="12" :md="24" :sm="24">
           <a-form-item label="注册时间">
             <a-range-picker v-model="queryParam.createTime" />
           </a-form-item>
         </a-col>
         <a-col :xl="10" :lg="12" :md="24" :sm="24">
           <a-form-item label="完成时间">
            <a-range-picker v-model="queryParam.finishTime" />
           </a-form-item>
         </a-col>
         <a-col :xl="4" :lg="6" :md="12" :sm="24">
           <a-form-item label="下单状态">
            <a-select v-model="queryParam.status" style="width: 120px">
              <a-select-option :value="status.value" v-for="status in statusList" :key="status.value">
                {{status.label}}
              </a-select-option>
            </a-select>
           </a-form-item>
         </a-col>
       </a-row>

       <a-row>
        <a-col :xl="6" :lg="7" :md="8" :sm="24">
           <span style="float: left;overflow: hidden;" class="table-page-search-submitButtons">
             <a-button type="primary" @click="searchQuery" icon="search">查询</a-button>
           </span>
         </a-col>
       </a-row>
     </a-form>
   </div>
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
        <template slot="avatar" slot-scope="text,record">
          <span v-if="!text" style="font-size: 12px;font-style: italic;">无图片</span>
          <img v-else :src="text" :preview="record.userId" height="25px" alt="" style="max-width:80px;font-size: 12px;font-style: italic;"/>
        </template>
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
import moment from 'moment';
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
          title: '手机号',
          align: "center",
          dataIndex: 'phone'
        },
        {
          title:'头像',
          align:"center",
          dataIndex: 'avatar',
          scopedSlots: { customRender: 'avatar' }
        },
        {
          title: '注册时间',
          align:'center',
          dataIndex:'createTime'
        },
        {
          title: '下单状态',
          align:'center',
          dataIndex:'statusText'
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
      queryParam:{
        createTime:[],
        createTimeLeft:'',
        createTimeRight:'',
        finishTimeLeft:'',
        createTimeRight:'',
        finishTime:[],
        status: 3
      },
      statusList:[
        {
          label:'全部',
          value:3
        },
        {
          label:'未下单',
          value:0
        },
        {
          label:'进行中',
          value:1
        },
        {
          label:'已完成',
          value:2
        },
      ]

    }
  },
  created() {
    this.getSuperFieldList();
    this.getInfoList(this.$route.params.promotionId);

  },
  watch:{
    'queryParam.createTime': {
        handler(newV) {
          this.queryParam.createTimeLeft = moment(newV[0]).format('YYYY-MM-DD')
          this.queryParam.createTimeright = moment(newV[1]).format('YYYY-MM-DD')
      },
      immediate: true
    },
    'queryParam.finishTime': {
        handler(newV) {
          this.queryParam.finishTimeLeft = moment(newV[0]).format('YYYY-MM-DD')
          this.queryParam.finishTimeright = moment(newV[1]).format('YYYY-MM-DD')
      },
      immediate: true
    }
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