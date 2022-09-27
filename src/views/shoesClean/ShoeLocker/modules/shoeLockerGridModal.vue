<template>
  <j-modal
    :title="title"
    :width="width"
    :visible="visible"
    switchFullscreen
    @cancel="handleCancel"
    cancelText="关闭"
    :footer="null">

    <a-row :gutter="16" type="flex" justify="space-around" align="middle">
      <a-col :span="7"><div class="grid-style">1</div></a-col>
      <a-col :span="7"><div class="grid-style">9</div></a-col>
      <a-col :span="7"><div class="grid-style">14</div></a-col>
    </a-row>
    <a-row :gutter="16" type="flex" justify="space-around" align="middle">
      <a-col :span="7"><div class="grid-style">2</div></a-col>
      <a-col :span="7"><div class="screen-style" style="border-left: 2px solid #000000;border-top: 2px solid #000000;border-right: 2px solid #000000">&nbsp;</div></a-col>
      <a-col :span="7"><div class="grid-style">15</div></a-col>
    </a-row>
    <a-row :gutter="16" type="flex" justify="space-around" align="middle">
      <a-col :span="7"><div class="grid-style">3</div></a-col>
      <a-col :span="7"><div class="screen-style" style="border-left: 2px solid #000000;border-right: 2px solid #000000">屏幕</div></a-col>
      <a-col :span="7"><div class="grid-style">16</div></a-col>
    </a-row>
    <a-row :gutter="16" type="flex" justify="space-around" align="middle">
      <a-col :span="7"><div class="grid-style">4</div></a-col>
      <a-col :span="7"><div class="screen-style" style="border-left: 2px solid #000000;border-bottom: 2px solid #000000;border-right: 2px solid #000000">&nbsp;</div></a-col>
      <a-col :span="7"><div class="grid-style">17</div></a-col>
    </a-row>
    <a-row :gutter="16" type="flex" justify="space-around" align="middle">
      <a-col :span="7"><div class="grid-style">5</div></a-col>
      <a-col :span="7"><div class="grid-style">10</div></a-col>
      <a-col :span="7"><div class="grid-style">18</div></a-col>
    </a-row>
    <a-row :gutter="16" type="flex" justify="space-around" align="middle">
      <a-col :span="7"><div class="grid-style">6</div></a-col>
      <a-col :span="7"><div class="grid-style">11</div></a-col>
      <a-col :span="7"><div class="grid-style">19</div></a-col>
    </a-row>
    <a-row :gutter="16" type="flex" justify="space-around" align="middle">
      <a-col :span="7"><div class="grid-style">7</div></a-col>
      <a-col :span="7"><div class="grid-style">12</div></a-col>
      <a-col :span="7"><div class="grid-style">20</div></a-col>
    </a-row>
    <a-row :gutter="16" type="flex" justify="space-around" align="middle">
      <a-col :span="7"><div class="grid-style">8</div></a-col>
      <a-col :span="7"><div class="grid-style">13</div></a-col>
      <a-col :span="7"><div class="grid-style">21</div></a-col>
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
</style>