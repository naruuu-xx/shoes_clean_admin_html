<template>
  <j-modal
    :title="title"
    :width="width"
    :visible="visible"
    switchFullscreen
    @cancel="handleCancel"
    cancelText="关闭"
    :footer="null">

<!--    <a-row :gutter="16" type="flex" justify="space-around" align="middle" v-for="(item, index) in list" v-if="item.number === 1 || item.number === 3 || item.number === 4 || item.number === 5 || item.number === 6 || item.number === 7 || item.number === 8">-->
<!--      <a-col :span="7"><div class="grid-style">{{item.number}}</div></a-col>-->
<!--      <a-col :span="7"><div class="grid-style">{{item.number}}</div></a-col>-->
<!--      <a-col :span="7"><div class="grid-style">{{item.number}}</div></a-col>-->
<!--    </a-row>-->

<!--    <div v-for="(item, index) in list">-->
<!--      <a-row :gutter="16" type="flex" justify="space-around" align="middle" v-if="item.number === 1">-->
<!--        <a-col :span="7"><div class="grid-style" v-if="item.number === 1">{{item.number}}</div></a-col>-->
<!--        <a-col :span="7"><div class="grid-style" v-if="item.number === 9">{{item.number}}</div></a-col>-->
<!--        <a-col :span="7"><div class="grid-style" v-if="item.number === 14">{{item.number}}</div></a-col>-->
<!--      </a-row>-->
<!--    </div>-->



<!--    <a-row :gutter="16" type="flex" justify="space-around" align="middle" v-for="(item, index) in list" v-if="item.number === 2">-->
<!--      <a-col :span="7"><div class="grid-style" v-if="item.number === 2">{{item.number}}</div></a-col>-->
<!--      <a-col :span="7"><div class="grid-style">{{item.number}}</div></a-col>-->
<!--      <a-col :span="7"><div class="grid-style" v-if="item.number === 1">{{item.number}}</div></a-col>-->
<!--    </a-row>-->

    <a-row :gutter="16" type="flex" justify="space-around" align="middle">
      <a-col :span="7">
<!--        <div class="grid-style" @click="openDoorByDevicenum(1)"><span>1</span></div><a-button>打开柜门</a-button></a-col>-->
        <div class="grid-style" @click="openDoorByDevicenum(1)">
          <span>1（打开柜门）</span>
<!--          <a-button>打开柜门</a-button>-->
        </div>

      </a-col>
      <a-col :span="7"><div class="grid-style" @click="openDoorByDevicenum(9)">9（打开柜门）</div></a-col>
      <a-col :span="7"><div class="grid-style" @click="openDoorByDevicenum(17)">17（打开柜门）</div></a-col>
    </a-row>
    <a-row :gutter="16" type="flex" justify="space-around" align="middle">
      <a-col :span="7"><div class="grid-style" @click="openDoorByDevicenum(2)">2（打开柜门）</div></a-col>
      <a-col :span="7"><div class="screen-style" style="border-left: 2px solid #000000;border-top: 2px solid #000000;border-right: 2px solid #000000">&nbsp;</div></a-col>
      <a-col :span="7"><div class="grid-style" @click="openDoorByDevicenum(18)">18（打开柜门）</div></a-col>
    </a-row>
    <a-row :gutter="16" type="flex" justify="space-around" align="middle">
      <a-col :span="7"><div class="grid-style" @click="openDoorByDevicenum(3)">3（打开柜门）</div></a-col>
      <a-col :span="7"><div class="screen-style" style="border-left: 2px solid #000000;border-right: 2px solid #000000">屏幕</div></a-col>
      <a-col :span="7"><div class="grid-style" @click="openDoorByDevicenum(19)">19（打开柜门）</div></a-col>
    </a-row>
    <a-row :gutter="16" type="flex" justify="space-around" align="middle">
      <a-col :span="7"><div class="grid-style" @click="openDoorByDevicenum(4)">4（打开柜门）</div></a-col>
      <a-col :span="7"><div class="screen-style" style="border-left: 2px solid #000000;border-bottom: 2px solid #000000;border-right: 2px solid #000000">&nbsp;</div></a-col>
      <a-col :span="7"><div class="grid-style" @click="openDoorByDevicenum(20)">20（打开柜门）</div></a-col>
    </a-row>
    <a-row :gutter="16" type="flex" justify="space-around" align="middle">
      <a-col :span="7"><div class="grid-style" @click="openDoorByDevicenum(5)">5（打开柜门）</div></a-col>
      <a-col :span="7"><div class="grid-style" @click="openDoorByDevicenum(13)">13（打开柜门）</div></a-col>
      <a-col :span="7"><div class="grid-style" @click="openDoorByDevicenum(21)">21（打开柜门）</div></a-col>
    </a-row>
    <a-row :gutter="16" type="flex" justify="space-around" align="middle">
      <a-col :span="7"><div class="grid-style" @click="openDoorByDevicenum(6)">6（打开柜门）</div></a-col>
      <a-col :span="7"><div class="grid-style" @click="openDoorByDevicenum(14)">14（打开柜门）</div></a-col>
      <a-col :span="7"><div class="grid-style" @click="openDoorByDevicenum(22)">22（打开柜门）</div></a-col>
    </a-row>
    <a-row :gutter="16" type="flex" justify="space-around" align="middle">
      <a-col :span="7"><div class="grid-style" @click="openDoorByDevicenum(7)">7（打开柜门）</div></a-col>
      <a-col :span="7"><div class="grid-style" @click="openDoorByDevicenum(15)">15（打开柜门）</div></a-col>
      <a-col :span="7"><div class="grid-style" @click="openDoorByDevicenum(23)">23（打开柜门）</div></a-col>
    </a-row>
    <a-row :gutter="16" type="flex" justify="space-around" align="middle">
      <a-col :span="7"><div class="grid-style" @click="openDoorByDevicenum(8)">8（打开柜门）</div></a-col>
      <a-col :span="7"><div class="grid-style" @click="openDoorByDevicenum(16)">16（打开柜门）</div></a-col>
      <a-col :span="7"><div class="grid-style" @click="openDoorByDevicenum(24)">24（打开柜门）</div></a-col>
    </a-row>
  </j-modal>
