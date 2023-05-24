<template>
  <a-card :bordered="false">
    <!-- 查询区域 -->
    <div class="table-page-search-wrapper">
      <a-form layout="inline" @keyup.enter.native="searchQuery">
        <a-row :gutter="24">
          <a-col :xl="4" :lg="7" :md="8" :sm="24">
            <a-form-item label=" 用户昵称">
              <a-input placeholder="请输入用户昵称" v-model="queryParam.nickname" :allowClear="true"></a-input>
            </a-form-item>
          </a-col>
          <a-col :xl="4" :lg="7" :md="8" :sm="24">
            <a-form-item label=" 手机号">
              <a-input placeholder="请输入手机号" v-model="queryParam.phone" :allowClear="true"></a-input>
            </a-form-item>
          </a-col>
          <a-col :xl="4" :lg="7" :md="8" :sm="24">
            <a-form-item label="所在地区">
              <a-input placeholder="请输入所在地区" v-model="queryParam.location" :allowClear="true"></a-input>
            </a-form-item>
          </a-col>
          <a-col :xl="3" :lg="7" :md="8" :sm="24">
            <a-form-item label="性别">
              <a-select v-model="queryParam.sex">
                <a-select-option v-for="item in sexOptionList" :value="item.value" :key="item.value">
                  {{ item.name }}
                </a-select-option>
              </a-select>
            </a-form-item>
          </a-col>
          <a-col :xl="6" :lg="7" :md="8" :sm="24">
            <a-form-item label="注册时间">
              <a-range-picker v-model="createTime"/>
            </a-form-item>
          </a-col>

          <a-col :xl="5" :lg="7" :md="8" :sm="24">
            <a-form-item label="生日">
              <j-date placeholder="请选择生日" v-model="queryParam.birthday"></j-date>
            </a-form-item>
          </a-col>

          <a-col :xl="5" :lg="6" :md="8" :sm="24">
            <a-form-item label="是否关注公众号">
              <a-select v-model="queryParam.isSubscribe">
                <a-select-option v-for="item in isSubscribeOptionList" :value="item.value" :key="item.value">
                  {{ item.name }}
                </a-select-option>
              </a-select>
            </a-form-item>
          </a-col>
          <a-col :xl="6" :lg="7" :md="8" :sm="24">
            <a-form-model-item label="渠道来源">
              <xf-select
                style="width: 100%"
                :list="weekList"
                @changeList="changeSelect"
                @change="checkedSelect"
                v-model="queryParam.promotionId"
                :url='`/shoes/shoePromotion/list`'
              >
              </xf-select>
            </a-form-model-item>
          </a-col>
          <a-col :xl="6" :lg="7" :md="8" :sm="24">
            <span style="float: left;overflow: hidden;" class="table-page-search-submitButtons">
              <a-button type="primary" @click="searchQuery" icon="search">查询</a-button>
              <a-button type="primary" @click="searchReset2" icon="reload" style="margin-left: 8px">重置</a-button>
            </span>
          </a-col>
        </a-row>
      </a-form>
    </div>
    <!-- 查询区域-END -->

    <!-- 操作按钮区域 -->
    <div class="table-operator">
      <a-button @click="manualDistribute" type="primary" v-has="'user:handCoupon'">手动派发</a-button>
      <!--      <a-button type="primary" icon="download" @click="handleExportXls('shoe_user')">导出</a-button>-->
      <!--      <a-upload name="file" :showUploadList="false" :multiple="false" :headers="tokenHeader" :action="importExcelUrl" @change="handleImportExcel">-->
      <!--        <a-button type="primary" icon="import">导入</a-button>-->
      <!--      </a-upload>-->
      <!--      &lt;!&ndash; 高级查询区域 &ndash;&gt;-->
      <!--      <j-super-query :fieldList="superFieldList" ref="superQueryModal" @handleSuperQuery="handleSuperQuery"></j-super-query>-->
      <!--      <a-dropdown v-if="selectedRowKeys.length > 0">-->
      <!--        <a-menu slot="overlay">-->
      <!--          <a-menu-item key="1" @click="batchDel"><a-icon type="delete"/>删除</a-menu-item>-->
      <!--        </a-menu>-->
      <!--        <a-button style="margin-left: 8px"> 批量操作 <a-icon type="down" /></a-button>-->
      <!--      </a-dropdown>-->
    </div>

    <!-- table区域-begin -->
    <div>
      <!--      <div class="ant-alert ant-alert-info" style="margin-bottom: 16px;">-->
      <!--        <i class="anticon anticon-info-circle ant-alert-icon"></i> 已选择 <a style="font-weight: 600">{{ selectedRowKeys.length }}</a>项-->
      <!--        <a style="margin-left: 24px" @click="onClearSelected">清空</a>-->
      <!--      </div>-->

      <!--     TODO： 正式版发布时切记将 rowSelection 删去 -->
      <a-table
        ref="table"
        size="middle"
        :scroll="{x:true}"
        bordered
        rowKey="userId"
        :columns="columns"
        :dataSource="dataSource"
        :pagination="ipagination"
        :loading="loading"
        class="j-table-force-nowrap"
        @change="handleTableChange">

        <template slot="htmlSlot" slot-scope="text">
          <div v-html="text"></div>
        </template>
        <template slot="imgSlot" slot-scope="text,record">
          <span v-if="!text" style="font-size: 12px;font-style: italic;">无图片</span>
          <img v-else :src="getImgView(text)" :preview="record.userId" height="25px" alt=""
               style="max-width:80px;font-size: 12px;font-style: italic;"/>
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
          <a @click="handleDistribute(record)" v-has="'user:coupon'">派发</a>

          <a-divider type="vertical" v-has="'user:more'"/>
          <a-dropdown>
            <a class="ant-dropdown-link" v-has="'user:more'">更多 <a-icon type="down"/></a>
            <a-menu slot="overlay">
              <a-menu-item>
                <a @click="getCouponDetail(record)" v-has="'user:couponList'">优惠券列表</a>
              </a-menu-item>
                            <a-menu-item>
                              <a @click="getTimecardDetail(record)" v-has="'user:timecardList'">鞋蜂卡列表</a>
                            </a-menu-item>
            </a-menu>
            <!--            <a-menu slot="overlay">-->
            <!--              <a-menu-item>-->
            <!--                <a @click="getTimecardDetail(record)" v-has="'user:timecardList'">鞋蜂卡列表</a>-->
            <!--              </a-menu-item>-->
            <!--            </a-menu>-->
          </a-dropdown>
        </span>

      </a-table>
    </div>

    <shoe-user-modal ref="modalForm" @ok="modalFormOk"></shoe-user-modal>

    <distribute-coupon-modal ref="distributeCouponModal" @ok="modalFormOk"></distribute-coupon-modal>

    <manual-distribute-coupon-modal ref="manualDistributeCouponModal"
                                    @submit="manualSubmit"></manual-distribute-coupon-modal>

    <coupon-list ref="couponList"></coupon-list>
    <timecard-list ref="timecardList"></timecard-list>
  </a-card>
