<template>
  <a-card class="card" :bordered="false">
    <a-spin :spinning="confirmLoading">
      <div>
        <a-row style="margin-top: 10px;">
          <p style="font-size: 20px; color: #000000">可手动变更状态的机柜</p>
        </a-row>
        <a-row style="margin-top: 10px;">
          <a-col span="24">
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
              <a-col :span="8" v-for="(item, index) in lockerList" :key="index">
                <a-checkbox :value="item.lockerId" :key="item.lockerId" style="margin: 10px 40px;font-size: 18px;color: #000000">{{item.name}}</a-checkbox>
              </a-col>
            </a-row>
          </a-checkbox-group>
        </a-row>
        <div style="display: flex;justify-content: center;">
          <a-button type="primary" size="large" @click="onSubmit" :disabled="!newLockerList.length">保存</a-button>
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
  computed:{
    newLockerList() {
      return this.lockerList.map((item) => ({
        lockerId: item.lockerId,
        isOperation: this.selectedLocker.includes(item.lockerId) ? 1 : 0
      })).filter((item, index) => item.isOperation !== this.lockerList[index].isOperation)
    }
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
      // TODO 
      httpAction("/shoes/shoeLocker/getAllLockerList", null, "get").then((res) => {
        if (res.success) {
          this.lockerList = res.result.map((item, index) => {return {lockerId: item.lockerId, name: `${item.name}(${item.lockerCode})`, isOperation: item.isOperation}});
          this.selectedLocker = res.result.filter(item => item.isOperation).map(item => item.lockerId);
          this.checkAll = this.lockerList.length === this.selectedLocker.length
          this.indeterminate = this.selectedLocker.length < this.lockerList.length
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
      httpAction("/shoes/shoeSpecialOrder/setOperation", this.newLockerList, "post").then((res) => {
        if (res.success) {
          setTimeout(() => {
            this.$message.success(res.message || '更新成功');
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