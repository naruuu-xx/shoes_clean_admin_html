<template>
    <j-modal title=""
             :width="700"
             :visible="visible"
             switchFullscreen
             @cancel="handleCancel2"
             @ok="handleSubmit2"
             cancelText="关闭"
             wrapClassName="full-modal">

  <h2>申请人：{{data.name}}</h2>
      <br/>
  <h2>手机号：{{data.phone}}</h2>
      <br/>
  <h2>申请时间：{{data.createTime}}</h2>
      <br/>
  <h2>申请状态：{{data.status === 1?'已同意':'已拒绝'}}</h2>
      <br/>
  <h2 v-if="data.type === 1" >{{ data.status === 1 ?'优惠券名称：'+this.couponName:'已拒绝：'+data.note}}</h2>

      <h2 v-if="data.type === 2" >{{data.status === 1 ? '鞋蜂卡名称：' + this.timecardName: '已拒绝：'+ data.note }}</h2>
      <!--  <h2 v-if="data.status==2">拒绝原因：{{data.note}}</h2>-->



      </j-modal>
</template>

<script>
import {httpAction} from "../../../../api/manage";
import XfSelect from '@/components/Xf/XfSelect'
export default {
  components:{
    XfSelect
  },
  data() {
    return {
      visible: false,
      data:{},
      couponName:'',
      timecardName:'',
    }
  },
  methods: {

    show(record) {
      if (record.status=== 1 && record.type === 1) {
        this.getCouponName(record.couponId);
      }else if (record.status=== 1 && record.type === 2) {
        this.getTimecardName(record.timecardId);
      }
      this.data = record;
      this.visible = true;
    },
    handleCancel2() {
      this.visible = false;
    },
    handleSubmit2(){
      this.visible = false;

    },
    getCouponName(couponId){
      httpAction("/shoeCouponExchangeThird/getCouponName?id="+couponId, null, "get").then((res) => {
        if (res){
          this.couponName = res.result;
        }
      })
    },
    getTimecardName(timecardId){
      httpAction("/shoeCouponExchangeThird/getTimecardName?id="+timecardId, null, "get").then((res) => {
        if (res){
          this.timecardName = res.result;
        }
      })
    },

  }
}
</script>

<style scoped>

</style>