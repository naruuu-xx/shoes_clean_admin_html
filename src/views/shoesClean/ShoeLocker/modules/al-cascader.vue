<template>
  <div>
    <a-cascader
      v-model="select"
      :options="data"
      :load-data="loadData"
      change-on-select
      :disabled="disabled"
      :size="size"
      :placeholder="placeholder"
      :display-render="renderFormat"
      @change="handleChange"
    />
  </div>
</template>

<script>
import {pcaa} from 'area-data'
import util from "@views/shoesClean/ShoeLocker/modules/util";

export default {
  name: "AlCascader",
  props: {
    value: {
      type: Array,
      default: () => [],
    },
    level: {
      type: [Number, String],
      default: 3,
      validator: (val) => {
        return util.checkLevel(parseInt(val))
      },
    },
    dataType: {
      type: String,
      default: 'all',
      validator: (val) => {
        return util.oneOf(val, util.dataType)
      },
    },
    disabled: {
      type: Boolean,
      default: false,
    },
    size: {
      type: String,
      default: 'default',
    },
    placeholder: {
      type: String,
      default: '请选择',
    },
    renderFormat: {
      type: Function,
      default: ({ labels, selectedOptions }) => labels.join(' / '),
    },
  },
  data() {
    return {
      data: [],
      select: [],
      oldData: [],
    }
  },
  computed: {
    showLevel() {
      return parseInt(this.level)
    },
  },
  watch: {
    value(val) {
      if (this.canEmit(this.value)) this.setDefaultValue()
    },
    showLevel() {
      this.init()
      this.setDefaultValue()
    },
    dataType() {
      this.setDefaultValue()
    },
  },
  mounted() {
    this.init()
    if (this.canEmit(this.value)) this.setDefaultValue()
  },
  methods: {
    init() {
      const { showLevel } = this
      const proData = []
      for (const p in pcaa['86']) {
        const children = []
        if (showLevel > 1)
          for (const c in pcaa[p]) {
            const _children = []
            if (showLevel > 2)
              for (const co in pcaa[c]) {
                const v = { value: co, label: pcaa[c][co] } // 县区级
                _children.push(v)
              }
            const v = { value: c, label: pcaa[p][c] } // 市级
            if (_children.length > 0) v.children = _children
            children.push(v)
          }
        const proitem = { value: p, label: pcaa['86'][p] }
        if (children.length > 0) proitem.children = children
        proData.push(proitem)
      }
      this.data = proData
    },
    setDefaultValue() {
      const { value, showLevel } = this
      if (value[0]) {
        let select = []
        if (isNaN(parseInt(value[0]))) {
          let i = 0
          let code = '' // 编码
          while (value[i] && i <= this.showLevel) {
            if (i === 0)
              code = util.getIndex(pcaa['86'], value[0].name || value[0])
            else code = util.getIndex(pcaa[code], value[i].name || value[i])
            select.push(code)
            i++
          }
        } else select = value
        select = select.slice(0, showLevel)
        this.select = select
        const res = this.procesValue(this.select)
        this.oldData = res
        this.$emit('input', res)
        this.$emit('on-change', res)
      }
    },
    canEmit(res) {
      let ifEmit = false
      const { value, oldData } = this
      if (value && value.length !== 0) {
        const v = value[value.length - 1]
        const o = oldData[oldData.length - 1]
        if (typeof res[0] === 'string') ifEmit = v !== o
        else if (oldData.length === 0 || v.code !== o.code) ifEmit = true
      } else ifEmit = true
      return ifEmit
    },
    handleChange(resArr) {
      const res = this.procesValue(resArr)
      this.oldData = res
      this.$emit('input', res)
      this.$emit('on-change', res)
    },
    // 遗弃
    loadData(select) {
      const childData = []
      const target = select[select.length - 1]
      const currentLevel = select.length
      target.loading = true
      const key = target.value
      const childs = pcaa[key]
      setTimeout(() => {
        for (const c in childs) {
          const isLeaf = currentLevel >= this.showLevel - 1
          const childitem = {
            value: c,
            label: pcaa[key][c],
            isLeaf,
            loading: false,
          }
          childData.push(childitem)
        }
        target.children = childData
        target.loading = false
        this.data = [...this.data]
      }, 100)
    },
    procesValue(arr) {
      let i = 0
      const res = []
      while (arr[i]) {
        const name = i === 0 ? pcaa['86'][arr[i]] : pcaa[arr[i - 1]][arr[i]]
        let item
        switch (this.dataType) {
          case 'all':
            item = { code: arr[i], name }
            break
          case 'name':
            item = name
            break
          default:
            item = arr[i]
            break
        }
        res.push(item)
        i++
      }
      return res
    },
  },
}
</script>

<style scoped>

</style>