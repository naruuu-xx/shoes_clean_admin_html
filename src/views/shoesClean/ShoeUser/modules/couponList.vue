<template>
  <a-modal v-model:visible="visible" title="优惠卷列表" :footer="null" width="1200px">
    <!-- 查询区域-begin -->
    <div class="table-page-search-wrapper">
      <a-form layout="inline" @keyup.enter.native="searchQuery">
        <a-row :gutter="24">
          <a-col :xl="5" :lg="7" :md="8" :sm="24">
            <a-form-item label="优惠卷名称">
              <a-input placeholder="请输入优惠卷名称" v-model="queryParam.name"></a-input>
            </a-form-item>
          </a-col>
          <a-col :xl="5" :lg="7" :md="8" :sm="24">
            <a-form-item label="优惠券状态">
              <a-select v-model="queryParam.status" style="width: 120px" :options="statusOption">
              </a-select>
            </a-form-item>
          </a-col>
          <a-col :xl="5" :lg="7" :md="8" :sm="24">
            <a-form-item label="是否停用">
              <a-select v-model="queryParam.delFlag" style="width: 120px" :options="delFlagOption">
              </a-select>
            </a-form-item>
          </a-col>


          <a-col :xl="5" :lg="7" :md="8" :sm="24">
                <span style="float: left;overflow: hidden;" class="table-page-search-submitButtons">
                  <a-button type="primary" @click="initDataByDIY2" icon="search">查询</a-button>
                  <a-button type="primary" @click="searchReset2" icon="reload" style="margin-left: 8px">重置</a-button>
                </span>
          </a-col>
        </a-row>
      </a-form>
    </div>

    <!-- table区域-begin -->
    <div>
      <a-table
        ref="table"
        size="middle"
        :scroll="{x:true}"
        bordered
        rowKey="distributorId"
        :columns="columns"
        :dataSource="dataSource"
        :pagination="ipagination"
        :loading="loading"
        class="j-table-force-nowrap"
        @change="handleTableChange">
        <template slot="htmlSlot" slot-scope="text">
          <div v-html="text"></div>
        </template>

        <span slot="action" slot-scope="text, record">
<!--          <a @click="stopStatus(record)" v-if="record.status==1 && record.useStatus=='可使用'" style="color: red">停用</a>-->
  <a @click="handleDeleteByDiy(record)" v-if="record.status==0 && record.useStatus=='可使用'"
     v-has="'user:status:button'">启用</a>
           <a-popconfirm title="确定停用吗?" @confirm="() => handleDeleteByDiy(record)"
                         v-if="record.status==1 && record.useStatus=='可使用'">
            <a style="color: red" v-has="'user:status:button'">停用</a>
          </a-popconfirm>



        </span>


      </a-table>
    </div>

  </a-modal>
</template>

<script>
import '@assets/less/TableExpand.less'
import {mixinDevice} from '@/utils/mixin'
import {JeecgListMixin} from '@/mixins/JeecgListMixin'
import {getAction, httpAction} from "@api/manage";

export default {
  name: "SecondDistributorList",
  mixins: [JeecgListMixin, mixinDevice],
  data() {
    return {
      queryParam: {},
      visible: false,
      id: null,
      dataSource: [],
      ipagination: {total: 0},
      loading: false,
      url: {
        list: "/ShoeCoupon/shoeCoupon/getCouponByid",
      },
      statusOption: [{
        label: '全部',
        value: ''
      }, {
        label: '可使用',
        value: 0
      }, {
        label: '已使用',
        value: 1
      }, {
        label: '已失效',
        value: 2
      }],
      delFlagOption: [{
        label: '全部',
        value: ''
      }, {
        label: '是',
        value: 0
      }, {
        label: '否',
        value: 1
      }],
      columns: [
        {
          title: '优惠券名称',
          align: "center",
          dataIndex: 'name'
        },
        {
          title: '优惠券状态',
          align: "center",
          dataIndex: 'useStatus'
        },
        {
          title: '领取时间',
          align: "center",
          dataIndex: 'createTime'
        },
        {
          title: '优惠券过期时间',
          align: "center",
          dataIndex: 'endTime'
        },
        {
          title: '使用时间',
          align: "center",
          dataIndex: 'useTime'
        },
        {
          title: '是否停用',
          align: "center",
          dataIndex: 'status',
          customRender: (status) => {
            if (status == 0) {
              status = '是'
            } else status = '否'
            return status;
          },
        },
        {
          title: '操作',
          dataIndex: 'action',
          align: 'center',
          scopedSlots: { customRender: 'action' }
        }
      ],
    }
  },
  created() {

  },
  methods: {
    show(record) {
      this.visible = true;
      this.id = record.userId;
      this.initDataByDIY(record);
    },
    stopStatus(record) {

    },
    startStatus(record) {

    },
    initDataByDIY(record) {
      this.queryParam.id = record.userId;
      getAction(this.url.list + "?id=" + this.id).then((res) => {
        if (res.success) {
          //把数据传入dataSource
          this.dataSource = res.result.records;
          this.ipagination.total = res.result.total;
        }
      })
    },
    handleDeleteByDiy(record) {
      let id = record.userCouponId;
      let status = record.status;

      let form = {
        "id": id,
        "status": status
      }
      httpAction("/ShoeCoupon/shoeCoupon/update", form, "put").then((res) => {
        if (res.success) {
          this.initDataByDIY2();
        } else {
          this.$message.warning(res.message);
        }
      })
    },
    searchReset2() {
      this.queryParam = {id: this.id}
      this.initDataByDIY2();
    },
    initDataByDIY2() {
      let data = {
        "id": this.id,
        "name": this.queryParam.name,
        "status": this.queryParam.status,
        "delFlag": this.queryParam.delFlag,
      }
      getAction(this.url.list, data).then((res) => {
        if (res.success) {
          //把数据传入dataSource
          this.dataSource = res.result.records;
          this.ipagination.current = 1;
          this.ipagination.total = res.result.total;
        }
      })
    },
  }
}
</script>

<style scoped>

</style>