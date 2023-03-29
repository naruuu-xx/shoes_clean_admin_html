<template>
  <a-card :bordered="false">
    <!-- 查询区域 -->
    <div class="table-page-search-wrapper">
      <a-form layout="inline" @keyup.enter.native="searchQuery">
        <a-row :gutter="24">
          <a-col :xl="6" :lg="7" :md="8" :sm="24">
            <a-form-item label="用户昵称">
              <a-input placeholder="请输入用户昵称" v-model="queryParam.name"></a-input>
            </a-form-item>
          </a-col>
          <a-col :xl="6" :lg="7" :md="8" :sm="24">
            <a-form-item label="手机号">
              <a-input placeholder="请输入手机号" v-model="queryParam.phone"></a-input>
            </a-form-item>
          </a-col>
          <a-col :xl="6" :lg="7" :md="8" :sm="24">
            <a-form-item label="发放批次">
              <a-input placeholder="请输入发放批次" v-model="queryParam.recordNo"></a-input>
            </a-form-item>
          </a-col>
          <a-col :xl="6" :lg="7" :md="8" :sm="24">
            <a-form-item label="使用情况">
              <a-select v-model="queryParam.useStatus" style="width: 180px">
                <a-select-option v-for="item in useStatusOptionList" :value="item.value" :key="item.value">
                  {{ item.name }}
                </a-select-option>
              </a-select>
            </a-form-item>
          </a-col>
          <a-col :xl="6" :lg="7" :md="8" :sm="24">
            <a-form-item label="是否停用">
              <a-select v-model="queryParam.status" style="width: 180px">
                <a-select-option v-for="item in statusOptionList" :value="item.value" :key="item.value">
                  {{ item.name }}
                </a-select-option>
              </a-select>
            </a-form-item>
          </a-col>
          <template >
            <a-col :xl="6" :lg="7" :md="8" :sm="24">
              <a-form-item label="派发时间">
                <j-date placeholder="请选择开始日期" class="query-group-cust" v-model="queryParam.createTimeBegin"></j-date>
                <span class="query-group-split-cust"></span>
                <j-date placeholder="请选择结束日期" class="query-group-cust" v-model="queryParam.createTimeEnd"></j-date>
              </a-form-item>
            </a-col>
          </template>
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
<!--    <div class="table-operator">-->
<!--      <a-button @click="handleAdd" type="primary" icon="plus">新增</a-button>-->
<!--      <a-button type="primary" icon="download" @click="handleExportXls('shoe_coupon_record')">导出</a-button>-->
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
<!--    </div>-->

    <!-- table区域-begin -->
    <div>
      <div class="ant-alert ant-alert-info" style="margin-bottom: 16px;">
        <i class="anticon anticon-info-circle ant-alert-icon"></i> 已选择 <a style="font-weight: 600">{{ selectedRowKeys.length }}</a>项
        <a style="margin-left: 24px" @click="onClearSelected2">批量停用</a>
        <a-divider type="vertical" />
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


        <span slot="action" slot-scope="text, record">


              <a-menu-item v-if="record.status=='1' && record.useStatus != '已使用'">
                <a-popconfirm title="确定停用吗?" @confirm="() => handleDelete(record.shoeCouponRecordId)">
                  <a>停用</a>
                </a-popconfirm>
              </a-menu-item>
                  <a v-if="record.status=='0'" style="color: black" >已停用</a>



        </span>

      </a-table>
    </div>

    <shoe-coupon-record-modal ref="modalForm" @ok="modalFormOk"></shoe-coupon-record-modal>
  </a-card>
</template>

