<template>
  <j-modal
    :title="title"
    :width="width"
    :visible="visible"
    @cancel="handleCancel"
    :footer="null">
    <a-row type="flex" justify="space-around" align="middle" style="height: 50px;">
      <a-col :span="4" class="oneTableHeardCell">邀请人昵称</a-col>
      <a-col :span="4" class="oneOtherTableHeardCell">头像</a-col>
      <a-col :span="4" class="oneOtherTableHeardCell">已邀请人数</a-col>
      <a-col :span="4" class="oneOtherTableHeardCell">未下单人数</a-col>
      <a-col :span="4" class="oneOtherTableHeardCell">已下单人数</a-col>
      <a-col :span="4" class="oneOtherTableHeardCell">完成订单人数</a-col>
    </a-row>
    <a-row type="flex" justify="space-around" align="middle" v-for="item in userPullCountList" style="height: 70px;">
      <a-col :span="4" class="oneTableCell">{{item.nickname}}</a-col>
      <a-col :span="4" class="oneOtherTableCell"><img alt="example" :src="item.avatar" style="width:20%;height: 50%"> </a-col>
      <a-col :span="4" class="oneOtherTableCell">{{item.pullCount}}</a-col>
      <a-col :span="4" class="oneOtherTableCell">{{item.noPlaceAnOrder}}</a-col>
      <a-col :span="4" class="oneOtherTableCell">{{item.placedAnOrder}}</a-col>
      <a-col :span="4" class="oneOtherTableCell">{{item.finishAnOrder}}</a-col>
    </a-row>
  </j-modal>
</template>

<script>
import {httpAction} from "../../../../api/manage";

export default {
  name: "UserPullDetailModal",
  data() {
    return {
      title: "拉新活动详情",
      width: 1200,
      visible: false,
      userPullCountList: []
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
      httpAction("/ShoeEvent/ShoeEvent/queryUserPullCount", null, "get").then((res) => {
        if (res.success) {
          this.userPullCountList = res.result;
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