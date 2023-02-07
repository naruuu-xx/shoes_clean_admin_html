<template>
  <a-card :bordered="false">
    <!-- 查询区域 -->
    <div class="table-page-search-wrapper">
      <a-form layout="inline" @keyup.enter.native="searchQuery">
        <a-row :gutter="24">
          <a-col :xl="4" :lg="7" :md="8" :sm="24">
            <a-form-item label="站点名称">
              <a-input placeholder="请输入名称" v-model="queryParam.name" autocomplete="off"></a-input>
            </a-form-item>
          </a-col>

          <a-col :xl="6" :lg="7" :md="8" :sm="24">
            <a-form-item label="区域">
              <a-select v-model="queryParam.departName" style="width: 180px">
                <a-select-option v-for="item in sysDepartVos" :value="item.value" :key="item.value">
                  {{ item.name }}
                </a-select-option>
              </a-select>
            </a-form-item>
          </a-col>

          <a-col :xl="6" :lg="7" :md="8" :sm="24">
            <span style="float: left;overflow: hidden;" class="table-page-search-submitButtons">
              <a-button type="primary" @click="searchQuery" icon="search">查询</a-button>
              <a-button type="primary" @click="searchReset" icon="reload" style="margin-left: 8px">重置</a-button>
              <!--              <a @click="handleToggleSearch" style="margin-left: 8px">-->
              <!--                {{ toggleSearchStatus ? '收起' : '展开' }}-->
              <!--                <a-icon :type="toggleSearchStatus ? 'up' : 'down'"/>-->
              <!--              </a>-->
            </span>
          </a-col>
        </a-row>
      </a-form>
    </div>
    <!-- 查询区域-END -->

    <!-- 操作按钮区域 -->
    <div class="table-operator">
      <a-button @click="handleAdd" type="primary" icon="plus" v-has="'sitemanager:add'">新增</a-button>
    </div>

    <!-- table区域-begin -->
    <div>


      <a-table
        ref="table"
        size="middle"
        :scroll="{x:true}"
        bordered
        rowKey="lockerId"
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
          <img v-else :src="getImgView(text)" :preview="record.id" height="25px" alt=""
               style="max-width:80px;font-size: 12px;font-style: italic;"/>
        </template>
        <template slot="pcaSlot" slot-scope="text">
          <div>{{ getPcaText(text) }}</div>
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
          <a @click="handleEdit(record)" v-has="'sitemanager:update'">编辑</a>

          <a-divider type="vertical"/>
          <a-dropdown>
            <a class="ant-dropdown-link">更多 <a-icon type="down"/></a>

              <a-menu slot="overlay">
                 <a-menu-item>
                          <router-link
                            :to=" '/shoesClean/ShoeSitemanager/ShoeSitemanagerOrderList/'+record.sitemanagerId" v-has="'sitemanager:order'">订单</router-link>
                 </a-menu-item>

                <a-menu-item>
                 <a @click="setPercentage(record)" v-has="'sitemanager:percentage:set'">站点设置</a>
                </a-menu-item>
                <a-menu-item>
                  <router-link
                    :to=" '/shoesClean/ShoeSitemanager/ShoeSitemanagerCourierList/'+record.sitemanagerId" v-has="'sitemanager:courier'">配送员</router-link>
                </a-menu-item>
                <a-menu-item>
                 <a @click="setPercentage(record)" v-has="'sitemanager:courier:money:set'">配送费设置</a>
                </a-menu-item>
              </a-menu>

          </a-dropdown>
        </span>

      </a-table>
    </div>

    <shoe-sitemanager-modal ref="modalForm" @ok="modalFormOk"></shoe-sitemanager-modal>
    <set-percentage ref="setPercentage" @ok="modalFormOk"></set-percentage>
  </a-card>
</template>

<script>

import '@/assets/less/TableExpand.less'
import {mixinDevice} from '@/utils/mixin'
import {JeecgListMixin} from '@/mixins/JeecgListMixin'
import ShoeSitemanagerModal from "@views/shoesClean/ShoeSitemanager/modules/ShoeSitemanagerModal";
import Area from '@/components/_util/Area'
import {filterDictTextByCache} from "@comp/dict/JDictSelectUtil";
import {httpAction} from "../../../api/manage";
import {mapGetters} from 'vuex';
import store from '@/store/'
import SetPercentage from "@views/shoesClean/ShoeSitemanager/modules/SetPercentage"

