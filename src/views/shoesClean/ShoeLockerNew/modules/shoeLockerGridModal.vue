<template>
  <j-modal
    :title="title"
    :width="width"
    :visible="visible"
    switchFullscreen
    @cancel="handleCancel"
    cancelText="关闭"
    :footer="null"
  >
    <div class="lockers">
      <div class="locker" v-for="(locker, idx) in lockerList" :key="idx">
        <div class="col" v-for="(item, index) in locker" :key="index">
          <div v-for="(item1, index1) in item" :key="index1">
            <div class="row" style="background: #d8d6d6" v-if="item1 == -1">屏幕</div>
            <a-popconfirm
              v-else
              :title="`确认打开${item1}号柜门吗`"
              ok-text="确认"
              cancel-text="取消"
              @confirm="openDoorByDevicenum(item1)"
            >
              <div class="row">{{ item1 }}（打开柜门）</div>
            </a-popconfirm>
          </div>
        </div>
      </div>
    </div>
  </j-modal>
</template>

<script>
import { httpAction } from '../../../../api/manage'

export default {
  name: 'shoeLockerGridModal',
  data() {
    return {
      title: '快递柜格子展示',
      width: 600,
      visible: false,
      devicenum: '',
      lockerList: [],
    }
  },
  created() {},
  methods: {
    // 拆分数组 array
    chunk(array, size) {
      let result = []
      let x = 0
      for (let x = 0; x < Math.ceil(array.length / size); x++) {
        let start = x * size
        let end = start + size
        result.push(array.slice(start, end))
      }
      return result
    },
    show(record) {
      this.devicenum = record.lockerCode
      // 后期接口拿柜子数量
      let cabinetNum = record.num + 1 // 需要加屏幕一个格子
      let arr = Array(cabinetNum)
        .fill(0)
        .map((item, idx) => {
          let num = idx + 1 // 让编号从1开始
          if (num < 10) {
            // 前九个格子正常
            return num
          } else {
            if (num == 10 || num == 11) {
              // 这个是屏幕
              return -1
            }
            // 因为屏幕占两个 所以不需要加一
            return idx
          }
        })
      this.lockerList = this.chunk(arr, 24).map((item) => this.chunk(item, 8))
      this.width = this.lockerList.length * 560
      this.visible = true
    },
    handleCancel() {
      this.visible = false
    },
    openDoorByDevicenum(openNum) {
      const that = this

      let data = {
        devicenum: this.devicenum,
        openNum: openNum,
        openType: 0,
      }

      httpAction('/api/IoT/openDoorByDevicenum', data, 'post').then((res) => {
        let json = JSON.parse(res)
        if (json.code === 0) {
          that.$message.success('开门成功')
        } else {
          that.$message.warning(json.message)
        }
      })
    },
  },
}
</script>

<style scoped lang="less">
.lockers {
  display: flex;
  justify-content: center;
}
.locker {
  box-sizing: border-box;
  margin: 0 15px;
  background-color: #fff;
  box-shadow: 2px 4px 8px -3px rgb(144, 138, 138);
  display: flex;
  .col {
    display: flex;
    flex-direction: column;
    width: 160px;

    .row {
      cursor: pointer;
      box-sizing: border-box;
      height: 70px;
      color: #fff;
      display: flex;
      align-items: center;
      justify-content: center;
      background-color: #2eabff;
      margin: 5px 10px;
    }

    .row-screen {
      box-sizing: border-box;
      width: 230px;
      height: 100px;
      background-color: #f8f8f8;

      .title {
        font-size: 42px;
        font-weight: bold;
        line-height: 100px;
        text-align: center;
      }
    }
  }
}
.screen-style {
  width: 100%;
  height: 70px;
  text-align: center;
  line-height: 70px;
  margin-top: 10px;
  margin-bottom: 10px;
}
.grid-style {
  width: 100%;
  height: 70px;
  text-align: center;
  line-height: 70px;
  background-color: #2eabff;
  margin-top: 10px;
  margin-bottom: 10px;
}
.grid-style-free {
  width: 100%;
  height: 70px;
  text-align: center;
  line-height: 70px;
  background-color: #2fff00;
  margin-top: 10px;
  margin-bottom: 10px;
}
.grid-style-used {
  width: 100%;
  height: 70px;
  text-align: center;
  line-height: 70px;
  background-color: #ff2e4d;
  margin-top: 10px;
  margin-bottom: 10px;
}
</style>