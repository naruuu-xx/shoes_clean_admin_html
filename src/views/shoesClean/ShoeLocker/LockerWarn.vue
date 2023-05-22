<template>
  <a-card :bordered="false">
    <h1>机柜预警</h1>
    <div>
      预警值：
      <a-input-number style="width: 150px" v-model="warnNum" placeholder="请输入0-100的整数" autocomplete="off" suffix="%"></a-input-number>%
    </div>
    <br/>
    <div class="content-font">
      接收通知人：
      <XfSelectPlus
        :list="weekList"
        @change="checkedSelect"
        @changeList="changeSelect"
        v-model="userId"
        searchKey="nickname"
        :url='`/ShoeConfig/shoeConfig/getUser`'
      >
      </XfSelectPlus>
      <a-button type="primary" style="margin: 12px" @click="add">添加</a-button>
    </div>

    <br/>

    <div style="display: flex">
      <a-space>
      <div class="tag"  v-for="(item, index) in warnUserIds" key="index">
        {{ item.label }}<a-icon @click="handleClose(index)" type="close"></a-icon>
      </div>
    </a-space>
    </div>
    <br/>
    <a-space>
      <a-button type="primary" @click="save">保存</a-button>
    </a-space>



<!--    <a-divider/>-->
<!--    <h1>优惠券审核通知</h1>-->
<!--    <div class="content-font">-->
<!--      接收通知人：-->
<!--      <XfSelectPlus-->
<!--        :list="weekList2"-->
<!--        @change="checkedSelect2"-->
<!--        @changeList="changeSelect2"-->
<!--        v-model="userId2"-->
<!--        searchKey="nickname"-->
<!--        :url='`/ShoeConfig/shoeConfig/getUser`'-->
<!--      >-->
<!--      </XfSelectPlus>-->
<!--      <a-button type="primary" style="margin: 12px" @click="add2">添加</a-button>-->
<!--    </div>-->
<!--    <br/>-->

<!--    <div style="display: flex">-->
<!--      <a-space>-->
<!--        <div class="tag"  v-for="(item, index) in couponNoticeIds" key="index">-->
<!--          {{ item.label }}<a-icon @click="handleClose2(index)" type="close"></a-icon>-->
<!--        </div>-->
<!--      </a-space>-->
<!--    </div>-->
<!--    <br/>-->
<!--    <a-space>-->
<!--      <a-button type="primary" @click="save2">保存</a-button>-->
<!--    </a-space>-->


  </a-card>
</template>

<script>

import '@/assets/less/TableExpand.less';
import {httpAction} from "@api/manage";
import XfSelectPlus from "@comp/Xf/XfSelectPlus";

export default {
  components: {
    XfSelectPlus
  },

  name: 'ShoeConfig',
  data() {
    return {
      warnNum: '',
      userId: '',
      userId2: '',
      warnUserIds: [],
      couponNoticeIds: [],
      weekList: [],
      weekList2: [],
      item: {},
      item2: {}
    }
  },
  created() {
    this.getShoeConfig();
    this.getShoeConfig2();
  },
  mounted() {
    this.getShoeConfig();
    this.getShoeConfig2();
  },
  computed: {},
  methods: {
    changeSelect(data) {
      this.weekList = data.records.map(item => ({
        label: item.nickname,
        value: item.userId
      }));
    },
    changeSelect2(data) {
      this.weekList2 = data.records.map(item => ({
        label: item.nickname,
        value: item.userId
      }));
    },

    add() {
      if (this.item.value==null){
        this.$message.warning('请选择用户！');
        return;
      }
      for (let i = 0; i < this.warnUserIds.length; i++) {
        if (this.warnUserIds[i].value == this.item.value) {
          this.$message.warning('该用户已添加！');
          return;
        }
      }
      this.warnUserIds.push(this.item);
      this.$message.success('添加成功');
    },
    add2() {
      if (this.item2.value==null){
        this.$message.warning('请选择用户！');
        return;
      }
      for (let i = 0; i < this.couponNoticeIds.length; i++) {
        if (this.couponNoticeIds[i].value == this.item2.value) {
          this.$message.warning('该用户已添加！');
          return;
        }
      }
      this.couponNoticeIds.push(this.item2);
      this.$message.success('添加成功');

    },
    checkedSelect(item) {
      this.item = item;
    },
    checkedSelect2(item2) {
      this.item2 = item2;
    },
    handleClose(e) {
      this.warnUserIds.splice(e,1)
    },
    handleClose2(e) {
      this.couponNoticeIds.splice(e,1)
    },
    // 获取基础信息
    getShoeConfig() {
      httpAction("/ShoeConfig/shoeConfig/showLockerWarnConfig", "", "get").then((res) => {
        if (res.success){
          this.warnNum= res.result.lockerWarn
          this.warnUserIds=res.result.lockerWarnIds.map(item => ({
            label: item.nickname,
            value: item.userId
          }));

        }
      })
    },
    getShoeConfig2() {
      httpAction("/ShoeConfig/shoeConfig/showCouponNoticeConfig", "", "get").then((res) => {
        if (res.success){
          this.couponNoticeIds=res.result.couponNoticeIds.map(item => ({
            label: item.nickname,
            value: item.userId
          }));
        }
      })
    },
    // 保存按钮
    save() {
      const that = this;

      let dataList = {"lockerWarn": that.warnNum, "lockerWarnIds": that.warnUserIds.map(item=>item.value)}

      httpAction("/ShoeConfig/shoeConfig/addLockerWarnConfig", dataList, "post").then((res) => {
        if (res.success) {
          that.$message.success(res.message);
          this.getShoeConfig();
        } else {
          that.$message.warning(res.message);
        }
      })
    },
    save2() {
      const that = this;

      let dataList = {"couponNoticeIds": that.couponNoticeIds.map(item=>item.value)}

      httpAction("/ShoeConfig/shoeConfig/addCouponNoticeConfig", dataList, "post").then((res) => {
        if (res.success) {
          that.$message.success(res.message);
          this.getShoeConfig2();
        } else {
          that.$message.warning(res.message);
        }
      })
    },
  }
}
</script>
<style scoped>
@import '~@assets/less/common.less';
.tag{
  padding: 4px 8px;
  border-radius: 4px;
  border: 1px solid #cccccc;
}
span {
  display: block;
}
</style>