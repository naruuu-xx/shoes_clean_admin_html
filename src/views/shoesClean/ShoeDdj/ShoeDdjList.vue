<template>
  <a-card :bordered="false">
    <!-- 查询区域 -->
    <div class="table-page-search-wrapper">
      <a-form layout="inline" @keyup.enter.native="searchQuery">
        <a-row :gutter="24">
          <a-col :xl="4" :lg="7" :md="8" :sm="24">
            <a-form-item label="姓名">
              <a-input placeholder="请输入姓名" v-model="queryParam.name" :allowClear="true"></a-input>
            </a-form-item>
          </a-col>
          <a-col :xl="4" :lg="7" :md="8" :sm="24">
            <a-form-item label="手机号">
              <a-input placeholder="请输入手机号" v-model="queryParam.phone" :allowClear="true"></a-input>
            </a-form-item>
          </a-col>
          <a-col :xl="3" :lg="3" :md="4" :sm="12">
            <a-form-item label="省">
              <a-input placeholder="请输入省" v-model="queryParam.province" :allowClear="true"></a-input>
            </a-form-item>
          </a-col>
          <a-col :xl="3" :lg="3" :md="4" :sm="12">
            <a-form-item label="市">
              <a-input placeholder="请输入市" v-model="queryParam.city" :allowClear="true"></a-input>
            </a-form-item>
          </a-col>
          <a-col :xl="3" :lg="3" :md="4" :sm="12">
            <a-form-item label="区">
              <a-input placeholder="请输入区" v-model="queryParam.area" :allowClear="true"></a-input>
            </a-form-item>
          </a-col>

          <a-col :xl="4" :lg="7" :md="8" :sm="24">
            <a-form-item label="状态">
              <a-select v-model="queryParam.status" style="width: 120px" :options="stateOption">
              </a-select>
            </a-form-item>
          </a-col>
          <a-col :xl="4" :lg="7" :md="8" :sm="24">
            <a-form-item label="类型">
              <a-select v-model="queryParam.delay" style="width: 120px" :options="typeOption">
              </a-select>
            </a-form-item>
          </a-col>
          <a-col :xl="4" :lg="7" :md="8" :sm="24">
            <a-form-item label="来源">
              <a-select v-model="queryParam.platformId" style="width: 120px" :options="sourceOption">
              </a-select>
            </a-form-item>
          </a-col>
          <a-col :xl="6" :lg="7" :md="8" :sm="24">
            <span style="float: left;overflow: hidden;" class="table-page-search-submitButtons">

              <a-button type="primary" @click="searchQuery" icon="search">查询</a-button>
              <a-button type="primary" @click="searchReset" icon="reload" style="margin-left: 8px">重置</a-button>
              <a-button type="primary" @click="add" icon="plus" style="margin-left: 12px">新增</a-button>
              <!-- <a-button type="primary" @click="onMergeOrder" style="margin-left: 8px" :disabled="!selectedRowKeys.length">合并下单</a-button> -->
            </span>
          </a-col>
        </a-row>
      </a-form>
    </div>
    <!-- 查询区域-END -->

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
        rowKey="ddjId"
        :columns="columns"
        :dataSource="dataSource"
        :pagination="ipagination"
        :loading="loading"
        :rowSelection="{columnTitle:'选择',
        selectedRowKeys:selectedRowKeys,
        onChange:selecteChange,
        getCheckboxProps:getCheckboxProps
        }"
        class="j-table-force-nowrap"
        @change="handleTableChange">

        <template slot="kuaidinum" slot-scope="kuaidinum">
          <div>{{kuaidinum || '——'}}</div>
        </template>
        <template slot="pickupTime" slot-scope="pickupTime">
          <div>{{pickupTime || '——'}}</div>
        </template>
        <template slot="code" slot-scope="code">
          <div>{{code || '——'}}</div>
        </template>
        <template slot="delay" slot-scope="delay">
          <div>{{delay | delayFilter}}</div>
        </template>
        
        <template slot="status" slot-scope="status">
          <div>{{status | statusFilter}}</div>
        </template>

        <span slot="action" slot-scope="record">
          <a-button type="link" @click="onOrder(record)" v-if="record.status != 1" >下单</a-button>
          <a-button type="link" @click="updateOrder(record)" v-if="record.status == 1" >编辑</a-button>
        </span>

      </a-table>
    </div>

    <shoe-ddj-modal ref="modalForm" @ok="modalFormOk"></shoe-ddj-modal>
    <ShoeDdjToOrder ref="shoeDdjToOrder" @ok="modalFormOk"></ShoeDdjToOrder>
    <ShoeDdjToUpdateOrder ref="shoeDdjToUpdateOrder" @ok="modalFormOk"></ShoeDdjToUpdateOrder>
    <ShoeDdjToOrderMerge ref="shoeDdjToOrderMerge" @ok="modalFormOk"></ShoeDdjToOrderMerge>
    <shoeDdjToAdd ref="shoeDdjToAdd" @ok="modalFormOk"></shoeDdjToAdd>
  </a-card>
</template>

