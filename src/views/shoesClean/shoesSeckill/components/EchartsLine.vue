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
    };
  },
  props: {
    title: {
      type: String,
      default: ''
    },
    dataSource: {
      type: Array,
      default: () => [
        { y: 'Jan', Tokyo: 7.0, London: 3.9 },
        { y: 'Feb', Tokyo: 6.9, London: 4.2 },
        { y: 'Mar', Tokyo: 9.5, London: 5.7 },
        { y: 'Apr', Tokyo: 14.5, London: 8.5 },
        { y: 'May', Tokyo: 18.4, London: 11.9 },
        { y: 'Jun', Tokyo: 21.5, London: 15.2 },
        { y: 'Jul', Tokyo: 25.2, London: 17.0 },
        { y: 'Aug', Tokyo: 26.5, London: 16.6 },
        { y: 'Sep', Tokyo: 23.3, London: 14.2 },
        { y: 'Oct', Tokyo: 18.3, London: 10.3 },
        { y: 'Nov', Tokyo: 13.9, London: 6.6 },
        { y: 'Dec', Tokyo: 9.6, London: 4.8 },
      ]
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

  computed: {
    
  },
  methods: {
    color16() {
      return '#' + Math.random().toString(16).substring(2, 6)
    },
    change() {
        // 基于准备好的dom，初始化echarts实例
      var myChart = this.$echarts.init(document.getElementById('main'))
      // 指定图表的配置项和数据
      let option = {
        title: {
          text: ''
        },
        tooltip: {
          trigger: 'axis'
        },
        legend: {
          // data: ['Email', 'Union Ads', 'Video Ads', 'Direct', 'Search Engine']
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
          data: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun']
        },
        yAxis: {
          type: 'value'
        },
        series: [
          {
            name: 'Email',
            type: 'line',
            stack: 'Total',
            data: [120, 132, 101, 134, 90, 230, 210]
          },
          {
            name: 'Union Ads',
            type: 'line',
            stack: 'Total',
            data: [220, 182, 191, 234, 290, 330, 310]
          },
          {
            name: 'Video Ads',
            type: 'line',
            stack: 'Total',
            data: [150, 232, 201, 154, 190, 330, 410]
          },
          {
            name: 'Direct',
            type: 'line',
            stack: 'Total',
            data: [320, 332, 301, 334, 390, 330, 320]
          },
          {
            name: 'Search Engine',
            type: 'line',
            stack: 'Total',
            data: [820, 932, 901, 934, 1290, 1330, 1320]
          }
        ]
      };
      // 使用刚指定的配置项和数据显示图表。
      myChart.setOption(option)
      // 根据页面大小自动响应图表大小
      window.addEventListener("resize", function () {
        myChart.resize();
      });
    }
  }
};
</script>
