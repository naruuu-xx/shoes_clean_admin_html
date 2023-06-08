<!--
 * @Descripttion: your project
 * @version: 1.0
 * @Author: yizhimao
 * @Date: 2023-05-29 16:49:02
 * @LastEditors: yizhimao
 * @LastEditTime: 2023-05-29 19:45:16
-->
<template>
  <div v-if="showChart">
    <h4 class="title" v-if="title">{{ title }}</h4>
    <v-chart v-if="dataSource.length" :force-fit="true" :height="height" :data="dataSource" :scale="scale" :onClick="handleClick">
      <v-tooltip/>
      <v-axis dataKey="y" :label="label"/>
      <v-legend/>
      <v-line position="x*y" :color="color"/>
      <v-point position="x*y" :color="color" :size="4" :v-style="style" :shape="'circle'"/>
    </v-chart>
    <a-empty v-if="!dataSource.length" style="padding: 20px 0;"/>
  </div>
</template>

<script>
  import { DataSet } from '@antv/data-set'
  import { ChartEventMixins } from '@/components/chart/mixins/ChartMixins'

  export default {
    name: 'xfLine',
    mixins: [ChartEventMixins],
    props: {
      title: {
        type: String,
        default: ''
      },
      dataSource: {
        type: Array,
        default: () => []
      },
      height: {
        type: Number,
        default: 254
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
    data() {
      return {
        style: { stroke: '#fff', lineWidth: 1 },
        showChart: false
      }
    },
    mounted() {
      this.$nextTick(()=>{this.showChart=true})
    },
    computed: {
      scale() {
        return [{
          dataKey: 'y',
          min: 0,
          alias: this.alias
        },{
          dataKey: 'x',
          min: 0
        }]
      },
      data() {
        const dv = new DataSet.View().source(this.dataSource)
        dv.transform({
          type: 'fold',
          key: 'x',
          value: 'y'
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
  }
</script>

<style scoped>
.title {
  border-bottom: 1px solid #e3e3e3;
  padding: 19px 0;
  padding-left: 20px;
}
</style>