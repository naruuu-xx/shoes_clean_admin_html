<template>
  <a-select
    v-model="selectVlaue"
    :placeholder="placeholder"
    :allow-clear="allowClear"
    @change="chooseOption"
    class="width195"
    showSearch
    :filter-option="false"
    @search="handleSearch"
    :mode="mode"
    :disabled="disabled"
  >
    <div slot="dropdownRender" slot-scope="menu">
      <a-spin :spinning="spinning" class="my-spin" @mousedown="e => e.preventDefault()" >
        <v-nodes :vnodes="menu" />

        <a-divider style="margin: 4px 0" />

        <div class="footer">
          <a-button @mousedown="e => e.preventDefault()" @click="changePage(-1)" type="primary" size="small" :disabled="spinning || page == 1">上一页</a-button>
          <div v-if="total && pageSize && page">{{ nowPage }}/{{ maxPage }}</div>
          <a-button @mousedown="e => e.preventDefault()" @click="changePage(1)" type="primary" size="small" :disabled="spinning || page == maxPage">下一页</a-button>
        </div>
      </a-spin>
    </div>

    <a-select-option v-for="(item, index) in selectList" :key="item[valueKey]" :value="item[valueKey]"
    >{{ item[labelKey] }}
    </a-select-option>
  </a-select>
</template>

<script>
import debounce from "@/utils/debounce"
import {getAction} from "@/api/manage";
export default {
  name: 'XfSelect',

  props: {
    // 下拉框总数据
    list: {
      type: Array,
      require: true
    },

    pageSize: {
      type: Number,
      default: 10
    },

    // 提示
    placeholder: {
      type: String,
      default: '请选择'
    },

    // 下拉框显示值
    labelKey: {
      type: String,
      default: 'label'
    },

    // 下拉框value
    valueKey: {
      type: String,
      default: 'value'
    },

    // 默认值
    value: {
      type: [String,Number,Array],
      default: ''
    },
    // 请求地址
    url: {
      type: String,
      require: true
    },
    // 搜索过滤的字段
    searchKey: {
      type: String,
      default: 'name'
    },
    // 是否可以清除
    allowClear: {
      type: Boolean,
      default: false
    },
    // 默认模式
    mode: {
      type: String,
      default: 'default' // 'default' | 'multiple' | 'tags' | 'combobox'
    },
    disabled:{
      type: Boolean,
      default: false
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
      selectVlaue: undefined,
      total: 0,
      page: 1,
      spinning: false
    }
  },

  watch:{
    url: {
      handler(val,oldValue) {
        this.getList()
      },
      //立刻执行handler
      immediate: true
    },
    value: {
      handler(value, oldValue) {
        this.selectVlaue = value
      },
      deep: true,
      immediate: true
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
    // 换页事件，-1切换到上一页，1切换到下一页
    changePage(val) {
      this.page += val
      this.getList()
    },

    // 选择下拉框时进行父传子
    chooseOption(value) {
      this.$emit('input', value)
      this.$emit('change', value)
    },

    handleSearch(value) {
      debounce(() => {
        this.page = 1
        this.getList(value)
      },1000,false)
    },
    // 获取数据
    getList(val = '') {
      this.spinning = true
      let form = {
        pageNo: this.page,
        pageSize: this.pageSize,
        [this.searchKey]: val
      }
      getAction(this.url, form).then((res) => {
        if (res.success) {
          this.page = res.result.current || 1
          this.total = res.result.total || 1
          this.$emit('changeList',res.result)
        }
      }).finally(() => {
        this.spinning = false
      })
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
  /* position: absolute;
  top: 50%;
  left: 50%;
  transform: translate(-50%, -50%); */
}
</style>
