<template>
  <a-card :bordered="false">
    <!-- 查询区域 -->
    <div class="table-page-search-wrapper">
      <a-form layout="inline" @keyup.enter.native="searchQuery">
        <a-row :gutter="24">

          <a-col :xl="6" :lg="7" :md="8" :sm="24">
            <a-form-item label="手机号">
              <a-input placeholder="请输入手机号" v-model="queryParam.phone"></a-input>
            </a-form-item>
          </a-col>
          <a-col :xl="6" :lg="7" :md="8" :sm="24">
            <a-form-item label="申请人">
              <a-input placeholder="请输入申请人名称" v-model="queryParam.name"></a-input>
            </a-form-item>
          </a-col>
          <a-col :xl="3" :lg="7" :md="8" :sm="24">
            <a-form-item label=" 状态">
              <!--              <a-input placeholder="请输入 申请人" v-model="queryParam.name" autocomplete="off"></a-input>-->
              <a-select v-model="queryParam.status">
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



        <span slot="action" slot-scope="text, record">
          <a v-if="record.status==0" @click="handleAudit(record)">审核</a>
          <a v-if="record.status!=0" @click="getDetail(record)">详情</a>



        </span>

      </a-table>
    </div>

    <shoe-coupon-exchange-third-audit  ref="modalAudit2" @ok="modalFormOk"></shoe-coupon-exchange-third-audit>
    <get-detail  ref="getDetail" @ok="modalFormOk"></get-detail>
  </a-card>
</template>

<script>

import '@/assets/less/TableExpand.less'
import {mixinDevice} from '@/utils/mixin'
import {JeecgListMixin} from '@/mixins/JeecgListMixin'
import ShoeCouponExchangeThirdModal from './modules/ShoeCouponExchangeThirdModal'
import ShoeCouponExchangeThirdAudit
  from "@views/shoesClean/ShoeCouponExchangeThird/modules/ShoeCouponExchangeThirdAudit";
import getDetail from "@views/shoesClean/ShoeCouponExchangeThird/modules/getDetail";

export default {
  name: 'ShoeCouponExchangeThirdList',
  mixins: [JeecgListMixin, mixinDevice],
  components: {
    ShoeCouponExchangeThirdModal,
    ShoeCouponExchangeThirdAudit,
    getDetail
  },
  data() {
    return {
      description: 'shoe_coupon_exchange_third管理页面',
      // 表头
      columns: [

        {
          title: '申请人',
          align: "center",
          dataIndex: 'name'
        },
        {
          title: '手机号',
          align: "center",
          dataIndex: 'phone'
        },

        {
          title: '兑换码',
          align: "center",
          dataIndex: 'code'
        },
        {
          title: '申请时间',
          align: "center",
          dataIndex: 'createTime'
        },
        {
          title: '审核时间',
          align: "center",
          dataIndex: 'updateTime'
        },
        {
          title: '操作人',
          align: "center",
          dataIndex: 'updateName'
        },
        {
          title: '状态',
          align: "center",
          dataIndex: 'status',
          customRender: function (text) {
            if (text == 0) {
              return text = '审核中'
            } else if (text == 1) {
              return text = '已同意'
            } else if (text == 2) {
              return text = '已拒绝'
            }
          }
        },
        {
          title:'派发类型',
          align:"center",
          dataIndex:'type',
          customRender:function (text) {
            if(text === 1){
              return text = '优惠券'
            }else if(text === 2){
              return text = '鞋蜂卡'
            }else{
              return text = ''
            }
          }
        },
        {
          title: '操作',
          dataIndex: 'action',
          align: "center",
          fixed: "right",
          width: 147,
          scopedSlots: {customRender: 'action'}
        }
      ],
      statusOptionList: [
        {"value": "", "name": "全部"}, {"value": "0", "name": "审核中"}, {"value": "1", "name": "已同意"},
        {"value": "2", "name": "已拒绝"}
      ],
      url: {
        list: "/shoeCouponExchangeThird/list"

      },
      dictOptions: {},
      superFieldList: [],
    }
  },
  created() {
    this.getSuperFieldList();
  },
  computed: {},
  methods: {
    initDictConfig() {
    },
    handleAudit(record){
      this.$refs.modalAudit2.show(record);
    },
    getDetail(record){
      this.$refs.getDetail.show(record);
    },
    getSuperFieldList() {
      let fieldList = [];
      fieldList.push({type: 'int', value: 'couponExchangeThirdId', text: 'id', dictCode: ''})
      fieldList.push({type: 'int', value: 'couponId', text: '发放优惠券Id', dictCode: ''})
      fieldList.push({type: 'string', value: 'code', text: '兑换码', dictCode: ''})
      fieldList.push({type: 'int', value: 'userId', text: '用户id', dictCode: ''})
      fieldList.push({type: 'int', value: 'status', text: '核销状态，0=审核中，1=已同意，2=已拒绝', dictCode: ''})
      fieldList.push({type: 'int', value: 'phone', text: '手机号', dictCode: ''})
      fieldList.push({type: 'string', value: 'name', text: '姓名', dictCode: ''})
      fieldList.push({type: 'string', value: 'note', text: '拒绝原因', dictCode: ''})
      this.superFieldList = fieldList
    }
  }
}
</script>
<style scoped>
@import '~@assets/less/common.less';
</style>