</template>

<script>

import '@assets/less/TableExpand.less'
import {mixinDevice} from '@/utils/mixin'
import {JeecgListMixin} from '@/mixins/JeecgListMixin'
import ShoeUserModal from './modules/ShoeUserModal'
import DistributeCouponModal from "./modules/DistributeCouponModal";
import ManualDistributeCouponModal from "./modules/ManualDistributeCouponModal";
import couponList from "@views/shoesClean/ShoeUser/modules/couponList";
import timecardList from '@views/shoesClean/ShoeUser/modules/timecardList'
import {httpAction} from "@api/manage";
import XfSelect from "@comp/Xf/XfSelect";
import {filterDictTextByCache} from "@comp/dict/JDictSelectUtil";
import moment from "moment/moment";

export default {
  name: 'ShoeUserList',
  mixins: [JeecgListMixin, mixinDevice],
  components: {
    ShoeUserModal,
    couponList,
    timecardList,
    DistributeCouponModal,
    ManualDistributeCouponModal,
    XfSelect
  },
  data() {
    return {
      createTime:'',
      queryParam: {
        promotionId: "",
        createTimeLeft: '',
        createTimeRight: '',
      },
      description: 'shoe_user管理页面',
      // 表头
      columns: [
        {
          title: 'ID',
          align: "center",
          dataIndex: 'userId'
        },
        {
          title: '用户昵称',
          align: "center",
          dataIndex: 'nickname'
        },
        {
          title: '头像',
          align: "center",
          dataIndex: 'avatar',
          scopedSlots: {customRender: 'imgSlot'}
        },
        {
          title: '手机号码',
          align: "center",
          dataIndex: 'phone'
        },

        {
          title: '用户来源',
          align: "center",
          dataIndex: 'source'
        },
        {
          title: '渠道',
          align: "center",
          dataIndex: 'channel'
        },
        {
          title: '推荐人',
          align: "center",
          dataIndex: 'referrer'
        },
        {
          title: '推广人',
          align: "center",
          dataIndex: 'distributorName'
        },
        {
          title: '注册时间',
          align: "center",
          dataIndex: 'createTime'
        },
        {
          title: '性别',
          align: "center",
          dataIndex: 'sex',
          customRender: (text) => {
            if (text == 1) {
              text = '男'
            } else if (text == 2) {
              text = '女'
            } else if (text == 0){
              text = '未知'
            }
            return text;
          },
        },
        {
          title: '生日',
          align: "center",
          dataIndex: 'birthday'
        },
        {
          title: '所在地区',
          align: "center",
          dataIndex: 'location'
        },
        {
          title: '是否关注公众号',
          align: "center",
          dataIndex: 'isSubscribe',
          customRender: (text) => {
            if (text == 1) {
              text = '已关注'
            } else if (text == 0) {
              text = '未关注'
            }
            return text;
          },
        },
        {
          title: '总消费金额',
          align: "center",
          dataIndex: 'actualAmount'
        },
        {
          title: '最近登录时间',
          align: "center",
          dataIndex: 'lastLoginTime',

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
        list: "/shoes/shoeUser/list",
        delete: "/shoes/shoeUser/delete",
        deleteBatch: "/shoes/shoeUser/deleteBatch",
        exportXlsUrl: "/shoes/shoeUser/exportXls",
        importExcelUrl: "shoes/shoeUser/importExcel",

      },
      dictOptions: {},
      superFieldList: [],
      weekList: [],
      sexOptionList: [
        {"value": "", "name": "全部"}, {"value": "0", "name": "未知"}, {"value": "1", "name": "男"},
        {"value": "2", "name": "女"}
      ],
      isSubscribeOptionList: [
        {"value": "", "name": "全部"}, {"value": "0", "name": "未关注"}, {"value": "1", "name": "已关注"},
      ],

    }
  },
  created() {
    this.getSuperFieldList();
  },
  watch: {
    'createTime': {
      handler(newV) {
        if (newV.length) {
          this.queryParam.createTimeLeft = moment(newV[0]).format('YYYY-MM-DD')
          this.queryParam.createTimeRight = moment(newV[1]).format('YYYY-MM-DD')

        } else {
          this.queryParam.createTimeLeft = ""
          this.queryParam.createTimeRight = ""
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
    changeSelect(data) {
      this.weekList = data.records.map(item => ({
        label: item.channel,
        value: +item.promotionId
      }));
      this.weekList.unshift({
        label: '全部',
        value:''
      })
    },
    searchReset2(){
      this.createTime='';
      this.searchReset();
    },
    checkedSelect(val) {
    },
    // 手动派券提交
    manualSubmit(data) {
      this.$refs.distributeCouponModal.show({}, data);
    },
    initDictConfig() {
    },
    getCouponDetail(record) {
      this.$refs.couponList.show(record);
    },
    getTimecardDetail(record) {
      this.$refs.timecardList.show(record);
    },
    getSuperFieldList() {
      let fieldList = [];
      fieldList.push({type: 'string', value: 'openId', text: '小程序open_id'})
      fieldList.push({type: 'string', value: 'pId', text: '推荐人用户id'})
      fieldList.push({type: 'string', value: 'nickname', text: '微信昵称'})
      fieldList.push({type: 'string', value: 'avatar', text: '头像'})
      fieldList.push({type: 'string', value: 'phone', text: '手机号码'})
      fieldList.push({type: 'string', value: 'payAmount', text: '总支付金额'})
      fieldList.push({type: 'string', value: 'actualAmount', text: '实际消费金额'})
      fieldList.push({type: 'date', value: 'lastLoginTime', text: '最近登录时间'})
      this.superFieldList = fieldList
    },
    handleDistribute(record) {
      this.$refs.distributeCouponModal.show(record);
    },
    manualDistribute(record) {
      this.$refs.manualDistributeCouponModal.show(record);
    }
  }
}
</script>
<style scoped>
@import '~@assets/less/common.less';
</style>