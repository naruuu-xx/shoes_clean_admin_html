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
    <div class="scroll">
      <shoe-timecard-form ref="realForm" @ok="submitCallback" :disabled="disableSubmit"></shoe-timecard-form>
    </div>
  </j-modal>
</template>

<script>

  import ShoeTimecardForm from './ShoeTimecardForm'
  export default {
    name: 'ShoeTimecardModal',
    components: {
      ShoeTimecardForm
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
        this.$nextTick(()=>{
          this.$refs.realForm.add();
        })
      },
      edit (record) {
        this.visible=true
        this.$nextTick(()=>{
          this.$refs.realForm.edit(record);
        })
      },
      close () {
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