<script>

  import '@/assets/less/TableExpand.less'
  import { mixinDevice } from '@/utils/mixin'
  import { JeecgListMixin } from '@/mixins/JeecgListMixin'
  import ShoeDdjModal from './modules/ShoeDdjModal'
  import ShoeDdjToOrder from "./modules/ShoeDdjToOrder";
  import ShoeDdjToOrderMerge from "./modules/ShoeDdjToOrderMerge";
  import {httpAction} from "@api/manage";
  import ShoeDdjToUpdateOrder from "@views/shoesClean/ShoeDdj/modules/ShoeDdjToUpdateOrder";
  import ShoeDdjToAdd from "@views/shoesClean/ShoeDdj/modules/ShoeDdjToAdd";

  export default {
    name: 'ShoeDdjList',
    mixins:[JeecgListMixin, mixinDevice],
    components: {
      ShoeDdjModal,
      ShoeDdjToUpdateOrder,
      ShoeDdjToOrder,
      ShoeDdjToAdd,
      ShoeDdjToOrderMerge
    },
    data () {
      return {
        description: 'shoe_ddj管理页面',
        // 表头
        columns: [
        {
            title:'姓名',
            align:"center",
            dataIndex: 'name'
          },
          {
            title:'电话',
            align:"center",
            dataIndex: 'phone'
          },
          {
            title:'双数',
            align:"center",
            dataIndex: 'num'
          },
          {
            title:'区',
            align:"center",
            dataIndex: 'area'
          },

          {
            title:'详细地址',
            align:"center",
            dataIndex: 'address'
          },
          
          {
            title:'快递单号',
            align:"center",
            dataIndex: 'kuaidinum',
            scopedSlots: { customRender: 'kuaidinum' }
          },
          {
            title:'取件时间',
            align:"center",
            dataIndex: 'pickupTime',
            scopedSlots: { customRender: 'pickupTime' }
          },
          {
            title:'核销码',
            align:"center",
            dataIndex: 'code',
            scopedSlots: { customRender: 'code' }
          },
          {
            title:'类型',
            align:"center",
            dataIndex: 'delay',
            scopedSlots: { customRender: 'delay' }
          },
          {
            title:'来源',
            align:"center",
            dataIndex: 'platformName',
            scopedSlots: { customRender: 'platformName' }
          },
          {
            title:'状态',
            align:"center",
            dataIndex: 'status',
            scopedSlots: { customRender: 'status' }
          },
          {
            title: '操作',
            align:"center",
            fixed:"right",
            width:147,
            scopedSlots: { customRender: 'action' }
          }
        ],
        stateOption:[{
          label:'全部',
          value:''
        },{
          label:'未下单',
          value:0
        },{
          label:'已下单',
          value:1
        },{
          label:'下单失败',
          value:2
        }],
        sourceOption:[],
        typeOption:[{
          label:'全部',
          value:''
        },{
          label:'延时下单',
          value:'1'
        },{
          label:'立即下单',
          value:'0'
        }],
        url: {
          list: "/shoeDdj/list"
        },
        dictOptions:{},
        superFieldList:[],
        type: -1,
        queryParam:{
          delay: '',
          status:''
        }
      }
    },
    filters:{
      delayFilter(val) {
        let text = '——'
        switch (val) {
          case 0:
            text = '立即下单'
            break;
          case 1:
            text = '延时下单'
            break;
        }
        return text
         
      },
      statusFilter(val) {
        let text = '未下单'
        switch (val) {
          case 1:
            text = '已下单'
            break;
          case 2:
            text = '下单失败'
            break;
        }
        return text
      }
    },
    created() {
    this.getSource();
    },
    computed: {

    },
    methods: {
      getSource(){
        httpAction("/shoeDdj/getSource", "", "get").then((res)=> {
          console.log("====",res.result);
          this.sourceOption=res.result;
        })
      },
      selecteChange(selectedRowKeys, selectedRows) {
        let ddjId = selectedRowKeys.filter(v => !this.selectedRowKeys.includes(v))[0] // 获取选中项的id
        let idx = selectedRows.findIndex(item => item.ddjId == ddjId) // 获取选中项的下标
        let selected = selectedRows[idx] // 选中项
        if(selected) {
          if(!this.selectedRowKeys.length) {
            this.type = selected.delay
          }
          if(selected.delay == this.type || this.selectedRowKeys.length == 0) {
            this.selectedRowKeys = selectedRowKeys
          } else {
            this.$message.warning("只能勾选同类型的订单！");
          }
        } else {
          this.selectedRowKeys = selectedRowKeys
        }
      },
      getCheckboxProps(record) {
        return {
          props: {
            disabled: record.status == '1', // Column configuration not to be checked
            name: record.name,
          },
        }
      },
      onOrder(record) {
        // console.log(8888,record);
        let {ddjId,delay,num} = record
        let orderType = delay === 1 ? '0' : '1'
        this.$refs.shoeDdjToOrder.show({ddjId,orderType,num}) 
      },
      updateOrder(record) {

        this.$refs.shoeDdjToUpdateOrder.show(record.ddjId)
      },
      add(){
        this.$refs.shoeDdjToAdd.show()
      },

      onMergeOrder() {
        console.log(888,this.selectedRowKeys);
        this.$refs.shoeDdjToOrderMerge.show({
          ids:this.selectedRowKeys,
          orderType:this.type == 1 ? '4' : '3'
        }) 
      },
      initDictConfig(){
      },
    }
  }
</script>
<style scoped>
  @import '~@assets/less/common.less';
</style>