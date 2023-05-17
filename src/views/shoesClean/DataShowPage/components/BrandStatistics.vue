<template>
  <a-card :bordered="false" :body-style="{ padding: '0',marginTop: '20px' }">
        <div class="title">品牌统计</div>
        <a-row>
          <a-col :xl="18" :lg="24" :md="24" :sm="24" :xs="24" >
            <a-spin :spinning="spinning">
              <div class="st">
                <div class="statistics" style="display: flex;">
                  <a-row style="width: 100%;">
                    <a-col :xl="8" :lg="8" :md="8" :sm="24" :xs="24" v-for="(statistics,index) in chunkData" :key="index">
                      <div class="statistics-box" >
                        <div class="statistics-box-title">
                          <div class="statistics-box-title-text w30">排名</div>
                          <div class="statistics-box-title-text w40">鞋子品牌</div>
                          <div class="statistics-box-title-text w30">鞋子数量</div>
                        </div>
                        <div class="statistics-box-tb" v-for="(tb,idx) in statistics" :key="idx">
                          <div class="statistics-box-tb-item w30">{{ tb.ranking }}</div>
                          <div class="statistics-box-tb-item w40">{{ tb.brand }}</div>
                          <div class="statistics-box-tb-item w30">{{ tb.count }}</div>
                        </div>
                      </div>
                    </a-col>
                    <div v-if="!chunkData.length" style="height: 400px;display: flex;justify-content: center;align-items: center;">
                      <a-empty/>
                    </div>
                    
                  </a-row>
                </div>
                <div class="pagination" v-if="total">
                  <a-pagination size="small" :total="total" :pageSize="pageSize" v-model="pageNo" @change="changePagination"/>
                </div>
              </div>
            </a-spin>
          </a-col>
          <a-col :xl="6" :lg="24" :md="24" :sm="24" :xs="24">
            <a-spin :spinning="spinningPie">
              <div style="height: 400px;display: flex;align-items: center;border-left: #ddd solid 1px;">
                <div style="flex:1">
                  <Pie v-if="pieData.length" :height="300" :dataSource="pieData" :isShowLegend="false" :padding="['60', '40', '60', '60']"/>
                  <a-empty v-if="!pieData.length"/>
                </div>
              </div>
            </a-spin>
          </a-col>
        </a-row>
      </a-card>
</template>

<script>
  import Pie from './Pie'
  import { getAction } from '@/api/manage'
  export default {
    components: {
      Pie
    },
    name: 'BrandStatistics',
    props: {
      pieData:{
        type: Array,
        default: () => ([])
      },
      queryForm:{
        type: Object,
        default: () => ({})
      },
      spinningPie:{
        type: Boolean,
        default: false
      },
      type:{
        type: String,
        default: ''
      }
    },
    data() {
      return {
        pageSize: 18,
        pageNo: 1,
        total:0,
        dataList:[],
        spinning:false
      }
    },
    watch:{
      queryForm: {
        handler(val,oldValue) {
          this.pageNo = 1
          this.total = 0
          this.brandRanking()
        },
        //立刻执行handler
        immediate: true,
        deep: true
      },
    },
    computed: {
      chunkData() {
        return this.chunk(this.dataList,6)
      }
    },
    mounted() {
      
    },
    methods: {
      chunk(array, size) {
        let result = []
        let x = 0
        for (let x = 0; x < Math.ceil(array.length / size); x++) {
          let start = x * size
          let end = start + size
          result.push(array.slice(start, end))
        }
        return result
      },
      changePagination(page, pageSize) {
        console.log(page, pageSize);
        this.brandRanking()
      },
      brandRanking() {
        let menu = {
          day:'today',
          month:'thisMonth',
          year:'thisYear'
        }
        let dateType = menu[this.queryForm.dateType] || this.queryForm.dateType
        let form = {
          ...this.queryForm,
          dateType,
          pageSize: this.pageSize,
          pageNo: this.pageNo,
          type:this.type
        }
        this.spinning = true
        getAction('/brandRanking',form).then(({success,result}) => {
          if(success) {
            this.total = result.total
            this.dataList = result.records
          }
        }).finally(res => {
          this.spinning = false
        })
      }
    },
  }
</script>

<style lang="less" scoped>
.title {
  padding:18px 0 18px 20px;
  font-size: 16px;
  font-weight: 600;
  color: #333333;
  line-height: 16px;
}
.w30 {
  width: 30%;
}
.w40 {
  width: 40%;
}
.pagination {
  padding: 18px 0;
  display: flex;
  justify-content: center;
}
.statistics {
  display: flex;
  
  &-box {
    flex: 1;
    &-title {
      background: #F5F5F5;
      display: flex;
      font-size: 16px;
      font-weight: 500;
      color: #000000;
      line-height: 16px;
      padding: 16px 0;
      &:first-child {
        padding-left: 20px;
      }
    }
    &-tb {
      display: flex;
      font-size: 16px;
      color: #333333;
      line-height: 22px;
      padding: 12px 0 14px 0;
      padding-left: 20px;
      border-right: #ddd solid 1px;
      border-bottom: #ddd solid 1px;
      
    }
  }
}
</style>