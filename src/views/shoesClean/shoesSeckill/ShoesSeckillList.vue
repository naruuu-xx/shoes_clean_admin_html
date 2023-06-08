<template>
  <a-card :bordered="false">
    <!-- 查询区域 -->
    <div class="table-page-search-wrapper">
      <a-form layout="inline" @keyup.enter.native="searchQuery">
        <a-row :gutter="24">
          <a-col :xl="6" :lg="7" :md="8" :sm="24">
            <a-form-item label="名称">
              <a-input placeholder="请输入商品名称" v-model="queryParam.title"></a-input>
            </a-form-item>
          </a-col>
          <a-col :xl="6" :lg="7" :md="8" :sm="24">
            <a-form-item label="状态">
              <a-select v-model="queryParam.statusText"  :allowClear = "true">
                <a-select-option v-for="i in statusList" :value="i.statusText" :key="i.status">{{i.statusText}}</a-select-option>
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
      <a-button @click="addList" type="primary" icon="plus" v-has="'seckill:add'">新增</a-button>
    </div>

    <!-- table区域-begin -->
    <div>

      <a-table
        ref="table"
        size="middle"
        :scroll="{x:true}"
        bordered
        rowKey="seckillId"
        :columns="columns"
        :dataSource="dataSource"
        :pagination="ipagination"
        :loading="loading"
        :rowSelection="{selectedRowKeys: selectedRowKeys, onChange: onSelectChange}"
        class="j-table-force-nowrap"
        @change="handleTableChange">
        <div slot="status" slot-scope="text, record,idx">
          <a-switch :defaultChecked="record.status == '1'" :loading="switchLoading" @click="onSwitch($event,record.seckillId,idx)"/>
        </div>
        <span slot="action" slot-scope="text, record">

          <a @click="onAction(Object.assign({},record,{disabled:true}))" v-if="record.status == '1'">查看</a>
          <a @click="onAction(record)" v-if="record.status == '0'" v-has="'seckill:edit'">编辑</a>
        </span>

      </a-table>
    </div>

    <ShoesSeckillModal ref="modalForm" @ok="modalFormOk" :disabled="disabled"></ShoesSeckillModal>
  </a-card>
</template>

<script>

  import '@/assets/less/TableExpand.less'
  import { mixinDevice } from '@/utils/mixin'
  import { JeecgListMixin } from '@/mixins/JeecgListMixin'
  import ShoesSeckillModal from './modules/ShoesSeckillModal'
  import { filterMultiDictText } from '@comp/dict/JDictSelectUtil'
  import { getFileAccessHttpUrl, httpAction } from '@api/manage'

  export default {
    name: 'ShoeGoodsList',
    mixins:[JeecgListMixin, mixinDevice],
    components: {
      ShoesSeckillModal
    },
    data () {
      function typerender(text) {
        if(text === "ordinary"){
          return "普洗";
        }
        else if(text === "fine"){
          return "精洗";
        }
        else{
          return "修复";
        }
      }

      function imagerender(text) {
        if(text && text.indexOf(",")>0){
          text = text.substring(0,text.indexOf(","))
        }
        return getFileAccessHttpUrl(text)
      }

      return {
        description: 'shoe_goods管理页面',
        // 表头
        columns: [
          {
            title:'ID',
            align:"center",
            dataIndex: 'seckillId'
          },
          {
            title:'产品名称',
            align:"center",
            dataIndex: 'title'
          },
          {
            title:'原价',
            align:"center",
            dataIndex: 'originalPrice'
          },
          {
            title:'售卖价',
            align:"center",
            dataIndex: 'seckillPrice'
          },
          {
            title:'总份数',
            align:"center",
            dataIndex: 'inventory'
          },
          {
            title:'已售分量',
            align:"center",
            dataIndex: 'sale'
          },
          {
            title:'剩余份数',
            align:"center",
            dataIndex: 'surplus'
          },
          {
            title:'状态',
            align:"center",
            dataIndex: 'seckillStatusText'
          },
          {
            title:'是否上架',
            align:"center",
            dataIndex: 'status',
            scopedSlots: { customRender: 'status' }
          },
          {
            title:'开始时间',
            align:"center",
            dataIndex: 'startTime',
            customRender:function (text) {
              return !text?"":(text.length>10?text.substr(0,10):text)
            }
          },
          {
            title:'结束时间',
            align:"center",
            dataIndex: 'endTime',
            customRender:function (text) {
              return !text?"":(text.length>10?text.substr(0,10):text)
            }
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
          list: "/ShoeSeckill/shoeSeckill/queryList",
          delete: "",
          deleteBatch: "",
          exportXlsUrl: "",
          importExcelUrl: "",

        },
        superFieldList:[],
        typeList:[],
        statusList:[],
        switchLoading:false,
        disabled: true
      }
    },
    created() {

    },
    computed: {
      importExcelUrl: function(){
        return `${window._CONFIG['domianURL']}/${this.url.importExcelUrl}`;
      },
    },
    methods: {
      addList() {
        this.disabled = false
        this.handleAdd()
      },
      initDictConfig(){
      },
      onSwitch(status,seckillId,idx) {
        status = status ? '1' : '0'
        let form ={
          seckillId,
          status
        }
        // this.dataSource[idx].status = status
        httpAction('ShoeSeckill/shoeSeckill/editStatus', form, 'put').then((res) => {
            if (res.success) {
              this.$message.success(res.message)
              this.dataSource[idx].status = status
            } else {
              this.dataSource[idx].status = status ? '0' : '1'
            }
          }).finally(() => {
          })
        console.log(444,seckillId);
      },
      onAction(val) {
        this.disabled = !!val.disabled
        this.handleEdit(val)
      }
    }

  }
</script>
<style scoped>
  @import '~@assets/less/common.less';
</style>