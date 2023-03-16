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
    <h2>备注</h2>
    <a-textarea v-model="model.note" placeholder="输入备注" :rows="4" />
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
        model:{}
      }
    },
    methods: {
     show(record){
       this.model.note=record.note;
       this.model.joinId=record.joinId;
       this.visible=true;
     },
      handleOk(){

        let data = {
          "note": this.model.note,
          "joinId": this.model.joinId,

        }

        httpAction("/shoeJoin/update", data, 'put').then((res) => {
          if (res.code === 200) {
            this.$message.success("备注成功")
            this.visible = false;
            this.$emit('ok');
          } else {
            this.$message.warning(res.message);
          }
        })
      },
      handleCancel(){
        this.visible=false;
       this.model.note=''
      }

    }
  }
</script>