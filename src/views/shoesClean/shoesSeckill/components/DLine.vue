<template>
  <div>
    <v-chart :force-fit="true" :height="height" :data="data" :scale="scale">
      <v-tooltip />
      <v-axis />
      <v-legend />
      <v-line position="y*temperature" color="city" />
      <v-point position="y*temperature" color="city" :size="4" :v-style="style" :shape="'circle'" />
    </v-chart>
  </div>
</template>

<script>
const DataSet = require('@antv/data-set');

export default {
  data() {
    return {
      style: { stroke: '#fff', lineWidth: 1 },
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
      default: 300
    },
    alias:{
      type: String,
      default: 'ruku'
    },
    color:{
      type:String,
      default: '#54acff'
    },
    yUnit:{
      type:String,
      default: ''
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
          console.log(8888,fields);
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
    }
};
</script>
