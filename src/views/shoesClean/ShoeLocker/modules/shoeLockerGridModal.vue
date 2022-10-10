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
      <a-col :span="7"><div class="grid-style">1</div></a-col>
      <a-col :span="7"><div class="grid-style">9</div></a-col>
      <a-col :span="7"><div class="grid-style">17</div></a-col>
    </a-row>
    <a-row :gutter="16" type="flex" justify="space-around" align="middle">
      <a-col :span="7"><div class="grid-style">2</div></a-col>
      <a-col :span="7"><div class="screen-style" style="border-left: 2px solid #000000;border-top: 2px solid #000000;border-right: 2px solid #000000">&nbsp;</div></a-col>
      <a-col :span="7"><div class="grid-style">18</div></a-col>
    </a-row>
    <a-row :gutter="16" type="flex" justify="space-around" align="middle">
      <a-col :span="7"><div class="grid-style">3</div></a-col>
      <a-col :span="7"><div class="screen-style" style="border-left: 2px solid #000000;border-right: 2px solid #000000">屏幕</div></a-col>
      <a-col :span="7"><div class="grid-style">19</div></a-col>
    </a-row>
    <a-row :gutter="16" type="flex" justify="space-around" align="middle">
      <a-col :span="7"><div class="grid-style">4</div></a-col>
      <a-col :span="7"><div class="screen-style" style="border-left: 2px solid #000000;border-bottom: 2px solid #000000;border-right: 2px solid #000000">&nbsp;</div></a-col>
      <a-col :span="7"><div class="grid-style">20</div></a-col>
    </a-row>
    <a-row :gutter="16" type="flex" justify="space-around" align="middle">
      <a-col :span="7"><div class="grid-style">5</div></a-col>
      <a-col :span="7"><div class="grid-style">13</div></a-col>
      <a-col :span="7"><div class="grid-style">21</div></a-col>
    </a-row>
    <a-row :gutter="16" type="flex" justify="space-around" align="middle">
      <a-col :span="7"><div class="grid-style">6</div></a-col>
      <a-col :span="7"><div class="grid-style">14</div></a-col>
      <a-col :span="7"><div class="grid-style">22</div></a-col>
    </a-row>
    <a-row :gutter="16" type="flex" justify="space-around" align="middle">
      <a-col :span="7"><div class="grid-style">7</div></a-col>
      <a-col :span="7"><div class="grid-style">15</div></a-col>
      <a-col :span="7"><div class="grid-style">23</div></a-col>
    </a-row>
    <a-row :gutter="16" type="flex" justify="space-around" align="middle">
      <a-col :span="7"><div class="grid-style">8</div></a-col>
      <a-col :span="7"><div class="grid-style">16</div></a-col>
      <a-col :span="7"><div class="grid-style">24</div></a-col>
    </a-row>
  </j-modal>
</template>

<script>
export default {
  name: "shoeLockerGridModal",
  data () {
    return {
      title: '快递柜格子展示',
      width: 600,
      visible: false,
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
      this.visible = true;
    },
    handleCancel () {
      this.visible = false;
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