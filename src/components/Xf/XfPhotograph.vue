<template>
  <div class="photograph">
    <div style="margin-right: 34px;">
      <a-button @click="previewVisible = true" type="primary">拍照</a-button>
    </div>
    <xfImgs :images="images" @close="close" @onClick="onClickOut"></xfImgs>
    <!-- :closable="false" -->
    <j-modal
    isNoTitle
   
    :maskClosable="false"
    :width="1200"
    :visible="previewVisible"
    @cancel="handleCancel"
    :footer="null"
    cancelText="关闭">
    <div class="top">
      <div class="back" @click="handleCancel">
        <a-icon type="left" />
        <span>返回</span>
      </div>
      <!-- <a-button type="primary" @click="onSubmit">提交</a-button> -->
    </div>
    <Photograph ref="TakePhotos" @refreshDataList="refreshDataList"></Photograph>
    <xfImgs :images="images" @close="close" @onClick="onClick" style="margin-top: 12px;"></xfImgs>
    <a-modal :visible="imgVisible" :footer="null" @cancel="handleImgCancel()" width="1000px">
      <img alt="example" style="width: 100%" :src="previewImage"/>
    </a-modal>
  </j-modal>
  <a-modal :visible="outImgVisible" :footer="null" @cancel="handleImgCancel()" width="1000px">
      <img alt="example" style="width: 100%" :src="previewImage"/>
  </a-modal>
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
      images:[],
      previewVisible: false,
      imgVisible:false,
      outImgVisible: false,
      previewImage:''
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
    },
  },
  computed:{
    
  },
  methods: {
    onSubmit() {
      
    },
    handleImgCancel() {
      this.imgVisible = false
      this.outImgVisible = false
    },
    handleCancel() {
      this.previewVisible = false
      this.$refs.TakePhotos.removeKeydown()
    },
    close(idx) {
      this.imgs.splice(idx,1)
    },
    onClick(idx) {
      this.previewImage = this.images[idx]
      this.imgVisible = true
    },
    onClickOut(idx) {
      console.log(777);
      this.previewImage = this.images[idx]
      this.outImgVisible = true
    },
    submit() {
      return this.uploadImgs(this.imgs)
    },
    uploadImgs(files) {
      return new Promise((resolve, reject) => {
        const imgs = files.map((item,idx) => {
          let isFile = item.file instanceof FormData  // 说明没上传,是个文件
          return isFile ? uploadImg(item.file) : Promise.resolve({result:item.file})
        })
				Promise.all(imgs).then((res,idx) => {
					resolve(res.map(item => ({
            file: item.result,
            image: item.result
          })))
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
.back {
  display: flex;
  align-items: center;
  font-size: 18px;
  cursor: pointer;
  
}
.top {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 12px;
}

.photograph {
  display: flex;
}
</style>