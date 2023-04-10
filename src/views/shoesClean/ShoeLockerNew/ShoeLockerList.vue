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
            <a-form-item label="机柜状态">
              <a-select v-model="queryParam.status">
                <a-select-option v-for="item in statusOptions" :value="item.value" :key="item.value">{{item.name}}</a-select-option>
              </a-select>
            </a-form-item>
          </a-col>
          <a-col :xl="3" :lg="7" :md="8" :sm="24">
            <a-form-item label="接单状态">
              <a-select v-model="queryParam.orderStatus">
                <a-select-option v-for="item in orderStatusOptions" :value="item.value" :key="item.value">{{item.name}}</a-select-option>
              </a-select>
            </a-form-item>
          </a-col>
          <a-col :xl="3" :lg="7" :md="8" :sm="24">
            <a-form-item label="在线状态">
              <a-select v-model="queryParam.onlineStatus">
                <a-select-option v-for="item in onlineStatusOptions" :value="item.value" :key="item.value">{{item.name}}</a-select-option>
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
    <div class="table-operator">
      <a-button @click="handleAdd" type="primary" icon="plus">新增</a-button>
    </div>

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
          <a @click="handleEdit(record)">编辑</a>
          <a-divider type="vertical"/>
          <a-dropdown>
            <a class="ant-dropdown-link">更多 <a-icon type="down"/></a>
              <a-menu slot="overlay">
                <a-menu-item>
                   <a @click="setPercentage(record)">机柜收益</a>
                </a-menu-item>
                <a-menu-item>
                   <a @click="handleGrid(record)">格子状态</a>
                </a-menu-item>
                <a-menu-item>
                   <a @click="sceneGraph(record)">位置图</a>
                </a-menu-item>
              </a-menu>
          </a-dropdown>

          <!--          <a-dropdown>-->
          <!--            <a class="ant-dropdown-link">更多 <a-icon type="down" /></a>-->
          <!--            <a-menu slot="overlay">-->
          <!--              <a-menu-item>-->
          <!--                <a @click="handleDetail(record)">详情</a>-->
          <!--              </a-menu-item>-->
          <!--              <a-menu-item>-->
          <!--                <a-popconfirm title="确定删除吗?" @confirm="() => handleDelete(record.id)">-->
          <!--                  <a>删除</a>-->
          <!--                </a-popconfirm>-->
          <!--              </a-menu-item>-->
          <!--            </a-menu>-->
          <!--          </a-dropdown>-->
        </span>

      </a-table>
    </div>

    <shoe-locker-modal ref="modalForm" @ok="modalFormOk"></shoe-locker-modal>
    <shoe-locker-grid-modal ref="gridModal"></shoe-locker-grid-modal>
    <set-percentage ref="setPercentage" @ok="modalFormOk"></set-percentage>
    <shoe-locker-img-modal ref="imgModal" @ok="modalFormOk"></shoe-locker-img-modal>
  </a-card>
</template>

<script>

import '@/assets/less/TableExpand.less'
import {mixinDevice} from '@/utils/mixin'
import {JeecgListMixin} from '@/mixins/JeecgListMixin'
import ShoeLockerModal from './modules/ShoeLockerModal'
import ShoeLockerImgModal from './modules/ShoeLockerImgModal'
import shoeLockerGridModal from './modules/shoeLockerGridModal'
import Area from '@/components/_util/Area'
import {filterDictTextByCache} from "@comp/dict/JDictSelectUtil";
import {httpAction} from "../../../api/manage";
import {mapGetters} from 'vuex';
import store from '@/store/'
import SetPercentage from "@views/shoesClean/shoeCourier/modules/SetPercentage";

