<template>
  <a-card :bordered="false">
    <!-- 查询区域 -->
    <div class="table-page-search-wrapper">
      <a-form layout="inline" @keyup.enter.native="searchQuery">
        <a-row :gutter="24">
          <a-col :xl="6" :lg="7" :md="8" :sm="24">
            <a-form-item label="机柜编码">
              <a-input placeholder="请输入机柜编码" v-model="queryParam.lockerCode" autocomplete="off"></a-input>
            </a-form-item>
          </a-col>
<!--          <a-col :xl="6" :lg="7" :md="8" :sm="24">-->
<!--            <a-form-item label="机构编码">-->
<!--              <a-input placeholder="请输入机构编码" v-model="queryParam.orgCode"></a-input>-->
<!--            </a-form-item>-->
<!--          </a-col>-->
<!--          <template v-if="toggleSearchStatus">-->
<!--            <a-col :xl="6" :lg="7" :md="8" :sm="24">-->
<!--              <a-form-item label="省">-->
<!--                <j-area-linkage type="cascader" v-model="queryParam.province" placeholder="请选择省市区"/>-->
<!--              </a-form-item>-->
<!--            </a-col>-->
<!--            <a-col :xl="6" :lg="7" :md="8" :sm="24">-->
<!--              <a-form-item label="市">-->
<!--                <j-area-linkage type="cascader" v-model="queryParam.city" placeholder="请选择省市区"/>-->
<!--              </a-form-item>-->
<!--            </a-col>-->
<!--            <a-col :xl="6" :lg="7" :md="8" :sm="24">-->
<!--              <a-form-item label="区/县">-->
<!--                <j-area-linkage type="cascader" v-model="queryParam.area" placeholder="请选择省市区"/>-->
<!--              </a-form-item>-->
<!--            </a-col>-->
<!--            <a-col :xl="6" :lg="7" :md="8" :sm="24">-->
<!--              <a-form-item label="添加时间">-->
<!--                <j-date :show-time="true" date-format="YYYY-MM-DD HH:mm:ss" placeholder="请选择添加时间" v-model="queryParam.createTime"></j-date>-->
<!--              </a-form-item>-->
<!--            </a-col>-->
<!--            <a-col :xl="10" :lg="11" :md="12" :sm="24">-->
<!--              <a-form-item label="修改时间">-->
<!--                <j-date :show-time="true" date-format="YYYY-MM-DD HH:mm:ss" placeholder="请选择开始时间" class="query-group-cust" v-model="queryParam.updateTime_begin"></j-date>-->
<!--                <span class="query-group-split-cust"></span>-->
<!--                <j-date :show-time="true" date-format="YYYY-MM-DD HH:mm:ss" placeholder="请选择结束时间" class="query-group-cust" v-model="queryParam.updateTime_end"></j-date>-->
<!--              </a-form-item>-->
<!--            </a-col>-->
<!--          </template>-->
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
      <a-button @click="handleAdd" type="primary" icon="plus">新增</a-button>
<!--      <a-button type="primary" icon="download" @click="handleExportXls('shoe_locker')">导出</a-button>-->
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
          <img v-else :src="getImgView(text)" :preview="record.id" height="25px" alt="" style="max-width:80px;font-size: 12px;font-style: italic;"/>
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
          <a @click="handleEdit(record)" >编辑</a>

          <a-divider type="vertical" />

<!--          <a @click="handleDetail(record)">详情</a>-->

<!--           <a-divider type="vertical" />-->

          <a @click="handleGrid(record)">柜子状态</a>
          <a-divider type="vertical" />
          <a-popconfirm title="确定一键开柜吗？" @confirm="() => openAllDoor(record.lockerCode)">
            <a>一键开柜</a>
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

    <shoe-locker-modal ref="modalForm" @ok="modalFormOk"></shoe-locker-modal>
    <shoe-locker-grid-modal ref="gridModal"></shoe-locker-grid-modal>
  </a-card>
</template>

