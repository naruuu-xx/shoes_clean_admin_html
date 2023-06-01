<!--
 * @Descripttion: your project
 * @version: 1.0
 * @Author: yizhimao
 * @Date: 2023-05-10 09:37:00
 * @LastEditors: yizhimao
 * @LastEditTime: 2023-05-30 10:18:00
-->
<!--  -->
<template>
   <div class="btns">
      <div class="btns-item" @click="onTab(idx)" :class="{active: idx == tabIndex}" v-for="(item,idx) in filterList" :key="idx">
        <template v-if="item.type == 'select'">
          {{ item.label }}
          <xf-select
          style="width: 220px;margin-left: 8px;"
          isInternalData
          mode="multiple"
          v-model="item.value"
          @change="change"
          :url='`/ShoeSeckill/shoeSeckill/getSeckillList`'
        >
        </xf-select>
        </template>
        <template v-else>
          {{ item.label }}
        </template>
      </div>
    </div>
</template>

<script>
import XfSelect from '@/components/Xf/XfSelect'
export default {
  //import引入的组件需要注入到对象中才能使用
  components: {
    XfSelect
  },
  props:{
    filterList: {
      type:Array,
      default:() =>([])
    },
  },
  data() {
    return {
      tabIndex:0
    };
  },
  computed: {
  },
  watch: {
  },
  methods: {
    
    // 点击tab
    onTab(idx) {
      if(this.tabIndex == idx) {
        return
      }
      this.tabIndex = idx
      let obj = this.filterList[idx]
      this.$emit('change',{dataType:obj.dataType,setList:JSON.stringify(obj.value)})
    },
    change() {
      let obj = this.filterList[this.tabIndex]
      this.$emit('change',{dataType:obj.dataType,setList:JSON.stringify(obj.value)})
    }
  },
  created() {

  },
  mounted() {

  },
}
</script>
<style lang='less' scoped>
.active {
  color: #3b98ff !important;
}
.btns {
  display: flex;
  align-items: center;
  padding: 4px 2px;
  border-bottom: 1px #ddd solid;
  &-item {
    margin-right: 40px;
    cursor: pointer;
    display: flex;
    align-items: center;
  }
}

</style>