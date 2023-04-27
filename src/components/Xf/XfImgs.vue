<template>
  <div class="imgs">
    <div class="img" v-for="(url,idx) in images" :key="idx" @click="onClick('onClick',idx)">
      <img v-if="images.length" :src="url" alt="" srcset="" :style="{width: `${width}px`,height: `${height}px`}">
      <div class="img-close" @click.stop="onClick('close',idx)">
        <a-icon type="close" style="color: #fff"/>
      </div>
    </div>
    <a-modal :visible="previewVisible" :footer="null" @cancel="handleCancel()">
      <img alt="example" style="width: 100%" :src="previewImage"/>
    </a-modal>
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

  watch:{

  },

  computed: {
    
  },

  methods: {
    handleCancel() {
      this.previewVisible = false;
    },
    onClick(type,idx) {
      if(type == 'onClick') {
        this.previewImage = this.images[idx]
        this.previewVisible = true
        return
      }
      this.$emit(type,idx)
    }
  }
}
</script>

<style scoped lang="less">
  .imgs {
    display: flex;
    flex-wrap: wrap;
    overflow-y: auto;
    height: 220px;
  }
.img {
  position: relative;
  margin-right: 10px;
  margin-top: 10px;
  &:nth-child(-n+3) {
    margin-top: 0;
  }
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
