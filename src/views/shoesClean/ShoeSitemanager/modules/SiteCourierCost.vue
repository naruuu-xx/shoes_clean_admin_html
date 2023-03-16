<template>
  <j-modal
    :title="title"
    :width="width"
    :visible="visible"
    switchFullscreen
    @cancel="handleCancel"
    cancelText="关闭"
    :footer="null"
  >
    <div>
      <a-row>
        <a-col :span="24"><p>（1）取鞋配送费</p></a-col>
      </a-row>
      <a-row>
        <a-col :span="24"><p>同一订单第一双鞋配送费 {{ model.courierCost }} 元，</p></a-col>
        <a-col :span="24"><p>每增加一双鞋增加配送费为 {{ model.courierCostIncrease }} 元。</p></a-col>
      </a-row>
      <a-row>
        <a-col :span="24"><p>（2）送鞋配送费</p></a-col>
      </a-row>
      <a-row>
        <a-col :span="24"><p>一双鞋配送费 {{ model.courierSendCost }} 元。</p></a-col>
      </a-row>
    </div>
  </j-modal>
</template>

<script>
import {httpAction} from "@api/manage";

export default {
  name: "SiteCourierCost",
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
      model:{
        courierCost:"",
        courierCostIncrease:"",
        courierSendCost:"",
      },
      title: '站点配送费详情',
      width: 400,
      visible: false,
      lockerId: "",
      validatorRules: {

      },
      labelCol: {
        xs: { span: 24 },
        sm: { span: 5 },
      },
      wrapperCol: {
        xs: { span: 24 },
        sm: { span: 16 },
      },
    }
  },
  computed: {
    formDisabled(){
      return this.disabled
    },
  },
  methods: {
    show(record) {
      Object.assign(this.model, record);
      this.model.courierCost = record.courierCost;
      this.model.courierCostIncrease = record.courierCostIncrease;
      this.model.courierSendCost = record.courierSendCost;
      this.visible = true;
    },
    handleCancel() {
      this.visible = false;
    },
  }
}
</script>

<style scoped>

</style>