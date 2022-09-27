<template>
  <a-modal v-model:visible="scheduleVisible" title="配送员排班" :footer="null" width="500">
    <!-- 查询区域 -->
<!--    <div class="table-page-search-wrapper">-->
<!--      <a-form layout="inline" @keyup.enter.native="searchQuery">-->
<!--        <a-row :gutter="24">-->
<!--          <a-col :xl="6" :lg="7" :md="8" :sm="24">-->
<!--            <a-form-item label=" 星期几">-->
<!--              <a-input placeholder="请输入 星期几" v-model="queryParam.week"></a-input>-->
<!--            </a-form-item>-->
<!--          </a-col>-->
<!--          <a-col :xl="6" :lg="7" :md="8" :sm="24">-->
<!--            <a-form-item label=" 开始时间">-->
<!--              <a-input placeholder="请输入 开始时间" v-model="queryParam.startTime"></a-input>-->
<!--            </a-form-item>-->
<!--          </a-col>-->
<!--          <a-col :xl="6" :lg="7" :md="8" :sm="24">-->
<!--            <a-form-item label=" 结束时间">-->
<!--              <a-input placeholder="请输入 结束时间" v-model="queryParam.endTime"></a-input>-->
<!--            </a-form-item>-->
<!--          </a-col>-->
<!--          <template v-if="toggleSearchStatus">-->

<!--          </template>-->
<!--          <a-col :xl="6" :lg="7" :md="8" :sm="24">-->
<!--            <span style="float: left;overflow: hidden;" class="table-page-search-submitButtons">-->
<!--              <a-button type="primary" @click="searchQuery" icon="search">查询</a-button>-->
<!--              <a-button type="primary" @click="searchReset" icon="reload" style="margin-left: 8px">重置</a-button>-->
<!--            </span>-->
<!--          </a-col>-->
<!--        </a-row>-->
<!--      </a-form>-->
<!--    </div>-->
    <!-- 查询区域-END -->

    <!-- 操作按钮区域 -->
    <div class="table-operator">
      <a-button @click="handleAddByDIY" type="primary" icon="plus">新增</a-button>
<!--      <a-button type="primary" icon="download" @click="handleExportXls('shoe_schedule')">导出</a-button>-->
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
        rowKey="scheduleId"
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
          <img v-else :src="getImgView(text)" :preview="record.id" height="25px" alt="" style="max-width:80px;font-size: 12px;font-style: italic;"/>
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
          <a @click="handleEditByDIY(record)">编辑</a>

          <a-divider type="vertical" />

          <a-popconfirm title="确定删除吗?" @confirm="() => handleDeleteByDIY(record.scheduleId)">
            <a>删除</a>
          </a-popconfirm>

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

    <shoe-schedule-modal ref="modalForm" @ok="modalFormOkByDIY"></shoe-schedule-modal>
  </a-modal>
</template>

