<template>
  <a-card :bordered="false">
    <!-- 查询区域 -->
    <div class="table-page-search-wrapper">
      <a-form layout="inline" @keyup.enter.native="searchQuery">
        <a-row :gutter="24">
          <a-col :xl="4" :lg="7" :md="8" :sm="24">
            <a-form-item label="机柜编码">
              <a-input placeholder="请输入机柜编码" v-model="queryParam.lockerCode" autocomplete="off"></a-input>
            </a-form-item>
          </a-col>
          <a-col :xl="4" :lg="7" :md="8" :sm="24">
            <a-form-item label="机柜名称">
              <a-input placeholder="请输入机柜名称" v-model="queryParam.name" autocomplete="off"></a-input>
            </a-form-item>
          </a-col>
          <a-col :xl="3" :lg="7" :md="8" :sm="24">
            <a-form-item label="区域">
              <a-select v-model="queryParam.orgCode">
                <a-select-option v-for="item in areaList" :value="item.orgCode.toString()" :key="item.orgCode.toString()" >{{ item.departName }}</a-select-option>
              </a-select>
            </a-form-item>
          </a-col>
          <a-col :xl="3" :lg="7" :md="8" :sm="24">
            <a-form-item label="状态">
              <a-select v-model="queryParam.status">
                <a-select-option v-for="item in statusList" :value="item.value" :key="item.value" >{{ item.name }}</a-select-option>
              </a-select>
            </a-form-item>
          </a-col>
          <a-col :xl="6" :lg="7" :md="8" :sm="24">
            <a-form-item label="订单时间">
              <a-range-picker v-model="queryParam.orderTime"/>
            </a-form-item>
          </a-col>
          <a-col :xl="4" :lg="7" :md="8" :sm="24">
            <span style="float: left;overflow: hidden;" class="table-page-search-submitButtons">
              <a-button type="primary" @click="searchQuery" icon="search">查询</a-button>
              <a-button type="primary" @click="searchReset" icon="reload" style="margin-left: 8px">重置</a-button>
            </span>
          </a-col>
        </a-row>
      </a-form>
    </div>
    <!-- 查询区域-END -->

    <!-- table区域-begin -->
    <div>
      <div class="ant-alert ant-alert-info" style="margin-bottom: 16px;">
        <i class="anticon anticon-info-circle ant-alert-icon"></i> 已选择 <a
        style="font-weight: 600">{{ selectedRowKeys.length }}</a>项
        <a style="margin-left: 24px" @click="onClearSelected">清空</a>
      </div>

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
      </a-table>
    </div>

  </a-card>
</template>

<script>

import '@/assets/less/TableExpand.less'
import {mixinDevice} from '@/utils/mixin'
import {JeecgListMixin} from '@/mixins/JeecgListMixin'
import Area from '@/components/_util/Area'
import {filterDictTextByCache} from "@comp/dict/JDictSelectUtil";
import {httpAction} from "../../../api/manage";
import {mapGetters} from 'vuex';
import store from '@/store/'
import moment from "moment";

export default {
  name: 'ShoeLockerList',
  mixins: [JeecgListMixin, mixinDevice],
  components: {
  },
  data() {
    return {
      description: 'shoe_locker管理页面',
      // 表头
      columns: [
        {
          title:'ID',
          align:"center",
          dataIndex: 'id'
        },
        {
          title: '机柜编号',
          align: "center",
          dataIndex: 'code'
        },
        {
          title: '机柜名称',
          align: "center",
          dataIndex: 'name'
        },
        {
          title: '区域',
          align: "center",
          dataIndex: 'area'
        },
        {
          title: '订单数',
          align: "center",
          dataIndex: 'num',
        },
        {
          title: '订单总额',
          align: "center",
          dataIndex: 'amount'
        },
        {
          title: '状态',
          align: "center",
          dataIndex: 'status',
          customRender: (text) => {
            return filterDictTextByCache('shoe_locker_status', text);
          },
        },
        {
          title: '投资人',
          align: "center",
          dataIndex: 'investor',
          customRender: (text) => {
            return text == null ? '——' : text;
          },
        }
      ],
      url: {
        list: "/locker",

      },
      dictOptions: {},
      pcaData: '',
      superFieldList: [],
      areaList: [],
      statusList: [{"value": "", "name":"全部"}, {"value": "1", "name":"启用"}, {"value": "0", "name":"停用"}, ],
      queryParam: {
        orderTime: [],
        startTime: '',
        endTime: '',
      },
    }
  },
  created() {
    this.pcaData = new Area()
    this.getSuperFieldList();
    this.getAreaList();
  },
  watch: {
    'queryParam.orderTime': {
      handler(newV) {
        if (newV.length) {
          this.queryParam.startTime = moment(newV[0]).format('YYYY-MM-DD')
          this.queryParam.endTime = moment(newV[1]).format('YYYY-MM-DD')
        } else {
          this.queryParam.startTime = ""
          this.queryParam.endTime = ""
        }
      },
      // immediate: true
    },
  },
  computed: {
    importExcelUrl: function () {
      return `${window._CONFIG['domianURL']}/${this.url.importExcelUrl}`;
    },
  },
  methods: {
    ...mapGetters(["userInfo"]),
    getSuperFieldList() {
      let fieldList = [];
      fieldList.push({type: 'int', value: 'id', text: 'ID', dictCode: ''})
      fieldList.push({type: 'string', value: 'code', text: '机柜编码', dictCode: ''})
      fieldList.push({type: 'string', value: 'name', text: '机柜名称', dictCode: ''})
      fieldList.push({type: 'string', value: 'area', text: '区域', dictCode: ''})
      fieldList.push({type: 'string', value: 'num', text: '订单数', dictCode: ''})
      fieldList.push({type: 'string', value: 'amount', text: '订单总额', dictCode: ''})
      fieldList.push({type: 'string', value: 'investor', text: '投资人', dictCode: ''})
      fieldList.push({type: 'string', value: 'startTime', text: '开始时间', dictCode: ''})
      fieldList.push({type: 'string', value: 'endTime', text: '结束时间', dictCode: ''})
      this.superFieldList = fieldList
    },
    getPcaText(code) {
      return this.pcaData.getText(code);
    },
    initDictConfig() {
    },
    getAreaList() {
      httpAction('/shoes/shoeLocker/getAreaList', null, 'get').then((res) => {
        let areaList = res.result

        this.areaList = areaList
      })
    },
  }
}
</script>
<style scoped>
@import '~@assets/less/common.less';
</style>