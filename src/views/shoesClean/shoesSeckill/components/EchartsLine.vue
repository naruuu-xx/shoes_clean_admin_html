<template>
  <div>
    <div id="main" style="width: 100%;height:400px;"></div>
    <a-empty v-show="!dataSource.y[0]"></a-empty>
  </div>
</template>

<script>

export default {
  data() {
    return {
      style: { stroke: '#fff', lineWidth: 1 },
      showChart: false,
      myChart: null
    };
  },
  props: {
    title: {
      type: String,
      default: ''
    },
    dataSource: {
      type: Object,
      default: () => ({
        x: [],
        y: []
      })
    },
    height: {
      type: Number,
      default: 400
    },
    alias: {
      type: String,
      default: 'ruku'
    },
    color: {
      type: Array,
      default: () => (
        ['city', ['#ff4d4f', '#ff7a45', '#ffa940', '#facc14', '#bae637', '#73d13d', '#36cfc9', '#40a9ff']]
      )
    },
  },
  mounted() {
    this.change()
  },
  watch:{
    dataSource: {
      handler(val,oldValue) {
        // if(val.y[0] && this.myChart)
        this.setEcharts()
      },
      //立刻执行handler
      immediate: true,
      deep: true
    },
  },
  computed: {
    
  },
  methods: {
    color16() {
      return '#' + Math.random().toString(16).substring(2, 6)
    },
    change() {
        // 基于准备好的dom，初始化echarts实例
      this.myChart = this.$echarts.init(document.getElementById('main'))
      
      this.setEcharts()
      // 根据页面大小自动响应图表大小
      window.addEventListener("resize", function () {
        this.myChart.resize();
      });
    },
    setEcharts(val = this.dataSource) {
      this.myChart.clear()
      let series = val.y.map((item,idx) => ({
        name: item.title,
        type: 'line',
        stack: 'Total'+idx,
        data: item.dataList
      }))
      let legendData = val.y.map(item => item.title)
      let option = {
        title: {
          text: ''
        },
        tooltip: {
          trigger: 'axis'
        },
        legend: {
          data: legendData
        },
        grid: {
          left: '3%',
          right: '4%',
          bottom: '3%',
          containLabel: true
        },
        toolbox: {
          feature: {
            saveAsImage: {}
          }
        },
        xAxis: {
          type: 'category',
          boundaryGap: false,
          data: val.x
        },
        yAxis: {
          type: 'value'
        },
        series
      };
      // 使用刚指定的配置项和数据显示图表。
      this.myChart.setOption(option)
    }
  }
};
</script>
