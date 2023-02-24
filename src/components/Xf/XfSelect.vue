<template>
  <a-select
    v-model="value"
    :placeholder="placeholder"
    :allow-clear="true"
    @change="chooseOption"
    class="width195"
    showSearch
    :filter-option="false"
    @search="handleSearch"
  >
    <div slot="dropdownRender" slot-scope="menu">
      <v-nodes :vnodes="menu" />

      <a-divider style="margin: 4px 0" />

      <div class="footer">
        <div @mousedown="e => e.preventDefault()" @click="changePage(0)" style="cursor:pointer">
          上一页
        </div>

        <a-spin :spinning="spinning" class="my-spin" @mousedown="e => e.preventDefault()" />

        <div v-if="total && pageSize && page">{{ nowPage }}/{{ maxPage }}</div>

        <div @mousedown="e => e.preventDefault()" @click="changePage(1)" style="cursor:pointer">
          下一页
        </div>
      </div>
    </div>

    <a-select-option v-for="(item, index) in selectList" :key="index" :value="item[valueKey]"
      >{{ item[labelKey] }}
    </a-select-option>
  </a-select>
</template>

<script>
export default {
  name: 'XfSelect',

  props: {
    // 下拉框总数据

    list: {
      type: Array,
      require: true
    },

    total: {
      type: Number,
      require: true
    },

    page: {
      type: Number,
      require: true
    },

    pageSize: {
      type: Number
    },

    // 提示
    placeholder: {
      type: String,
      default: '请选择'
    },

    // 下拉框显示值
    labelKey: {
      type: String
    },

    // 下拉框value
    valueKey: {
      type: String
    },

    spinning: {
      type: Boolean,
      default: false
    },

    // 默认值

    value: {

      type: String

    }
  },

  components: {
    VNodes: {
      functional: true,

      render: (h, ctx) => ctx.props.vnodes
    }
  },

  data() {
    return {
      value: undefined
    }
  },

  computed: {
    selectList() {
      return this.list
    },

    maxPage() {
      return Math.ceil(this.total / this.pageSize)
    },

    nowPage() {
      return this.page
    }
  },

  methods: {
    // 清空数据

    clearValue() {
      this.value = ''
    },

    // 换页事件，0切换到上一页，1切换到下一页

    changePage(status) {
      this.$emit('changePage', status)
    },

    // 选择下拉框时进行父传子

    chooseOption(value) {
      this.$emit('change', value)
    },

    handleSearch(value) {
      this.$emit('handleSearch', value)
    }
  }
}
</script>

<style scoped lang="less">
  .width195 {
    width: 195px;
  }
.footer {
  position: relative;

  display: flex;

  justify-content: space-between;
  align-items: center;
  padding: 5px 5px 10px;
  
}
.my-spin {
  position: absolute;
  top: 50%;
  left: 50%;
  transform: translate(-50%, -50%);
}
</style>
