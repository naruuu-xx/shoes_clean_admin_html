<template>
  <a-card class="card" :bordered="false">
    <a-spin :spinning="confirmLoading">
      <div>
        <a-row style="margin-top: 10px;">
          <p style="font-size: 20px; color: #000000">对外数据权限设置</p>
        </a-row>
        <a-row style="margin-top: 10px;">
          <a-col span="24">
            <p style="font-size: 16px; color: #000000">1.可被查看机柜：</p>
            <a-checkbox
              v-model:checked="checkAll"
              :indeterminate="indeterminate"
              @change="onCheckAllChange($event)"
            >
              全选
            </a-checkbox>
          </a-col>
        </a-row>
        <a-row>
          <a-checkbox-group v-model:value="selectedLocker" @change="onChange">
            <a-row>
              <a-col :span="8" v-for="(item, index) in lockerList">
                <a-checkbox :value="item.lockerId" :key="item.lockerId" style="margin: 10px 40px;font-size: 18px;color: #000000">{{item.name}}</a-checkbox>
              </a-col>
            </a-row>
          </a-checkbox-group>
        </a-row>
        <div style="display: flex;justify-content: center;">
          <a-button type="primary" size="large" @click="onSubmit">保存</a-button>
        </div>
      </div>
    </a-spin>
  </a-card>
</template>

<script>
import {downFile, httpAction} from "../../../api/manage";

export default {
  name: "LockerPermissionConfig",
  data() {
    return {
      title: '新增袋子',
      width: 800,
      visible: false,
      dataForm: {},
      defaultValue: 1,
      buttonItemLayout: {
        wrapperCol: {
          span: 14,
          offset: 4,
        }
      },
      lockerList: [],
      selectedLocker: [],
      checkAll: false,
      indeterminate: true,
      confirmLoading: false
    }
  },
  created() {
    this.getLockerList();
  },
  methods: {
    show() {
      this.visible = true;
    },
    handleCancel() {
      this.visible = false;
      this.dataForm = {};
      this.selectedLocker = [];
      this.lockerList = [];
    },
    getLockerList(){
      let that = this;
      this.selectedLocker = [];
      httpAction("/shoes/shoeLocker/getAllLockerList", null, "get").then((res) => {
        if (res.success) {
          this.lockerList = res.result.map((item, index) => {return {lockerId: item.lockerId, name: `${item.name}(${item.lockerCode})`, isVisible: item.isVisible}});
          this.selectedLocker = res.result.filter(item => item.isVisible).map(item => item.lockerId);
        } else {
          that.$message.error(res.message);
        }
      })
    },
    onChange() {
      this.indeterminate = !!this.selectedLocker.length && this.selectedLocker.length < this.lockerList.length;
      this.checkAll = this.selectedLocker.length === this.lockerList.length;
    },
    onCheckAllChange(e){
      if (e.target.checked) {
        this.selectedLocker = this.lockerList.map((item, index)=> {return item.lockerId});
        return false;
      } else {
        this.selectedLocker = [];
        this.indeterminate = false;
      }
    },
    onSubmit(){
      this.confirmLoading = true;

      let lockerList = this.lockerList;
      let selectedLocker = this.selectedLocker;

      let newLockerList = lockerList.map((item) => ({
        lockerId: item.lockerId,
        isVisible: selectedLocker.includes(item.lockerId) ? 1 : 0
      })).filter((item, index) => item.isVisible !== lockerList[index].isVisible)

      httpAction("/shoes/shoeLocker/setLockerVisible", newLockerList, "post").then((res) => {
        if (res.success) {
          setTimeout(() => {
            this.$message.success(res.message);
            this.getLockerList();
          }, 700)
        }
      }).finally(() => {
        setTimeout(() => {
          this.confirmLoading = false;
        }, 700)
      })

    }
  }
}
</script>

<style scoped>
.card {
  margin-bottom: 24px;
}
</style>