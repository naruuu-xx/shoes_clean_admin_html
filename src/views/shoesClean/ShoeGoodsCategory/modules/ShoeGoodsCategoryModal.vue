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
    <shoe-goods-category-form ref="realForm" @ok="submitCallback" :disabled="disableSubmit"></shoe-goods-category-form>
  </j-modal>
</template>

<script>

  import ShoeGoodsCategoryForm from './ShoeGoodsCategoryForm'
  import JTreeTable from '@comp/jeecg/JTreeTable.vue'
  import Vue from 'vue'
  export default {
    name: 'ShoeGoodsCategoryModal',
    components: {
      ShoeGoodsCategoryForm,
      JTreeTable
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