<template>
  <v-chart :forceFit="true" :height="height" :data="data" :scale="scale" :onClick="handleClick" :padding="padding">
    <v-tooltip :showTitle="false" dataKey="item*percent"/>
    <v-axis/>
    <v-legend dataKey="item" :offsetY="offsetY" v-if="isShowLegend"/>
    <v-pie position="percent" color="item" :v-style="pieStyle" :label="labelConfig" />
    <v-coord type="theta"/>
  </v-chart>
</template>

<script>
  const DataSet = require('@antv/data-set')
  import { ChartEventMixins } from '@/components/chart/mixins/ChartMixins'

  export default {
    name: 'Pie',
    mixins: [ChartEventMixins],
    props: {
      title: {
        type: String,
        default: ''
      },
      height: {
        type: Number,
        default: 254
      },
      dataSource: {
        type: Array,
        default: () => [
          { item: '示例一', count: 40 },
          { item: '示例二', count: 21 },
          { item: '示例三', count: 17 },
          { item: '示例四', count: 13 },
          { item: '示例五', count: 9 }
        ]
      },
      padding:{
        type: Array,
        default: () => (['40', '60', '100', '80'])
      },
      isShowLegend: {
        type: Boolean,
        default: true
      },
      offsetY:{
        type: Number,
        default: 40
      }
    },
    data() {
      return {
        scale: [{
          dataKey: 'percent',
          min: 0,
          formatter: '.2%'
        }],
        pieStyle: {
          stroke: '#fff',
          lineWidth: 1
        },
        labelConfig: ['percent', {
          formatter: (val, item) => {
            return item.point.item + ': ' + item.point.count
          }
        }],
      }
    },
    computed: {
      data() {
        let dv = new DataSet.View().source(this.dataSource)
        // 计算数据百分比
        dv.transform({
          type: 'percent',
          field: 'count',
          dimension: 'item',
          as: 'percent'
        })
        return dv.rows
      }
    }
  }
</script>