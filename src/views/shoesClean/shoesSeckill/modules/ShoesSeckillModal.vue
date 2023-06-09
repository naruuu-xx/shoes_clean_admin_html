<template>
  <j-modal
    :title="title"
    :width="width"
    :visible="visible"
    switchFullscreen
    @ok="handleOk"
    :okButtonProps="{ class:{'jee-hidden': disabled} }"
    @cancel="handleCancel"
    cancelText="关闭">
    <ShoesSeckillForm ref="realForm" @ok="submitCallback" :disabled="disabled"></ShoesSeckillForm>
  </j-modal>
</template>

<script>

  import ShoesSeckillForm from './ShoesSeckillForm'
  export default {
    name: 'ShoesSeckillModal',
    components: {
      ShoesSeckillForm
    },
    props: {

      //表单禁用
      disabled: {
        type: Boolean,
        default: false,
        required: false
      }
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
      add () {
        this.visible=true
        this.$nextTick(()=>{
          this.$refs.realForm.add();
        })
      },
      edit (record) {

        console.log("edit.."+record)
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