export default {
  name: 'ShoeLockerList',
  mixins: [JeecgListMixin, mixinDevice],
  components: {
    ShoeLockerModal,
    shoeLockerGridModal,
    SetPercentage,
    ShoeLockerImgModal
  },
  data() {
    return {
      description: 'shoe_locker管理页面',
      // 表头
      columns: [
        {
          title: '机柜编码',
          align: "center",
          dataIndex: 'lockerCode'
        },
        {
          title: '机柜名称',
          align: "center",
          dataIndex: 'name'
        },
        {
          title: '区域',
          align: "center",
          dataIndex: 'departName'
        },
        {
          title: '格子数',
          align: "center",
          dataIndex: 'num'
        },
        {
          title: '可用格子数',
          align: "center",
          dataIndex: 'free'
        },
        {
          title: '待付款',
          align: "center",
          dataIndex: 'waitPay'
        },
        {
          title: '配送员待存',
          align: "center",
          dataIndex: 'courierWaitIn'
        },
        {
          title: '用户待存',
          align: "center",
          dataIndex: 'userWaitIn'
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
          title: '用户待取',
          align: "center",
          dataIndex: 'userWaitGet'
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
            return orderMoneyTotal;
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
          title: '机柜状态',
          align: "center",
          dataIndex: 'status',
          customRender: (text) => {
            return filterDictTextByCache('shoe_locker_status', text);
          },
        },
        {
          title: '在线状态',
          align: "center",
          dataIndex: 'onlineStatus',
          customRender: (text) => {
            return filterDictTextByCache('shoe_locker_online_status', text);
          },
        },
        {
          title: '权重',
          align: "center",
          dataIndex: 'weight'
        },
        {
          title:'接单状态',
          align:"center",
          dataIndex: 'orderStatus',
          customRender: (text) => {
            return filterDictTextByCache('shoe_locker_order_status', text);
          },
        },
        // {
        //   title:'添加时间',
        //   align:"center",
        //   dataIndex: 'createTime'
        // },
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
        list: "/shoes/shoeLocker/queryListNew",
        delete: "/shoes/shoeLocker/delete",
        deleteBatch: "/shoes/shoeLocker/deleteBatch",
        exportXlsUrl: "/shoes/shoeLocker/exportXls",
        importExcelUrl: "shoes/shoeLocker/importExcel",

      },
      dictOptions: {},
      pcaData: '',
      superFieldList: [],
      statusOptions: [{"value":"", "name":"全部"}, {"value":"1", "name":"启用"}, {"value":"0", "name":"停用"}],
      orderStatusOptions: [{"value":"", "name":"全部"}, {"value":"1", "name":"正常接单"}, {"value":"0", "name":"停止接单"}],
      onlineStatusOptions: [{"value":"", "name":"全部"}, {"value":"1", "name":"在线"}, {"value":"0", "name":"离线"}],
    }
  },
  created() {
    this.pcaData = new Area()
    this.getSuperFieldList();
    console.log(this.userInfo());
  },
  computed: {
    importExcelUrl: function () {
      return `${window._CONFIG['domianURL']}/${this.url.importExcelUrl}`;
    },
  },
  //==================================================================================================================
  // mounted() {
  //   //初始化websocket
  //   this.initWebSocket()
  // },
  // destroyed: function () { // 离开页面生命周期函数
  //   this.websocketclose();
  // },
  //==================================================================================================================
  methods: {
    ...mapGetters(["userInfo"]),
    getPcaText(code) {
      return this.pcaData.getText(code);
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
    handleGrid(record) {
      this.$refs.gridModal.show(record);
    },
    sceneGraph(record) {
      this.$refs.imgModal.show(record);
    },
    setPercentage(record) {
      this.$refs.setPercentage.show(record);

    },
    //================================================================================================================
    // initWebSocket: function () {
    //   // WebSocket与普通的请求所用协议有所不同，ws等同于http，wss等同于https
    //   var userId = store.getters.userInfo.id;
    //   let token = store.getters.token.toString();
    //   var url = window._CONFIG['domianURL'].replace("https://","ws://").replace("http://","ws://")+"/websocket/"+userId;
    //   this.websock = new WebSocket(url,[token]);
    //   this.websock.onopen = this.websocketonopen;
    //   this.websock.onerror = this.websocketonerror;
    //   this.websock.onmessage = this.websocketonmessage;
    //   this.websock.onclose = this.websocketclose;
    // },
    // websocketonopen: function () {
    //   console.log("WebSocket连接成功");
    // },
    // websocketonerror: function (e) {
    //   console.log("WebSocket连接发生错误");
    // },
    // websocketonmessage: function (e) {
    //   var data = eval("(" + e.data + ")");
    //   //处理订阅信息
    //   if(data.cmd == "topic"){
    //     //TODO 系统通知
    //
    //   }else if(data.cmd == "user"){
    //     //TODO 用户消息
    //     console.log(data.msgTxt);
    //   }
    // },
    // websocketclose: function (e) {
    //   console.log(e);
    //   console.log("connection closed (" + e.code + ")");
    // }
    //================================================================================================================
  }
}
</script>
<style scoped>
@import '~@assets/less/common.less';
</style>