</template>

<script>
import {httpAction} from "../../../../api/manage";

export default {
  name: "shoeLockerGridModal",
  data () {
    return {
      title: '快递柜格子展示',
      width: 600,
      visible: false,
      devicenum: "",
      list: [
        {number: 1, state: 1},
        {number: 2, state: 1},
        {number: 3, state: 1},
        {number: 4, state: 1},
        {number: 5, state: 1},
        {number: 6, state: 1},
        {number: 7, state: 1},
        {number: 8, state: 1},
        {number: 9, state: 1},
        {number: 10, state: 1},
        {number: 11, state: 1},
        {number: 12, state: 1},
        {number: 13, state: 1},
        {number: 14, state: 1},
        {number: 15, state: 1},
        {number: 16, state: 1},
        {number: 17, state: 1},
        {number: 18, state: 1},
        {number: 19, state: 1},
        {number: 20, state: 1},
        {number: 21, state: 1},
      ]
    }
  },
  methods: {
    show(record){
      this.devicenum = record.lockerCode;
      this.visible = true;
    },
    handleCancel () {
      this.visible = false;
    },
    openDoorByDevicenum(openNum){
      const that = this;

      let data = {
        "devicenum":this.devicenum,
        "openNum":openNum,
        "openType":0
      }

      httpAction("/api/IoT/openDoorByDevicenum", data, 'post').then((res)=>{
        let json = JSON.parse(res);
        if (json.code === 0) {
          that.$message.success("开门成功")
        } else {
          that.$message.warning(json.message);
        }
      })
    }
  }
}
</script>

<style scoped>
 .screen-style{
   width: 100%;
   height: 70px;
   text-align:center;
   line-height:70px;
   margin-top: 10px;
   margin-bottom: 10px;
 }
 .grid-style{
   width: 100%;
   height: 70px;
   text-align:center;
   line-height:70px;
   background-color: #2eabff;
   margin-top: 10px;
   margin-bottom: 10px;
 }
 .grid-style-free{
   width: 100%;
   height: 70px;
   text-align:center;
   line-height:70px;
   background-color: #2fff00;
   margin-top: 10px;
   margin-bottom: 10px;
 }
 .grid-style-used{
   width: 100%;
   height: 70px;
   text-align:center;
   line-height:70px;
   background-color: #ff2e4d;
   margin-top: 10px;
   margin-bottom: 10px;
 }
</style>