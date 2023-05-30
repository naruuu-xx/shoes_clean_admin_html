<template>
  <div v-if="showChart">
    <v-chart v-if="dataSource.length" :force-fit="true" :height="height" :data="data" :scale="scale">
      <v-tooltip />
      <v-axis />
      <v-legend />
      <v-line position="y*temperature" :color="color" />
      <v-point position="y*temperature" :color="color" :size="4" :v-style="style" :shape="'circle'"  />
    </v-chart>
    <a-empty v-if="!dataSource.length" style="padding: 20px 0;"/>
  </div>
</template>

<script>
const DataSet = require('@antv/data-set');

export default {
  data() {
    return {
      style: { stroke: '#fff', lineWidth: 1 },
      showChart: false
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
    alias:{
      type: String,
      default: 'ruku'
    },
    color:{ 
      type:Array,
      default: () => (
        ['city', ['#ff4d4f', '#ff7a45', '#ffa940', '#facc14', '#bae637', '#73d13d', '#36cfc9', '#40a9ff']]
      )
    },
    yUnit:{
      type:String,
      default: ''
    }
  },
  mounted() {
    this.$nextTick(()=>{this.showChart=true})
    if(!this.color.length) {
      
    }
  },
  computed: {
      scale() {
        return [{
          dataKey: 'y',
          min: 0,
          max: 1,
        }]
      },
      data() {
        const dv = new DataSet.View().source(this.dataSource)
        let fields = []
        if(this.dataSource.length) {
          fields = Object.keys(this.dataSource[0]).slice(1)
        }
        dv.transform({
          type: 'fold',
          fields,
          key: 'city',
          value: 'temperature',
        })
        let rows =  dv.rows
        return rows
      },
      label() {
        return {
          formatter:(val) => {
            return val + this.yUnit;
          }
        }
      }
    },
    methods:{
      color16() {   
          return  '#'+Math.random().toString(16).substring(2, 6)
      }
    }
};
</script>
