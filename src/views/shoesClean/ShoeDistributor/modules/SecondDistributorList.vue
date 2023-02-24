<template>
  <a-modal v-model:visible="visible" title="二级推广人" :footer="null" width="1200px">
    <div class="table-page-search-wrapper">
      <a-form layout="inline" @keyup.enter.native="searchQuery">
        <a-row :gutter="24">
          <a-col :xl="4" :lg="7" :md="8" :sm="24">
            <a-form-item label=" 昵称">
              <a-input placeholder="请输入 昵称" v-model="queryParam.nickname"></a-input>
            </a-form-item>
          </a-col>
          <a-col :xl="4" :lg="7" :md="8" :sm="24">
            <a-form-item label=" 手机号">
              <a-input placeholder="请输入 手机号" v-model="queryParam.phone"></a-input>
            </a-form-item>
          </a-col>
          <a-col :xl="5" :lg="7" :md="8" :sm="24">
                <span style="float: left;overflow: hidden;" class="table-page-search-submitButtons">
                  <a-button type="primary" @click="initDataByDIY2" icon="search">查询</a-button>
                  <a-button type="primary" @click="searchReset2" icon="reload" style="margin-left: 8px">重置</a-button>
                </span>
          </a-col>
        </a-row>
      </a-form>
    </div>
  </a-modal>
</template>

<script>
import {getAction} from "../../../../api/manage";

export default {
  name: "SecondDistributorList",
  data () {
    return {
      queryParam:{},
      visible: false,
      distributorId: null,
      dataSource: [],
      ipagination: { total: 0},
      loading:false,
      url: {
        list: "/shoeCourier/shoeCourier/queryHistoryList",
      },
    }
  },
  created() {

  },
  methods: {
    initDataByDIY(distributorId) {
      this.queryParam.id = distributorId;
      this.distributorId=distributorId;
      getAction(this.url.list+"?id="+courierId).then((res) => {
        if (res.success) {
          //把数据传入dataSource
          this.dataSource = res.result.records;
          this.ipagination.total = res.result.total;
        }
      })
    },
  }
}
</script>

<style scoped>

</style>