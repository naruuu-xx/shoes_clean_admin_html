<template>
  <a-card :bordered="false">
    <!-- 查询区域 -->
    <div class="table-page-search-wrapper">
      <a-form layout="inline" @keyup.enter.native="searchQuery">
        <a-row :gutter="24">
          <a-col :xl="4" :lg="7" :md="8" :sm="24">
            <a-form-item label="优惠券名称">
              <a-input placeholder="请输入名称" v-model="queryParam.name"></a-input>
            </a-form-item>
          </a-col>

          <a-col :xl="4" :lg="7" :md="8" :sm="24">
            <a-form-item label="发放方式">
              <a-select v-model="queryParam.way" >
                <a-select-option v-for="item in wayOptionList" :value="item.value" :key="item.value">
                  {{ item.name }}
                </a-select-option>
              </a-select>
            </a-form-item>
          </a-col>

          <a-col :xl="4" :lg="7" :md="8" :sm="24">
            <a-form-item label="用户类型">
              <a-select v-model="queryParam.obj">
                <a-select-option v-for="item in objOptionList" :value="item.value" :key="item.value">
                  {{ item.name }}
                </a-select-option>
              </a-select>
            </a-form-item>
          </a-col>

          <a-col :xl="4" :lg="7" :md="8" :sm="24">
            <a-form-item label="发放状态">
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
    <div class="table-operator">
      <a-button @click="handleAdd" type="primary" icon="plus">新增</a-button>
<!--      <a-button type="primary" icon="download" @click="handleExportXls('shoe_coupon')">导出</a-button>-->
<!--      <a-upload name="file" :showUploadList="false" :multiple="false" :headers="tokenHeader" :action="importExcelUrl" @change="handleImportExcel">-->
<!--        <a-button type="primary" icon="import">导入</a-button>-->
<!--      </a-upload>-->
      <!-- 高级查询区域 -->
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
      <div class="ant-alert ant-alert-info" style="margin-bottom: 16px;">
        <i class="anticon anticon-info-circle ant-alert-icon"></i> 已选择 <a style="font-weight: 600">{{ selectedRowKeys.length }}</a>项
        <a style="margin-left: 24px" @click="onClearSelected">清空</a>
      </div>

      <a-table
        ref="table"
        size="middle"
        :scroll="{x:true}"
        bordered
        rowKey="couponId"
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
          <img v-else :src="getImgView(text)" :preview="record.couponId" height="25px" alt="" style="max-width:80px;font-size: 12px;font-style: italic;"/>
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
          <a-divider type="vertical" />
          <a-popconfirm title="确定删除吗?" @confirm="() => handleDelete(record.couponId)">
            <a>删除</a>
          </a-popconfirm>
<!--          <a @click="handleEdit(record)">编辑</a>-->

<!--          <a-divider type="vertical" />-->
<!--          <a-dropdown>-->
<!--            <a class="ant-dropdown-link">更多 <a-icon type="down" /></a>-->
<!--            <a-menu slot="overlay">-->
<!--              <a-menu-item>-->
<!--                <a @click="handleDetail(record)">详情</a>-->
<!--              </a-menu-item>-->
<!--              <a-menu-item>-->
<!--                <a-popconfirm title="确定删除吗?" @confirm="() => handleDelete(record.couponId)">-->
<!--                  <a>删除</a>-->
<!--                </a-popconfirm>-->
<!--              </a-menu-item>-->
<!--            </a-menu>-->
<!--          </a-dropdown>-->
        </span>

      </a-table>
    </div>

    <shoe-coupon-modal ref="modalForm" @ok="modalFormOk"></shoe-coupon-modal>

    <shoe-coupon-edit ref="shoeCouponEdit" @ok="modalFormOk"></shoe-coupon-edit>

  </a-card>
</template>

