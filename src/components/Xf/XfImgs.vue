<template>
  <div class="imgs">
    <div class="img" v-for="(url,idx) in images" :key="idx" @click="onClick('onClick',idx)">
      <img :src="url" alt="" srcset="" :style="{width: `${width}px`,height: `${height}px`}">
      <div class="img-close" @click.stop="onClick('close',idx)">
        <a-icon type="close" style="color: #fff"/>
      </div>
    </div>
    
  </div>
</template>

<script>
export default {
  name: 'XfImgs',

  props: {
    // 下拉框总数据
    images: {
      type: Array,
      require: true
    },
    width: {
      type: Number,
      default: 180
    },
    height: {
      type: Number,
      default: 110
    }
  },

  data() {
    return {
      previewVisible:false,
      previewImage:''
    }
  },

  computed: {
    
  },

  methods: {
    handleCancel() {
      this.previewVisible = false;
    },
    onClick(type,idx) {
      // if(type == 'onClick') {
      //   this.previewImage = this.images[idx]
      //   this.previewVisible = true
      //   return
      // }
      this.$emit(type,idx)
    }
  }
}
</script>

<style scoped lang="less">
  .imgs {
    display: flex;
    flex-wrap: wrap;
    row-gap: 20px;
    column-gap: 30px;
    overflow-y: auto;
    max-height: 220px;
  }
.img {
  position: relative;
  margin-right: 10px;
  margin-top: 10px;

  &-close {
    position: absolute;
    top: 0;
    right: 0;
    padding: 4px;
    background: rgba(0, 0, 0, 0.49);
    line-height: 14px;
  }
}
</style>
