<template>
  <j-modal
    :title="title"
    :width="width"
    :visible="visible"
    @cancel="handleCancel"
    :footer="null">
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
      :rowSelection="{selectedRowKeys: selectedRowKeys, onChange: onSelectChange}"
      class="j-table-force-nowrap"
      @change="handleTableChange">

      <template slot="imgSlot" slot-scope="text,record">
        <span v-if="!text" style="font-size: 12px;font-style: italic;">无图片</span>
        <img v-else :src="getImgView(text)" :preview="record.avatar" height="25px" alt="" style="max-width:80px;font-size: 12px;font-style: italic;"/>
      </template>

    </a-table>

  </j-modal>
</template>

<script>
import '@/assets/less/TableExpand.less';
import {httpAction} from "../../../../api/manage";
import { mixinDevice } from '@/utils/mixin';
import { JeecgListMixin } from '@/mixins/JeecgListMixin';

export default {
  name: "UserPullDetailModal",
  mixins:[JeecgListMixin, mixinDevice],
  data() {
    return {
      title: "拉新活动详情",
      width: 1200,
      visible: false,
      userPullCountList: [],
      columns: [
        {
          title: "邀请人昵称",
          align: "center",
          dataIndex: "nickname"
        },
        {
          title: "头像",
          align: "center",
          dataIndex: "avatar",
          scopedSlots: {customRender: 'imgSlot'}
        },
        {
          title: "已邀请人数",
          align: "center",
          dataIndex: "pullCount"
        },
        {
          title: "未下单人数",
          align: "center",
          dataIndex: "noPlaceAnOrder"
        },
        {
          title: "已下单人数",
          align: "center",
          dataIndex: "placedAnOrder"
        },
        {
          title: "完成订单人数",
          align: "center",
          dataIndex: "finishAnOrder"
        },
      ],
      dataSource: [],
      ipagination: { total: 0},
      loading:false,
      url: {
        list: "/ShoeEvent/ShoeEvent/queryUserPullCount",
      },
    }
  },
  created() {
  },
  methods: {
    handleCancel(){
      this.visible = false;
    },
    show() {
      this.visible = true;

      //获取详情列表
      httpAction(this.url.list, null, "get").then((res) => {
        if (res.success) {
          //把数据传入dataSource
          this.dataSource = res.result.records;
          this.ipagination.current = 1;
          this.ipagination.total = res.result.total;
        }
      })
    }
  }
}
</script>

<style scoped>
.oneTableHeardCell{
  border-top: 1px solid #000000;
  border-left: 1px solid #000000;
  border-bottom: 1px solid #000000;
  border-right: 1px solid #000000;
  text-align:center;
  /*margin: 16px 0 16px 0;*/
  height: 100%;
  line-height: 50px;
}
.oneOtherTableHeardCell{
  border-top: 1px solid #000000;
  border-bottom: 1px solid #000000;
  border-right: 1px solid #000000;
  text-align:center;
  /*margin: 16px 0 16px 0;*/
  height: 100%;
  line-height: 50px;
}
.oneTableCell{
  border-left: 1px solid #000000;
  border-bottom: 1px solid #000000;
  border-right: 1px solid #000000;
  text-align:center;
  /*margin: 16px 0 16px 0;*/
  height: 100%;
  line-height: 70px;
}
.oneOtherTableCell{
  border-bottom: 1px solid #000000;
  border-right: 1px solid #000000;
  text-align:center;
  /*margin: 16px 0 16px 0;*/
  height: 100%;
  line-height: 70px;
}
</style>