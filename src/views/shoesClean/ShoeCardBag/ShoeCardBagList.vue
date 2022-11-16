<template>
  <a-card :bordered="false">
    <!-- 查询区域 -->
    <div class="table-page-search-wrapper">
      <a-form layout="inline" @keyup.enter.native="searchQuery">
        <a-row :gutter="24">
          <a-col :xl="5" :lg="7" :md="8" :sm="24">
            <a-form-item label="优惠券卡包名称">
              <a-input placeholder="请输入名称" v-model="queryParam.name" style="width: 200px"></a-input>
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
        rowKey="cardBagId"
        :columns="columns"
        :dataSource="dataSource"
        :pagination="ipagination"
        :loading="loading"
        :rowSelection="{selectedRowKeys: selectedRowKeys, onChange: onSelectChange}"
        class="j-table-force-nowrap"
        @change="handleTableChange">

        <span slot="action" slot-scope="text, record">
          <a @click="previewModel(record)">卡包码</a>
          <a-divider type="vertical" />
          <a @click="handleEdit(record)">查看</a>
          <a-divider type="vertical" />
          <a-popconfirm title="确定删除吗?" @confirm="() => handleDelete(record.cardBagId)">
            <a>删除</a>
          </a-popconfirm>
        </span>

      </a-table>
      <!-- 弹窗 -->

      <a-modal :visible="previewVisible" :footer="null" @cancel="handleModelCancel()">
        <img alt="example" style="width: 100%" :src="previewImage"/>
      </a-modal>
    </div>

    <shoe-card-bag-model ref="modalForm" @ok="modalFormOk"></shoe-card-bag-model>

  </a-card>
</template>

<script>
import '@/assets/less/TableExpand.less';
import { mixinDevice } from '@/utils/mixin';
import { JeecgListMixin } from '@/mixins/JeecgListMixin';
import ShoeCardBagModel from './modules/ShoeCardBagModel';

export default {
  name: "ShoeCardBagList",
  mixins:[JeecgListMixin, mixinDevice],
  components: {
    ShoeCardBagModel
  },
  data () {
    return {
      description: 'shoe_card_bag卡包管理页面',
      // 表头
      columns: [
        {
          title:'卡包名称',
          align:"center",
          dataIndex: 'name'
        },
        {
          title:'含券数量',
          align:"center",
          dataIndex: 'sumNum'
        },
        {
          title:'活动开始时间',
          align:"center",
          dataIndex: 'startTime'
        },
        {
          title:'活动结束时间',
          align:"center",
          dataIndex: 'endTime'
        },
        {
          title:'剩余卡包数量',
          align:"center",
          dataIndex: 'surplusNum'
        },
        {
          title:'创建时间',
          align:"center",
          dataIndex: 'createTime'
        },
        {
          title:'创建人',
          align:"center",
          dataIndex: 'realName'
        },
        {
          title: '操作',
          dataIndex: 'action',
          align:"center",
          fixed:"right",
          width:210,
          scopedSlots: { customRender: 'action' }
        }
      ],
      url: {
        list: "/shoes/ShoeCardBag/queryCardCouponList",
        delete: "/shoes/ShoeCardBag/delete",
      },
      previewVisible:false,
      previewImage:"",
    }
  },
  methods:{
    handleModelCancel() {
      let that = this;
      that.previewVisible = false;
      that.previewImage = "";
    },
    previewModel(record) {
      let that = this;
      that.previewVisible = true;
      that.previewImage = record.qrCode;
    },
  }
}
</script>

<style scoped>
  @import '~@assets/less/common.less';
</style>