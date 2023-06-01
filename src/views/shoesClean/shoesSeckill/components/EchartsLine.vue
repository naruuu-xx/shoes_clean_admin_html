<template>
  <div>
    <div id="main" style="width: 100%;height:400px;"></div>
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
        // this.myChart && this.myChart.showLoading();
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
      // this.myChart.hideLoading();
      if(!val.y[0]) {
          let option = {
            title: {
                text: ' {a|}',
                x: 'center',
                y: 'center',
                subtext:'暂无数据',
                itemGap: -20,
                textStyle: {
                    rich: {
                      a: {
                        color: '#000',
                        fontSize: '16',
                        height: 80,
                        width: 160,
                        backgroundColor: {
                          image: 'data:image/svg+xml;base64,PHN2ZyB3aWR0aD0iNjQiIGhlaWdodD0iNDEiIHZpZXdCb3g9IjAgMCA2NCA0MSIgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIj4NCiAgPGcgdHJhbnNmb3JtPSJ0cmFuc2xhdGUoMCAxKSIgZmlsbD0ibm9uZSIgZmlsbFJ1bGU9ImV2ZW5vZGQiPg0KICAgIDxlbGxpcHNlIGZpbGw9IiNkZGQiIGN4PSIzMiIgY3k9IjMzIiByeD0iMzIiIHJ5PSI3IiAvPg0KICAgIDxnIGZpbGxSdWxlPSJub256ZXJvIiBzdHJva2U9IiM5OTkiPg0KICAgICAgPHBhdGgNCiAgICAgICAgZD0iTTU1IDEyLjc2TDQ0Ljg1NCAxLjI1OEM0NC4zNjcuNDc0IDQzLjY1NiAwIDQyLjkwNyAwSDIxLjA5M2MtLjc0OSAwLTEuNDYuNDc0LTEuOTQ3IDEuMjU3TDkgMTIuNzYxVjIyaDQ2di05LjI0eiIgLz4NCiAgICAgIDxwYXRoDQogICAgICAgIGQ9Ik00MS42MTMgMTUuOTMxYzAtMS42MDUuOTk0LTIuOTMgMi4yMjctMi45MzFINTV2MTguMTM3QzU1IDMzLjI2IDUzLjY4IDM1IDUyLjA1IDM1aC00MC4xQzEwLjMyIDM1IDkgMzMuMjU5IDkgMzEuMTM3VjEzaDExLjE2YzEuMjMzIDAgMi4yMjcgMS4zMjMgMi4yMjcgMi45Mjh2LjAyMmMwIDEuNjA1IDEuMDA1IDIuOTAxIDIuMjM3IDIuOTAxaDE0Ljc1MmMxLjIzMiAwIDIuMjM3LTEuMzA4IDIuMjM3LTIuOTEzdi0uMDA3eiINCiAgICAgICAgZmlsbD0iI2UxZTFlMSIgLz4NCiAgICA8L2c+DQogIDwvZz4NCjwvc3ZnPg==',
                        }
                      },
                    }
                },
                subtextStyle: {
                  fontSize: 16,
                }
            }
        }
        this.myChart.clear()
        this.myChart.setOption(option)
        return
      }
      this.myChart.clear()
      let series = val.y.map((item,idx) => ({
        name: item.title,
        type: 'line',
        stack: 'Total'+idx,
        data: item.dataList,
        itemStyle : { normal: {label : {show: true}}}
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