<script>

  import '@/assets/less/TableExpand.less'
  import { mixinDevice } from '@/utils/mixin'
  import { JeecgListMixin } from '@/mixins/JeecgListMixin'
  import ShoeCouponRecordModal from './modules/ShoeCouponRecordModal'
  import {deleteAction} from "@api/manage";

  export default {
    name: 'ShoeCouponRecordList',
    mixins:[JeecgListMixin, mixinDevice],
    components: {
      ShoeCouponRecordModal
    },
    data () {
      return {
        useStatusOptionList: [{"value":"", "name":"全部"}, {"value":"已使用", "name":"已使用"}, {"value":"未使用", "name":"未使用"}, {"value":"已过期", "name":"已过期"}],
        statusOptionList: [{"value":"", "name":"全部"}, {"value":"0", "name":"是"}, {"value":"1", "name":"否"}],
        description: 'shoe_coupon_record管理页面',
        // 表头
        columns: [
          // {
          //   title: '#',
          //   dataIndex: '',
          //   key:'rowIndex',
          //   width:60,
          //   align:"center",
          //   customRender:function (t,r,index) {
          //     return parseInt(index)+1;
          //   }
          // },

          {
            title:'用户昵称',
            align:"center",
            dataIndex: 'nickName'
          },
          {
            title:'手机号',
            align:"center",
            dataIndex: 'phone'
          },
          {
            title:'优惠券名称',
            align:"center",
            dataIndex: 'couponName'
          },
          {
            title:'发放批次',
            align:"center",
            dataIndex: 'recordNo'
          },
          {
            title:'使用情况',
            align:"center",
            dataIndex: 'useStatus'
          },
          {
            title:'派发人',
            align:"center",
            dataIndex: 'grantUsername'
          },
          {
            title:'派发时间',
            align:"center",
            dataIndex: 'grantTime'
          },
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
          list: "/shoeCouponRecord/list",
          delete: "/shoeCouponRecord/delete",
          deleteBatch: "/shoeCouponRecord/deleteBatch",
        },
        dictOptions:{},
        superFieldList:[],
        selectionRows: [],
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
      onClearSelected2(){
        if (this.selectedRowKeys.length <= 0) {
          this.$message.warning('请选择一条记录！');
          return;
        } else {
          var ids = "";
          console.log(this.selectedRowKeys);
          for (var a = 0; a < this.selectedRowKeys.length; a++) {
            ids += this.selectionRows[a].shoeCouponRecordId + ",";
          }
          var that = this;
          this.$confirm({
            title: "确认停用",
            content: "是否停用选中数据?",
            onOk: function () {
              that.loading = true;
              deleteAction(that.url.deleteBatch, {ids: ids}).then((res) => {
                if (res.success) {
                  //重新计算分页问题
                  that.reCalculatePage(that.selectedRowKeys.length)
                  that.$message.success(res.message);
                  that.loadData();
                  that.onClearSelected();
                } else {
                  that.$message.warning(res.message);
                }
              }).finally(() => {
                that.loading = false;
              });
            }
          });
        }
      },
      initDictConfig(){
      },
      getSuperFieldList(){
        let fieldList=[];
        fieldList.push({type:'int',value:'couponRecordId',text:'优惠券发放记录ID',dictCode:''})
        fieldList.push({type:'int',value:'couponId',text:'优惠券id',dictCode:''})
        fieldList.push({type:'int',value:'userId',text:'用户id',dictCode:''})
        fieldList.push({type:'int',value:'userCouponId',text:'用户优惠券id',dictCode:''})
        fieldList.push({type:'int',value:'recordNo',text:'发放批次(从1递增)',dictCode:''})
        fieldList.push({type:'int',value:'status',text:'状态:0=冻结，1=正常',dictCode:''})
        fieldList.push({type:'string',value:'grantUserId',text:'派发人id',dictCode:''})
        fieldList.push({type:'string',value:'grantUsername',text:'派发人姓名',dictCode:''})
        fieldList.push({type:'string',value:'repealUserId',text:'撤销人id',dictCode:''})
        fieldList.push({type:'string',value:'repealUsername',text:'撤销人姓名',dictCode:''})
        fieldList.push({type:'int',value:'grantType',text:'派发方式:1=手动派发，2=系统派发',dictCode:''})
        fieldList.push({type:'date',value:'grantTime',text:'派发时间'})
        fieldList.push({type:'date',value:'repealTime',text:'撤销时间'})
        this.superFieldList = fieldList
      }
    }
  }
</script>
<style scoped>
  @import '~@assets/less/common.less';
</style>