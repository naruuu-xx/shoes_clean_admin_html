<template>
  <a-card :bordered="false">
    <!-- 查询区域 -->
    <div class="table-page-search-wrapper">
      <a-form layout="inline" @keyup.enter.native="searchQuery">
        <a-row :gutter="24">
        </a-row>
      </a-form>
    </div>
    <!-- 查询区域-END -->

    <!-- 操作按钮区域 -->
    <!-- <div class="table-operator">
      <a-button @click="handleAdd" type="primary" icon="plus">新增</a-button>
      <a-dropdown v-if="selectedRowKeys.length > 0">
        <a-menu slot="overlay">
          <a-menu-item key="1" @click="batchDel"><a-icon type="delete"/>删除</a-menu-item>
        </a-menu>
        <a-button style="margin-left: 8px"> 批量操作 <a-icon type="down" /></a-button>
      </a-dropdown>
    </div> -->

    <!-- table区域-begin -->
    <div>

      <a-table
        ref="table"
        size="middle"
        :scroll="{x:true}"
        bordered
        rowKey="imageId"
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
          <img @click="onImg(text)" v-else :src="text" height="25px" alt="" style="max-width:80px;font-size: 12px;font-style: italic;"/>
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
          <a @click="handleEditImg(record)">修改</a>
        </span>

      </a-table>
    </div>

    <a-modal v-model="showImg" :footer="null">
      <img :src="imgUrl" style="width: 100%;"/>
    </a-modal>

    <!-- 修改图片 -->
    <a-modal v-model="showEditImg" :footer="null" :maskClosable="false" :closable="false">
      <div class="center">
        <j-image-upload v-model="form.img" ></j-image-upload>
        <div class="foot">
          <a-button @click="showEditImg = false">取消</a-button>
          <a-button type="primary" style="margin-left: 30px;" @click="onSubmit" :loading="confirmLoading">保存</a-button>
        </div>
      </div>
    </a-modal>
  </a-card>
</template>

<script>
  import { httpAction } from '@/api/manage'
  import '@/assets/less/TableExpand.less'
  import { mixinDevice } from '@/utils/mixin'
  import { JeecgListMixin } from '@/mixins/JeecgListMixin'

  export default {
    name: 'ShoeBannerList',
    mixins:[JeecgListMixin, mixinDevice],
    components: {

    },
    data () {
      return {
        description: '图片管理页面',
        // 表头
        columns: [
          {
            title:'模块',
            align:"center",
            dataIndex: 'name'
          },
          {
            title:'图片',
            align:"center",
            dataIndex: 'img',
            scopedSlots: {customRender: 'imgSlot'}
          },
          {
            title:'尺寸',
            align:"center",
            dataIndex: 'size'
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
          list: "/ShoeImage/shoeImage/list",
          edit: "/ShoeImage/shoeImage/edit"
        },
        imgUrl:'',
        showImg:false,
        showEditImg:false,
        form:{
          img:'',
          imageId:''
        },
        confirmLoading:false
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
      onSubmit() {
        if(!this.form.img) {
          return this.$message.warning('请选择一张图片!');
        }
        this.confirmLoading = true
        httpAction(this.url.edit, this.form, 'post').then((res)=>{
          if(res.success){
            this.$message.success(res.message);
            this.showEditImg = false
            this.loadData();
          }else{
            this.$message.warning(res.message);
          }
        }).finally(() => {
          this.confirmLoading = false;
        })
      },
      onImg(url) {
        this.imgUrl = url
        this.showImg = true
      },
      handleEditImg(record) {
        this.showEditImg = true
        this.form.img = record.img
        this.form.imageId = record.imageId
      },
      initDictConfig(){
      },
    }
  }
</script>
<style scoped>
  @import '~@assets/less/common.less';
  .center {
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
  }
  .foot {
    display: flex;
    align-items: center;
    justify-content: center;
    margin-top: 24px;
  }
</style>