<script>

  import '@/assets/less/TableExpand.less'
  import { mixinDevice } from '@/utils/mixin'
  import { JeecgListMixin } from '@/mixins/JeecgListMixin'
  import ShoeScheduleModal from './modules/ShoeScheduleModal'
  import {deleteAction, getAction} from "../../../../api/manage";
  import {filterDictTextByCache} from "../../../../components/dict/JDictSelectUtil";

  export default {
    name: 'ShoeScheduleList',
    mixins:[JeecgListMixin, mixinDevice],
    components: {
      ShoeScheduleModal
    },
    data () {
      return {
        description: 'shoe_schedule管理页面',
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
          // {
          //   title:' ID',
          //   align:"center",
          //   dataIndex: 'scheduleId'
          // },
          // {
          //   title:' 配送员ID',
          //   align:"center",
          //   dataIndex: 'courierId'
          // },
          {
            title:' 配送员名字',
            align:"center",
            dataIndex: 'name'
          },
          {
            title:' 星期',
            align:"center",
            dataIndex: 'week',
            customRender: (text) => {
              return filterDictTextByCache('shoe_schedule_week', text);
            }
          },
          {
            title:' 开始时间',
            align:"center",
            dataIndex: 'startTime'
          },
          {
            title:' 结束时间',
            align:"center",
            dataIndex: 'endTime'
          },
          // {
          //   title:' 状态',
          //   align:"center",
          //   dataIndex: 'status',
          //   customRender: (text) => {
          //     return filterDictTextByCache('shoe_schedule_status', text);
          //   }
          // },
          // {
          //   title:' 创建时间',
          //   align:"center",
          //   dataIndex: 'createTime'
          // },
          // {
          //   title:' 更新时间',
          //   align:"center",
          //   dataIndex: 'updateTime'
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
          list: "/shoeSchedule/shoeSchedule/queryList",
          delete: "/shoeSchedule/shoeSchedule/delete",
          deleteBatch: "/shoeSchedule/shoeSchedule/deleteBatch",
          exportXlsUrl: "/shoeSchedule/shoeSchedule/exportXls",
          importExcelUrl: "shoeSchedule/shoeSchedule/importExcel",

        },
        dictOptions:{},
        superFieldList:[],
        scheduleVisible: false,
        courierId: null,
        dataSource: [],
        loading:false,
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
      initDataByDIY(courierId){
        this.courierId = courierId;
        // console.log(courierId);

        let data = {
          "courierId": courierId
        }

        getAction(this.url.list, data).then((res) => {
          if (res.success){
            //把数据传入dataSource
            this.dataSource = res.result.records;
          }
        })

      },
      handleAddByDIY(){
        this.$refs.modalForm.add(this.courierId, this.dataSource);
        this.$refs.modalForm.title = "新增";
        this.$refs.modalForm.disableSubmit = false;
      },
      handleEditByDIY(record){
        this.$refs.modalForm.edit(record, this.dataSource);
        this.$refs.modalForm.title = "编辑";
        this.$refs.modalForm.disableSubmit = false;
      },
      handleDeleteByDIY(scheduleId){
        var that = this;
        deleteAction(that.url.delete, {id: scheduleId}).then((res) => {
          if (res.success) {
            //重新计算分页问题
            that.reCalculatePage(1)
            that.$message.success(res.message);
            that.modalFormOkByDIY();
          } else {
            that.$message.warning(res.message);
          }
        });
      },
      modalFormOkByDIY(){
        let data = {
          "courierId": this.courierId
        }
        this.loading = true;
        getAction(this.url.list, data).then((res) => {
          if (res.success){

            this.dataSource = res.result.records;

            if (res.result.total){
              this.ipagination.total = res.result.total;
            } else {
              this.ipagination.total = 0;
            }
          } else {
            this.$message.warning(res.message);
          }
        }).finally(() => {
          this.loading = false;
        })
      },
      initDictConfig(){
      },
      getSuperFieldList(){
        let fieldList=[];
        fieldList.push({type:'int',value:'scheduleId',text:' ID',dictCode:''})
        fieldList.push({type:'int',value:'courierId',text:' 配送员ID',dictCode:''})
        fieldList.push({type:'string',value:'week',text:' 星期几',dictCode:''})
        fieldList.push({type:'string',value:'startTime',text:' 开始时间',dictCode:''})
        fieldList.push({type:'string',value:'endTime',text:' 结束时间',dictCode:''})
        fieldList.push({type:'int',value:'status',text:' 状态:0=关闭,1=开启',dictCode:''})
        fieldList.push({type:'datetime',value:'createTime',text:' 创建时间'})
        fieldList.push({type:'datetime',value:'updateTime',text:' 更新时间'})
        this.superFieldList = fieldList
      },
      reCalculatePage(count){
        //总数量-count
        let total=this.ipagination.total-count;
        //获取删除后的分页数
        let currentIndex=Math.ceil(total/this.ipagination.pageSize);
        //删除后的分页数<所在当前页
        if(currentIndex<this.ipagination.current){
          this.ipagination.current=currentIndex;
        }
      },
    }
  }
</script>
<style scoped>
  @import '~@assets/less/common.less';
</style>