<script>

  import '@/assets/less/TableExpand.less'
  import { mixinDevice } from '@/utils/mixin'
  import { JeecgListMixin } from '@/mixins/JeecgListMixin'
  import ShoeLockerModal from './modules/ShoeLockerModal'
  import shoeLockerGridModal from './modules/shoeLockerGridModal'
  import Area from '@/components/_util/Area'
  import {filterDictTextByCache} from "@comp/dict/JDictSelectUtil";
  import {httpAction} from "../../../api/manage";
  import {mapGetters} from 'vuex';

  export default {
    name: 'ShoeLockerList',
    mixins:[JeecgListMixin, mixinDevice],
    components: {
      ShoeLockerModal,
      shoeLockerGridModal
    },
    data () {
      return {
        description: 'shoe_locker管理页面',
        // 表头
        columns: [
          // {
          //   title:'ID',
          //   align:"center",
          //   dataIndex: 'lockerId'
          // },
          // {
          //   title:'机柜类型',
          //   align:"center",
          //   dataIndex: 'type',
          //   customRender: (text) => {
          //     return filterDictTextByCache('shoe_locker_type', text);
          //   },
          // },
          {
            title:'机柜编码',
            align:"center",
            dataIndex: 'lockerCode'
          },
          {
            title:'机柜名称',
            align:"center",
            dataIndex: 'name'
          },
          {
            title:'区域',
            align:"center",
            dataIndex: 'departName'
          },
          {
            title:'格子数',
            align:"center",
            dataIndex: 'num'
          },
          {
            title:'空闲格子数',
            align:"center",
            dataIndex: 'free'
          },
          {
            title:'机柜状态',
            align:"center",
            dataIndex: 'status',
            customRender: (text) => {
              return filterDictTextByCache('shoe_locker_status', text);
            },
          },
          {
            title:'在线状态',
            align:"center",
            dataIndex: 'onlineStatus',
            customRender: (text) => {
              return filterDictTextByCache('shoe_locker_online_status', text);
            },
          },
          // {
          //   title:'省',
          //   align:"center",
          //   dataIndex: 'province',
          // },
          // {
          //   title:'市',
          //   align:"center",
          //   dataIndex: 'city',
          // },
          // {
          //   title:'区/县',
          //   align:"center",
          //   dataIndex: 'area',
          // },
          {
            title:'详细地址',
            align:"center",
            dataIndex: 'address'
          },
          {
            title:'经度',
            align:"center",
            dataIndex: 'longitude'
          },
          {
            title:'纬度',
            align:"center",
            dataIndex: 'latitude'
          },
          // {
          //   title:'添加时间',
          //   align:"center",
          //   dataIndex: 'createTime'
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
          list: "/shoes/shoeLocker/queryList",
          delete: "/shoes/shoeLocker/delete",
          deleteBatch: "/shoes/shoeLocker/deleteBatch",
          exportXlsUrl: "/shoes/shoeLocker/exportXls",
          importExcelUrl: "shoes/shoeLocker/importExcel",

        },
        dictOptions:{},
        pcaData:'',
        superFieldList:[],
      }
    },
    created() {
      this.pcaData = new Area()
    this.getSuperFieldList();
      console.log(this.userInfo());
    },
    computed: {
      importExcelUrl: function(){
        return `${window._CONFIG['domianURL']}/${this.url.importExcelUrl}`;
      },
    },
    methods: {
      ...mapGetters(["userInfo"]),
      getPcaText(code){
        return this.pcaData.getText(code);
      },
      initDictConfig(){
      },
      getSuperFieldList(){
        let fieldList=[];
        fieldList.push({type:'int',value:'lockerId',text:'ID',dictCode:''})
        fieldList.push({type:'string',value:'lockerCode',text:'机柜编码',dictCode:''})
        fieldList.push({type:'string',value:'orgCode',text:'机构编码',dictCode:''})
        fieldList.push({type:'int',value:'status',text:'状态:0=停用,1=启用',dictCode:''})
        fieldList.push({type:'BigDecimal',value:'log',text:'经度',dictCode:''})
        fieldList.push({type:'BigDecimal',value:'lat',text:'纬度',dictCode:''})
        fieldList.push({type:'string',value:'address',text:'详细地址',dictCode:''})
        fieldList.push({type:'pca',value:'province',text:'省'})
        fieldList.push({type:'pca',value:'city',text:'市'})
        fieldList.push({type:'pca',value:'area',text:'区/县'})
        fieldList.push({type:'datetime',value:'createTime',text:'添加时间'})
        fieldList.push({type:'datetime',value:'updateTime',text:'修改时间'})
        fieldList.push({type:'int',value:'num',text:'格子数',dictCode:''})
        fieldList.push({type:'int',value:'free',text:'空闲格子数',dictCode:''})
        this.superFieldList = fieldList
      },
      handleGrid(record){
        this.$refs.gridModal.show(record);
      },
      openAllDoor(lockerCode){
        const that = this;
        let data = {
          "devicenum":lockerCode
        };
        httpAction("/api/IoT/openAllDoor", data, 'post').then((res)=>{
          if(res.code === 0){
            that.$message.success("开门成功")
          } else {
            that.$message.warning(res.message);
          }
        })
      }
    }
  }
</script>
<style scoped>
  @import '~@assets/less/common.less';
</style>