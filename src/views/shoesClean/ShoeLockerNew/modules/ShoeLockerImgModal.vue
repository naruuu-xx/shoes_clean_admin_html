<template>
  <a-spin :spinning="confirmLoading">
    <j-modal
      :title="title"
      :width="width"
      :visible="visible"
      switchFullscreen
      @ok="handleOk"
      :okButtonProps="{ class:{'jee-hidden': disableSubmit} }"
      @cancel="handleCancel"
      cancelText="关闭">
      <a-form-model ref="form" :model="form">
        <a-row>
          <a-col :span="24">
            <a-form-model-item label="场景图" prop="image">
              <j-image-upload v-model="form.image"></j-image-upload>
            </a-form-model-item>
          </a-col>
        </a-row>
      </a-form-model>
    </j-modal>
  </a-spin>
</template>

<script>
  import {httpAction} from '@/api/manage'
  export default {
    name: 'ShoeLockerImgModal',
    data () {
      return {
        form:{
          image:'',
          lockerId: 0
        },
        title:'',
        width:400,
        visible: false,
        disableSubmit: false,
        confirmLoading:false
      }
    },
    methods: {
      show({image,lockerId}) {
        this.form = {
          image,
          lockerId
        }
        console.log(999,this.form);
        this.visible = true;
      },
      close () {
        this.$emit('close');
        this.visible = false;
      },
      handleOk () {
        this.confirmLoading = true
        httpAction('/shoes/shoeLocker/setLocationImages', this.form, 'post').then((res) => {
            if (res.success) {
              this.$message.success(res.message);
              this.$emit('ok');
              this.visible = false;
            } else {
              this.$message.warning(res.message);
            }
          }).finally(() => {
            this.confirmLoading = false;
          })
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