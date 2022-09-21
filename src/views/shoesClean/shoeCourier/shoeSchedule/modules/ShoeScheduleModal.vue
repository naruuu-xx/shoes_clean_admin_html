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
    <shoe-schedule-form ref="realForm" @ok="submitCallback" :disabled="disableSubmit"></shoe-schedule-form>
  </j-modal>
</template>

<script>

  import ShoeScheduleForm from './ShoeScheduleForm'
  export default {
    name: 'ShoeScheduleModal',
    components: {
      ShoeScheduleForm
    },
    data () {
      return {
        title:'',
        width:800,
        visible: false,
        disableSubmit: false
      }
    },
    methods: {
      add (courierId, scheduleList) {
        this.visible=true
        this.$nextTick(()=>{
          this.$refs.realForm.add(courierId, scheduleList);
        })
      },
      edit (record, scheduleList) {
        this.visible=true
        this.$nextTick(()=>{
          this.$refs.realForm.edit(record, scheduleList);
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