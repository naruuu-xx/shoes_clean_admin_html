<template>
  <div :style="{ paddingBottom: paddingBottom }">
    <h4 class="title" v-if="title">{{ title }}</h4>
    <v-chart :forceFit="true" :height="height" :data="dataSource" :scale="scale" :padding="padding">
      <v-tooltip/>
      <v-axis/>
      <v-bar :color="color" position="x*y"/>
    </v-chart>
  </div>
</template>

<script>
  import { triggerWindowResizeEvent } from '@/utils/util'

  export default {
    name: 'Bar',
    props: {
      dataSource: {
        type: Array,
        required: true
      },
      yaxisText: {
        type: String,
        default: 'y'
      },
      title: {
        type: String,
        default: ''
      },
      height: {
        type: Number,
        default: 254
      },
      color: {
        type: String,
        default: '#389fff'
      },
      paddingBottom:{
        type: String,
        default: '32px'
      }
    },
    data() {
      return { padding: ['auto', 'auto', '40', '50'] }
    },
    computed: {
      scale() {
        return [{
          dataKey: 'y',
          alias: this.yaxisText
        }]
      }
    },
    mounted() {
      triggerWindowResizeEvent()
    }
  }
</script>

<style lang="less" scoped>
.title {
  border-bottom: 1px solid #e3e3e3;
  padding: 19px 0;
  padding-left: 20px;
}
</style>