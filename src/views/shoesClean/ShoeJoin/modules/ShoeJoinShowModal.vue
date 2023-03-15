<template>
  <j-modal
    :title="title"
    :width="width"
    :visible="visible"
    switchFullscreen
    @ok="handleOk"
    :okButtonProps="{ class:{'jee-hidden': disableSubmit} }"
    @cancel="handleCancel"
    cancelText="关闭">
    <h2>姓名：{{this.name}}</h2>
    <h2>手机：{{this.phone}}</h2>
    <h2>来访原因：{{this.reason}}</h2>
    <h2>备注：{{this.note}}</h2>
  </j-modal>
</template>

<script>
import { defineComponent, ref } from 'vue';
import {httpAction} from "@api/manage";
  export default {
    name: 'ShoeJoinModal',
    components: {
    },

    data () {
      return {
        title:'',
        width:800,
        visible: false,
        disableSubmit: false,
        name:'',
        phone:'',
        reason:'',
        note:'',
      }
    },
    methods: {
     show(record){
       this.name=record.name;
       this.phone=record.phone;
       this.note=record.note;
       this.reason=record.reason;
       this.visible=true;
     },

      handleCancel(){
        this.visible=false;
      }

    }
  }
</script>