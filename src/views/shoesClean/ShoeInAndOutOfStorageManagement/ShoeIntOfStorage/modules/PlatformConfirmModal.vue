<template>
  <j-modal
    title="快递来源"
    :width="600"
    :visible="visible"
    @cancel="handleCancel"
    :footer="null"
    wrapClassName="full-modal">
    <div>
      <a-row>
        <a-col :span="24">
          <p>来源：{{ model.platformName }}</p>
        </a-col>
      </a-row>
      <a-row>
        <a-col :span="24">
          <p>双数：{{ model.shoeNum }}</p>
        </a-col>
      </a-row>
      <a-row>
        <a-col :span="24">
          <p>姓名：{{ model.name }}</p>
        </a-col>
      </a-row>
      <a-row>
        <a-col :span="24">
          <p>手机号：{{ model.phone }}</p>
        </a-col>
      </a-row>
      <a-row>
        <a-col :span="24">
          <p>地址：{{ model.noteAddress }}</p>
        </a-col>
      </a-row>
      <div style="display: flex;justify-content: center;"><a-button @click="rk">入库</a-button></div>
    </div>
  </j-modal>
</template>

<script>
export default {
  name: "PlatformConfirmModal",
  data () {
    return {
      visible: false,
      model: {},
      platformList: [],
    }
  },
  methods: {
    show(arrayList) {
      this.visible = true;
      this.platformList = arrayList;
      this.model = arrayList[0];
    },
    handleCancel() {
      this.visible = false;
      this.model = {};
    },
    rk() {
      this.visible = false
      this.$emit('rk',this.platformList)
    }
  }
}
</script>

<style scoped>

</style>