<template>
  <j-modal
    :title="title"
    width="90vw"
    :visible="visible"
    switchFullscreen
    @cancel="handleCancel"
    cancelText="关闭"
    :footer="null"
    wrapClassName="full-modal"
  >
    <div>
      <a-form-model-item label="派送类型" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="type">
        <a-radio-group v-model="type" @change="radioChange">
          <a-radio value="0" style="margin-right: 20px">全体用户</a-radio>
          <a-radio value="1">部分用户</a-radio>
        </a-radio-group>
      </a-form-model-item>
      <div class="table-page-search-wrapper">
        <a-form layout="inline" @keyup.enter.native="searchQuery" v-show="type == '1'">
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
            <a-col :xl="6" :lg="7" :md="8" :sm="24">
              <span style="float: left;overflow: hidden;" class="table-page-search-submitButtons">
                <a-button type="primary" @click="searchQuery" icon="search">查询</a-button>
                <a-button type="primary" @click="searchReset" icon="reload" style="margin-left: 8px">重置</a-button>
              </span>
            </a-col>
          </a-row>
        </a-form>
      </div>

      <div v-show="type == '1'">
        <!-- 表格1 -->
        <a-table
          ref="table"
          size="middle"
          :scroll="{ x: true }"
          bordered
          rowKey="userId"
          :columns="columns"
          :dataSource="dataSource"
          :pagination="ipagination"
          :loading="loading"
          class="j-table-force-nowrap"
          @change="handleTableChange"
          :row-selection="{ onChange: onSelectChange, onSelect: onSelect, onSelectAll: onSelectAll }"
          :expanded-row-keys.sync="expandedRowKeys1"
        >
          <template slot="imgSlot" slot-scope="text, record">
            <span v-if="!text" style="font-size: 12px;font-style: italic;">无图片</span>
            <img
              v-else
              :src="getImgView(text)"
              :preview="record.userId"
              height="25px"
              alt=""
              style="max-width:80px;font-size: 12px;font-style: italic;"
            />
          </template>
        </a-table>

        <!-- 表格2 -->
        已选用户
        <a-table
          ref="table"
          size="middle"
          :scroll="{ x: true }"
          bordered
          rowKey="userId"
          :columns="columns2"
          :dataSource="selectedDataSource"
          :pagination="ipagination1"
          class="j-table-force-nowrap"
          @change="handleTableChange1"
        >
          <template slot="imgSlot" slot-scope="text, record">
            <span v-if="!text" style="font-size: 12px;font-style: italic;">无图片</span>
            <img
              v-else
              :src="getImgView(text)"
              :preview="record.userId"
              height="25px"
              alt=""
              style="max-width:80px;font-size: 12px;font-style: italic;"
            />
          </template>
          <span slot="action" slot-scope="text, record">
            <a @click="handleDel(record.userId)" style="color:#f91717">删除</a>
          </span>
        </a-table>
      </div>
      <a-row>
        <a-col :span="24">
          <a-col :span="6"></a-col>
          <a-col :span="6">
            <a-button @click="handleCancel">取消</a-button>
          </a-col>
          <a-col :span="6">
            <a-button @click="handleSubmit" type="primary" :disabled="type == '1' && expandedRowKeys1.length == 0">选好了，下一步</a-button>
          </a-col>
          <a-col :span="6"></a-col>
        </a-col>
      </a-row>
    </div>
  </j-modal>
</template>

<script>
import { JeecgListMixin } from '@/mixins/JeecgListMixin'
import { getAction, httpAction } from '../../../../api/manage'