export default {
  name: 'ShoeSitemanagerList',
  mixins: [JeecgListMixin, mixinDevice],
  components: {
    ShoeSitemanagerModal,
    SetPercentage
  },
  data() {
    return {
      description: 'shoe_locker管理页面',
      // 表头
      columns: [
        {
          title: '站点名称',
          align: "center",
          dataIndex: 'name'
        },
        {
          title: '区域',
          align: "center",
          dataIndex: 'departName'
        },
        {
          title: '站长',
          align: "center",
          dataIndex: 'sitemanagerName'
        },
        {
          title: '手机号',
          align: "center",
          dataIndex: 'phone'
        },
        {
          title: '待付款',
          align: "center",
          dataIndex: 'waitPay'
        },
        {
          title: '配送员待收',
          align: "center",
          dataIndex: 'courierWaitIn'
        },
        {
          title: '站点待入库',
          align: "center",
          dataIndex: 'sitemanagerWaitIn'
        },
        {
          title: '物流待取',
          align: "center",
          dataIndex: 'logisticsWaitGet'
        },
        {
          title: '配送员待取',
          align: "center",
          dataIndex: 'courierWaitGet'
        },
        {
          title: '未送达',
          align: "center",
          dataIndex: 'nondelivery'
        },
        {
          title: '订单数',
          align: "center",
          dataIndex: 'orderTotal'
        },
        {
          title: '订单总额',
          align: "center",
          dataIndex: 'orderMoneyTotal',
          customRender: (orderMoneyTotal) => {
            if (orderMoneyTotal == null) {
              orderMoneyTotal = 0
            }
            orderMoneyTotal = orderMoneyTotal / 100;
            return orderMoneyTotal;
          },
        },
        {
          title: '余额',
          align: "center",
          dataIndex: 'balance',
          customRender: (balance) => {
            if (balance == null) {
              balance = 0
            }
            balance = balance / 100;
            return balance;
          },
        },
        {
          title: '收益比例',
          align: "center",
          dataIndex: 'percentage',
          customRender: (text) => {
            let percentage = (text * 100).toFixed(0) + "%";
            return percentage;
          },
        },
        {
          title: '站点状态',
          align: "center",
          dataIndex: 'status',
          customRender: (text) => {
            return filterDictTextByCache('shoe_locker_status', text);
          },
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
      url: {
        list: "/shoes/shoeLocker/queryListByVirtual",


      },
      dictOptions: {},
      pcaData: '',
      superFieldList: [],
      sysDepartVos: [],

    }
  },
  created() {
    this.pcaData = new Area()
    this.getSuperFieldList();
    console.log(this.userInfo());
    this.getDepartName();
  },
  computed: {
    importExcelUrl: function () {
      return `${window._CONFIG['domianURL']}/${this.url.importExcelUrl}`;
    },
  },
  methods: {
    ...mapGetters(["userInfo"]),
    getPcaText(code) {
      return this.pcaData.getText(code);
    },
    getDepartName() {
      httpAction("/shoes/shoeLocker/queryDepartName", null, "get").then((res) => {
        this.sysDepartVos = res.sysDepartVos
      })
    },
    initDictConfig() {
    },
    getSuperFieldList() {
      let fieldList = [];
      fieldList.push({type: 'int', value: 'lockerId', text: 'ID', dictCode: ''})
      fieldList.push({type: 'string', value: 'lockerCode', text: '机柜编码', dictCode: ''})
      fieldList.push({type: 'string', value: 'orgCode', text: '机构编码', dictCode: ''})
      fieldList.push({type: 'int', value: 'status', text: '状态:0=停用,1=启用', dictCode: ''})
      fieldList.push({type: 'BigDecimal', value: 'log', text: '经度', dictCode: ''})
      fieldList.push({type: 'BigDecimal', value: 'lat', text: '纬度', dictCode: ''})
      fieldList.push({type: 'string', value: 'address', text: '详细地址', dictCode: ''})
      fieldList.push({type: 'pca', value: 'province', text: '省'})
      fieldList.push({type: 'pca', value: 'city', text: '市'})
      fieldList.push({type: 'pca', value: 'area', text: '区/县'})
      fieldList.push({type: 'datetime', value: 'createTime', text: '添加时间'})
      fieldList.push({type: 'datetime', value: 'updateTime', text: '修改时间'})
      fieldList.push({type: 'int', value: 'num', text: '格子数', dictCode: ''})
      fieldList.push({type: 'int', value: 'free', text: '空闲格子数', dictCode: ''})
      this.superFieldList = fieldList
    },
    setPercentage(record) {
      this.$refs.setPercentage.show(record);

    },
  }
}
</script>
<style scoped>
@import '~@assets/less/common.less';
</style>