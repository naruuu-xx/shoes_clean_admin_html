<template>
  <div>
    <a-button @click="handleSynchronize" type="primary" icon="reload">同步机柜的格子情况到Redis</a-button>
  </div>
</template>

<script>
import {httpAction} from "../../../api/manage";

export default {
  name: "reSynchronizeGrid",
  data(){
    return {

    }
  },
  created() {
  },
  methods: {
    handleSynchronize(){
      httpAction("/shoes/shoeLocker/reSynchronizeGridToRedisByAll", null, "post").then((res) => {
        if (res.success) {
          this.$message.success(res.message);
        } else {
          this.$message.success(res.message);
        }
      })
    }
  }
}
</script>

<style scoped>

</style>