export default {
  name: 'DistributeCouponModal',
  mixins: [JeecgListMixin],
  data() {
    return {
      visible: false,
      title: '手动派发',
      type: '0',
      /* 分页参数 */
      ipagination: {
        current: 1,
        pageSize: 5,
        pageSizeOptions: ['5', '10', '20', '30', '50'],
        showTotal: (total, range) => {
          return range[0] + '-' + range[1] + ' 共' + total + '条'
        },
        showQuickJumper: true,
        showSizeChanger: true,
        total: 0
      },
      // 分页1
      ipagination1: {
        current: 1,
        pageSize: 5,
        pageSizeOptions: ['5', '10', '20', '30', '50'],
        showTotal: (total, range) => {
          return range[0] + '-' + range[1] + ' 共' + total + '条'
        },
        showQuickJumper: true,
        showSizeChanger: true,
        total: 0
      },
      labelCol: {
        xs: { span: 24 },
        sm: { span: 1 }
      },
      wrapperCol: {
        xs: { span: 24 },
        sm: { span: 22 }
      },
      type: '0', // 用户群体 0全部用户 1部分用户
      // 搜索参数
      queryParam: {
        nickname: '',
        phone: ''
      },
      // 表头1
      columns: [
        {
          title: 'ID',
          align: 'center',
          dataIndex: 'userId'
        },
        {
          title: '用户昵称',
          align: 'center',
          dataIndex: 'nickname'
        },
        {
          title: '头像',
          align: 'center',
          dataIndex: 'avatar',
          scopedSlots: { customRender: 'imgSlot' }
        },
        {
          title: '手机号码',
          align: 'center',
          dataIndex: 'phone'
        }
      ],
      // 表头2
      columns2: [
        {
          title: 'ID',
          align: 'center',
          dataIndex: 'userId'
        },
        {
          title: '用户昵称',
          align: 'center',
          dataIndex: 'nickname'
        },
        {
          title: '头像',
          align: 'center',
          dataIndex: 'avatar',
          scopedSlots: { customRender: 'imgSlot' }
        },
        {
          title: '手机号码',
          align: 'center',
          dataIndex: 'phone'
        },
        {
          title: '操作',
          dataIndex: 'action',
          align: 'center',
          fixed: 'right',
          width: 147,
          scopedSlots: { customRender: 'action' }
        }
      ],
      url: {
        list: '/shoes/shoeUser/list'
      },
      selectedDataSource: [], // 选中表格的数据
      // 选中的
      expandedRowKeys1: []
    }
  },
  created() {},
  watch: {
    selectedDataSource(val) {
      this.ipagination1.total = val.length
    }
  },
  methods: {
    handleTableChange1(pagination) {
      this.ipagination1 = pagination
    },
    handleDel(id) {
      let selectedIdx = this.selectedDataSource.findIndex(item => item.userId == id)
      let idx = this.expandedRowKeys1.findIndex(item => item == id)
      this.selectedDataSource.splice(selectedIdx, 1)
      this.expandedRowKeys1.splice(idx, 1)
    },
    // 表格全选
    onSelectAll(selected, selectedRows, changeRows) {
      // 获取选中的表格用户id
      let ids = this.selectedDataSource.map(item => item.userId)
      if (selected) {
        // 全选的时候
        changeRows.forEach(element => {
          // 判断如果加入的用户不在已有用户里那么做 增加操作
          if (!ids.includes(element.userId)) {
            this.selectedDataSource.push(element)
          }
        })
      } else {
        // 全不选的时候
        let idsIdx = [] // 存放已选的 需要删除的 下标
        changeRows.forEach(element => {
          let idx = ids.findIndex(item => element.userId == item)
          // 如果找到了 那就记入下标
          if (idx != -1) {
            idsIdx.push(idx)
          }
        })
        // 先排序 从大的下标开始删除
        idsIdx
          .sort((a, b) => b - a)
          .forEach(idx => {
            this.selectedDataSource.splice(idx, 1)
          })
      }
    },
    // 表格单选
    onSelect(selected, selectedRows, changeRows) {
      if (selectedRows) {
        this.selectedDataSource.push(selected)
      } else {
        let idx = this.selectedDataSource.findIndex(item => item.userId == selected.userId)
        if (idx != -1) {
          this.selectedDataSource.splice(idx, 1)
        }
      }
    },
    onSelectChange(selectedRowKeys, val) {
      this.expandedRowKeys1 = selectedRowKeys
    },
    show() {
      this.visible = true
    },
    handleCancel() {
      this.visible = false
    },
    handleSubmit() {
      let data = {
        type: this.type,
        ids: this.expandedRowKeys1
      }
      this.$emit('submit', data)
    },
    radioChange() {
      //根据所选的单选值，请求不同的接口
    }
  }
}
</script>

<style scoped></style>
