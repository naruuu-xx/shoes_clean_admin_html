<!--
 * @Descripttion: your project
 * @version: 1.0
 * @Author: yizhimao
 * @Date: 2023-03-29 14:24:33
 * @LastEditors: yizhimao
 * @LastEditTime: 2023-03-29 15:18:16
-->
<template>
  <j-modal
    :title="title"
    :width="width"
    :visible="visible"
    switchFullscreen
    @ok="handleOk"
    :okButtonProps="{ class:{'jee-hidden': disableSubmit} }"
    @cancel="handleCancel"
    :destroyOnClose="false"
    cancelText="关闭">
    <shoe-cooperative-client-Form ref="realForm" @ok="submitCallback" :disabled="disableSubmit"></shoe-cooperative-client-Form>
  </j-modal>
</template>

<script>

  import ShoeCooperativeClientForm from './ShoeCooperativeClientForm'
  export default {
    name: 'ShoeTimecardModal',
    components: {
      ShoeCooperativeClientForm
    },
    created() {
      console.log(888888888);
    },
    data () {
      return {
        title:'',
        width:900,
        visible: false,
        disableSubmit: false
      }
    },
    methods: {
      add () {
        this.visible=true
      },
      edit (record) {
        this.visible=true
        this.$nextTick(()=>{
          this.$refs.realForm.edit(record);
        })
      },
      close () {
        this.$refs.realForm.reset()
        this.$emit('close');
        this.visible = false;
      },
      handleOk () {
        this.$refs.realForm.submitForm();
      },
      submitCallback(){
        this.$emit('ok');
        this.visible = false;
      },
      handleCancel () {
        this.close()
      }
    }
  }
</script>

<style>
.scroll {
  height: 600px;
  overflow-y: scroll;
  width: 100%;
}
</style>