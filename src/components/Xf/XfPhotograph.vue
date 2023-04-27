<template>
  <div class="photograph">
    <div style="margin-right: 34px;">
      <Photograph ref="TakePhotos" @refreshDataList="refreshDataList"></Photograph>
    </div>
    <xfImgs :images="images" @close="close"></xfImgs>
  </div>
</template>

<script>
import Photograph from '@/components/Xf/Photograph'
import XfImgs from '@/components/Xf/XfImgs'
import { uploadImg } from '@/api/api'

export default {
  name: "XfPhotograph",
  components:{
    Photograph,
    XfImgs
  },
  props:{
    photographImg: {
      type: Array,
      default: () => []
    }
  },
  data() {
    return {
      img:'',
      imgs:[],
      images:[]
    }
  },
  created() {
    
  },
  watch:{
    imgs:{
      handler(val) {
        this.images = this.imgs.map(({image}) => image)
      },
      deep:true
    },
    photographImg: {
      handler(val) {
        this.imgs = val.map(obj => Object.assign({},obj))
      },
      deep:true
    }
  },
  computed:{
    
  },
  methods: {
    close(idx) {
      this.imgs.splice(idx,1)
    },
    submit() {
      return this.uploadImgs(this.imgs)
    },
    uploadImgs(files) {
      return new Promise((resolve, reject) => {
        const imgs = files.map((item,idx) => uploadImg(item.file)).filter(item => item)
				Promise.all(imgs).then(res => {
					resolve(res.map(item => item.result))
				}).catch(err => {
          reject(err)
				})
			});
    },
    refreshDataList(val) {
      this.imgs.push(val)
    },
  }
}
</script>

<style scoped lang="less">

.photograph {
  display: flex;
}
</style>