<script>

  import '@/assets/less/TableExpand.less'
  import { mixinDevice } from '@/utils/mixin'
  import { JeecgListMixin } from '@/mixins/JeecgListMixin'
  import ShoeCouponModal from './modules/ShoeCouponModal'
  import {filterDictTextByCache} from "../../../components/dict/JDictSelectUtil";
  import ShoeCouponEdit from "./modules/ShoeCouponEdit";

  export default {
    name: 'ShoeCouponList',
    mixins:[JeecgListMixin, mixinDevice],
    components: {
      ShoeCouponModal,
      ShoeCouponEdit
    },
    data () {
      return {
        description: 'shoe_coupon管理页面',
        wayOptionList: [{"value":"", "name":"全部"}, {"value":"0", "name":"自行领取"}, {"value":"1", "name":"系统发放"}, {"value":"2", "name":"卡包"}],
        objOptionList: [{"value":"all", "name":"全部"}, {"value":"new", "name":"新用户"}, {"value":"old", "name":"老用户"}],
        statusOptionList: [{"value":"", "name":"全部"}, {"value":"0", "name":"停止发放"}, {"value":"1", "name":"正常发放"}],
        // 表头
        columns: [
          {
            title:'ID',
            align:"center",
            dataIndex: 'couponId'
          },
          {
            title:'优惠券名称',
            align:"center",
            dataIndex: 'name'
          },
          {
            title:'面额',
            align:"center",
            dataIndex: 'reduce'
          },
          {
            title:'使用门槛',
            align:"center",
            dataIndex: 'min',
            customRender: (text) => {
              let result = "";
              if (text < 1) {
                result = "无门槛";
              } else {
                result = text;
              }
              return result;
            }
          },
          {
            title:'适用商品配置',
            align:"center",
            dataIndex: 'rangeConfigText',
            customRender: (text) => {
              let result = text;
              if (result === null) {
                result = "通用";
              }
              return result;
            }
          },
          {
            title:'用户类型',
            align:"center",
            dataIndex: 'obj',
            customRender: (text) => {
              return filterDictTextByCache('shoe_coupon_obj', text);
            }
          },
          {
            title:'剩余数量',
            align:"center",
            dataIndex: 'remainNum',
            customRender: (text) => {
              let value = text;

              if (text < 0) {
                value = "不限量"
              }

              return value;
            }
          },
          {
            title:'领取人数',
            align:"center",
            dataIndex: 'receiveNum'
          },
          {
            title:'使用人数',
            align:"center",
            dataIndex: 'useNum'
          },
          {
            title:'创建人',
            align:"center",
            dataIndex: 'createName'
          },
          {
            title:'状态',
            align:"center",
            dataIndex: 'status',
            customRender: (text) => {
              let value = '';

              if (text == 0) {
                value = "停用"
              }else{
                value = "启用"
              }

              return value;
            }

          },
          // {
          //   title:'权重',
          //   align:"center",
          //   dataIndex: 'weight'
          // },
          {
            title: '操作',
            dataIndex: 'action',
            align:"center",
            fixed:"right",
            width:147,
            scopedSlots: { customRender: 'action' }
          }
        ],
        url: {
          list: "/ShoeCoupon/shoeCoupon/queryCouponList",
          delete: "/ShoeCoupon/shoeCoupon/delete",
          // deleteBatch: "/ShoeCoupon/shoeCoupon/deleteBatch",
          // exportXlsUrl: "/ShoeCoupon/shoeCoupon/exportXls",
          // importExcelUrl: "ShoeCoupon/shoeCoupon/importExcel",

        },
        dictOptions:{},
        superFieldList:[],
      }
    },
    created() {
    this.getSuperFieldList();
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
        fieldList.push({type:'int',value:'couponId',text:'优惠券id'})
        fieldList.push({type:'string',value:'name',text:'优惠券名称'})
        fieldList.push({type:'int',value:'type',text:'优惠券类型:1=满减'})
        fieldList.push({type:'int',value:'reduce',text:'满减-减免金额'})
        fieldList.push({type:'int',value:'min',text:'最低使用金额'})
        fieldList.push({type:'string',value:'obj',text:'适用对象:new=仅新用户,old=仅老用户,all=全部'})
        fieldList.push({type:'int',value:'way',text:'发放方式:0=自行领取，1=系统发放'})
        fieldList.push({type:'int',value:'expireType',text:'过期类型:1=领取后生效,2=固定时间'})
        fieldList.push({type:'int',value:'expireDay',text:'领取后生效-有效天数'})
        fieldList.push({type:'date',value:'startTime',text:'固定时间-开始时间'})
        fieldList.push({type:'date',value:'endTime',text:'固定时间-结束时间'})
        fieldList.push({type:'int',value:'range',text:'适用范围:1=通用,2=指定商品'})
        fieldList.push({type:'string',value:'rangeConfig',text:'适用商品配置'})
        fieldList.push({type:'int',value:'num',text:'发放数量（-1为不限）'})
        fieldList.push({type:'int',value:'receiveNum',text:'已领数量'})
        fieldList.push({type:'int',value:'useNum',text:'已使用数量'})
        fieldList.push({type:'int',value:'status',text:'状态:0=停止发放,1=正常发放'})
        fieldList.push({type:'string',value:'rules',text:'使用规则'})
        fieldList.push({type:'int',value:'weight',text:'权重'})
        fieldList.push({type:'string',value:'note',text:'备注'})
        fieldList.push({type:'date',value:'deleteTime',text:'删除时间'})
        fieldList.push({type:'string',value:'addUserId',text:'添加人id'})
        fieldList.push({type:'string',value:'editUserId',text:'最后修改人id（首次添加为添加人id）'})
        this.superFieldList = fieldList
      },
      handleEdit(record) {
        this.$refs.shoeCouponEdit.edit(record);
      }
    }
  }
</script>
<style scoped>
  @import '~@assets/less/common.less';
</style>