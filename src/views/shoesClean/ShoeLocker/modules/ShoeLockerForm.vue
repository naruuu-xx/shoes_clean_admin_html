<template>
  <a-spin :spinning="confirmLoading">
    <j-form-container :disabled="formDisabled">
      <a-form-model ref="form" :model="model" :rules="validatorRules" slot="detail">
        <a-row>
          <!--          <a-col :span="24">-->
          <!--            <a-form-model-item label="区域" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="orgCode">-->
          <!--              <a-select v-model="model.orgCode" style="width: 100%">-->
          <!--                <a-select-option v-for="item in areaList" :value="item.orgCode.toString()" :key="item.orgCode.toString()" >{{ item.departName }}</a-select-option>-->
          <!--              </a-select>-->
          <!--            </a-form-model-item>-->
          <!--          </a-col>-->
          <a-col :span="24">
            <a-form-model-item label="机柜编码" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="lockerCode">
              <a-input v-model="model.lockerCode" placeholder="请输入机柜编码"></a-input>
            </a-form-model-item>
          </a-col>
          <a-col :span="24">
            <a-form-model-item label="状态" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="status">
              <j-dict-select-tag type="radio" v-model="model.status" dictCode="shoe_locker_status" placeholder="请选择状态"/>
            </a-form-model-item>
          </a-col>
          <a-col :span="24">
            <a-form-model-item label="省市区" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="province">
              <!--             <j-area-linkage type="cascader" v-model="model.province" placeholder="请输入省市区"  />-->
              <al-cascader v-model="model.province" level="3" data-type="name"/>
            </a-form-model-item>
          </a-col>
          <!--          <a-col :span="24">-->
          <!--            <a-form-model-item label="市" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="city">-->
          <!--             <j-area-linkage type="cascader" v-model="model.city" placeholder="请输入省市区"  />-->
          <!--            </a-form-model-item>-->
          <!--          </a-col>-->
          <!--          <a-col :span="24">-->
          <!--            <a-form-model-item label="区/县" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="area">-->
          <!--             <j-area-linkage type="cascader" v-model="model.area" placeholder="请输入省市区"  />-->
          <!--            </a-form-model-item>-->
          <!--          </a-col>-->
          <a-col :span="24">
            <a-form-model-item label="详细地址" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="address">
              <a-textarea v-model="model.address" placeholder="请输入详细地址" id="c-address"></a-textarea>
            </a-form-model-item>
          </a-col>
          <a-col :span="24">
            <a-form-model-item label="经度" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="log">
<!--              <a-input-number v-model="model.log" placeholder="请输入经度" style="width: 100%" id="c-lng" />-->
<!--              <input type="number" placeholder="请输入经度" id="c-lng">-->
              <input v-model="model.log" style="width: 100%; height: 40px;border: 5px solid #ffffff;" placeholder="请输入经度" id="c-lng"/>
            </a-form-model-item>
          </a-col>
          <a-col :span="24">
            <a-form-model-item label="纬度" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="lat">
              <a-input-number v-model="model.lat" placeholder="请输入纬度" style="width: 100%" id="c-lat"/>
            </a-form-model-item>
          </a-col>
          <a-col :span="24">
            <a-form-model-item label="地图选点" :labelCol="labelCol" :wrapperCol="wrapperCol">
              <div id="tencentMapBox" style="width:auto;height:400px;"></div>
            </a-form-model-item>
          </a-col>
          <a-col :span="24">
            <a-form-model-item label="格子数" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="num">
              <a-input-number v-model="model.num" placeholder="请输入格子数" style="width: 100%"/>
            </a-form-model-item>
          </a-col>
          <!--          <a-col :span="24">-->
          <!--            <a-form-model-item label="空闲格子数" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="free">-->
          <!--              <a-input-number v-model="model.free" placeholder="请输入空闲格子数" style="width: 100%" />-->
          <!--            </a-form-model-item>-->
          <!--          </a-col>-->
        </a-row>
      </a-form-model>
    </j-form-container>
  </a-spin>
</template>

<script>

import {httpAction, getAction} from '@/api/manage'
import {validateDuplicateValue} from '@/utils/util'
import AlCascader from '@views/shoesClean/ShoeLocker/modules/al-cascader'
import $ from 'jquery'

let map, marker, polygon, drawingManager, lngLat, ap;

export default {
  name: 'ShoeLockerForm',
  components: {
    AlCascader
  },
  props: {
    //表单禁用
    disabled: {
      type: Boolean,
      default: false,
      required: false
    }
  },
  data() {
    return {
      model: {},
      labelCol: {
        xs: {span: 24},
        sm: {span: 5},
      },
      wrapperCol: {
        xs: {span: 24},
        sm: {span: 18},
      },
      confirmLoading: false,
      validatorRules: {
        lockerId: [
          {required: true, message: '请输入ID!'},
        ],
        lockerCode: [
          {required: true, message: '请输入机柜编码!'},
        ],
        orgCode: [
          {required: true, message: '请选择区域!'},
        ],
        status: [
          {required: true, message: '请选择状态'},
        ],
        log: [
          {required: true, message: '请输入经度!'},
          {pattern: /^-?\d+\.?\d*$/, message: '请输入数字!'},
        ],
        lat: [
          {required: true, message: '请输入纬度!'},
          {pattern: /^-?\d+\.?\d*$/, message: '请输入数字!'},
        ],
        address: [
          {required: true, message: '请输入详细地址!'},
        ],
        province: [
          {required: true, message: '请输入省!'},
        ],
        city: [
          {required: true, message: '请输入市!'},
        ],
        area: [
          {required: true, message: '请输入区/县!'},
        ],
        num: [
          {required: true, message: '请输入格子数!'},
          {pattern: /^-?\d+$/, message: '请输入整数!'},
        ],
        free: [
          {required: true, message: '请输入空闲格子数!'},
          {pattern: /^-?\d+$/, message: '请输入整数!'},
        ],
      },
      url: {
        add: "/shoes/shoeLocker/add",
        edit: "/shoes/shoeLocker/edit",
        queryById: "/shoes/shoeLocker/queryById"
      },
      areaList: [],
      //以下变量与腾讯地图相关
      //=================
      map: null,
      temp: null,
      option: {
        center: new window.qq.maps.LatLng(24.500646, 118.126990),// 设置地图中心点坐标
        zoom: 12, // 设置地图缩放级别
        mapTypeId: window.qq.maps.MapTypeId.ROADMAP  //设置地图样式详情参见MapType
      },
      //markerLayer: [],
      markerLayer: '',
      markIsHover: false,
      HoverInfo: {
        lat: null,
        lng: null
      },
      mapKey: "4FPBZ-5YC6F-M2RJN-NBEC4-UQQEV-P2B2U",
      mapLatLng: null,
      mapCity: "",
      searchForm: {
        key: "",
      },
      addressList: [],
      markerList: [],
      markerEventList: [],
      areaJson: [],
      //=================
    }
  },
  computed: {
    formDisabled() {
      return this.disabled
    },
  },
  created() {
    //备份model原始值address
    this.modelDefault = JSON.parse(JSON.stringify(this.model));
    // this.$nextTick(() => {
    //   this.initMapByJQ()
    // })
  },
  mounted() {
    // this.initMap();
    this.initMapByJQ();
  },
  methods: {
    add() {
      // this.edit(this.modelDefault);
      this.model = {
        status: 1,
      };
    },
    edit(record) {
      this.model = Object.assign({}, record);
      let province = record.province;
      let city = record.city;
      let area = record.area;
      this.model.province = [province, city, area];
      this.model.orgCode = record.orgCode + "";
      this.model.departName = record.departName;
      this.visible = true;
    },
    submitForm() {
      const that = this;
      // 触发表单验证
      this.$refs.form.validate(valid => {
        if (valid) {
          that.confirmLoading = true;
          let httpurl = '';
          let method = '';
          if (!this.model.lockerId) {
            httpurl += this.url.add;
            method = 'post';
          } else {
            httpurl += this.url.edit;
            method = 'put';
          }

          //处理省市区
          let province = this.model.province[0];
          let city = this.model.province[1];
          let area = this.model.province[2];

          let data = {
            "lockerId": this.model.lockerId,
            "orgCode": this.model.orgCode,
            "lockerCode": this.model.lockerCode,
            "status": this.model.status,
            "province": province,
            "city": city,
            "area": area,
            "address": this.model.address,
            "log": this.model.log,
            "lat": this.model.lat,
            "num": this.model.num
          }

          // console.log(data);
          httpAction(httpurl, data, method).then((res) => {
            if (res.success) {
              that.$message.success(res.message);
              that.$emit('ok');
            } else {
              that.$message.warning(res.message);
            }
          }).finally(() => {
            that.confirmLoading = false;
          })
          // that.confirmLoading = false;
        }

      })
    },
    getAreaList() {
      httpAction("/shoes/shoeLocker/getAreaList", null, "get").then((res) => {
        let areaList = res.result;

        this.areaList = areaList;
      })
    },
    //=====================================================
    //以下是腾讯地图的方法
    //位置信息在地图上展示
    //js直接改造的方法
    initMapByJQ(){
      let _this = this;

      let center = new TMap.LatLng(24.500646, 118.126990);//设置中心点坐标(厦门sm)
      //初始化地图
      this.map = new TMap.Map("tencentMapBox", {
        pitch: 30, //设置俯仰角度（0~45）
        zoom: 14,//设置地图缩放级别
        center: center //设置地图中心点坐标
      });
      //初始化marker图层
      _this.markerLayer = new TMap.MultiMarker({
        id: 'marker-layer',
        map: this.map
      });

      //绑定点击事件
      this.map.on('click', function (evt) {
        //修改标记
        _this.markerLayer.updateGeometries([
          {
            "styleId": "marker",
            "id": "1",
            "position": evt.latLng,
          }
        ])

        //经纬度赋值给input框
        var lat = evt.latLng.getLat().toFixed(6);
        var lng = evt.latLng.getLng().toFixed(6);
        $('#c-lng').val(lng);
        this.model.log = lng;
        $('#c-lat').val(lat);
        this.model.lat = lat

      })




    },
    initMap() {
      let me = this;
      //初始化地图
      let mapContainer = document.getElementById("tencentMapBox");
      this.map = new window.qq.maps.Map(mapContainer, this.option);

      //创建label
      this.mapLabel = new window.qq.maps.Label({
        map: this.map,
        offset: new window.qq.maps.Size(15, -12),
        draggable: false,
        clickable: false,
      })

      this.map.setOptions({
        draggableCursor: "crosshair",
      })

      mapContainer.addEventListener("mouseenter", function (e) {
        me.mapLabel.setMap(me.map);
      });
      mapContainer.addEventListener("mouseleave", function (e) {
        me.mapLabel.setMap(null);
      });

      window.qq.maps.event.addListener(this.map, "mousemove", function (e) {
        var latlng = e.latLng;
        me.mapLabel.setPosition(latlng);
        me.mapLabel.setContent(
          latlng.getLat().toFixed(6) + "," + latlng.getLng().toFixed(6)
        );
      });

      if (this.mapLatLng != null) {
        this.locationService();
      } else {
        this.initcityService();
      }

      //点击获取地址
      window.qq.maps.event.addListener(this.map, "click", function (e) {
        let url = "https://apis.map.qq.com/ws/geocoder/v1/?location=" + e.latLng.getLat() + "," + e.latLng.getLng() + "&key=" + me.mapKey + "&output=jsonp&callback=?"

        $.ajax({
          type: "get",
          async: false,
          url: "https://apis.map.qq.com/ws/geocoder/v1",
          data: {
            location: e.latLng.getLat() + "," + e.latLng.getLng(),
            key: '4FPBZ-5YC6F-M2RJN-NBEC4-UQQEV-P2B2U',
            get_poi: 1,
            output: "jsonp"
          },
          dataType: "jsonp",
          //jsonp: "callback",//传递给请求处理程序或页面的，用以获得jsonp回调函数名的参数名(一般默认为:callback)
          //jsonpCallback:"?",//自定义的jsonp回调函数名称，默认为jQuery自动生成的随机函数名，也可以写"?"，jQuery会自动为你处理数据
          success: function(res){
            console.log(res);
            if (res.status === 0) {
              me.model.address = res.result !== undefined ? res.result.address : "";
              $("c-address").val(res.result !== undefined ? res.result.address : "");
              me.model.log = res.result !== undefined ? res.result.location.lng: null;
              me.model.lat = res.result !== undefined ? res.result.location.lat: null;
              // me.mapLatLng =
              //   res.result != undefined
              //     ? [res.result.location.lat, res.result.location.lng]
              //     : null;
            }
          },
          error: function(){
            //  alert('fail');
          }
        })

      });
    },
    initcityService() {
      let me = this;
      //当位定前位置
      let cityService = new window.qq.maps.CityService({
        complete: function (result) {
          console.log(result);
          me.map.setCenter(result.detail.latLng);
          me.mapCity = result.detail.name;
        },
      });
      cityService.searchLocalCity();
    },
    //按坐标获取位置信息
    locationService() {
      let me = this;

      let url = "https://apis.map.qq.com/ws/geocoder/v1/?location=" + this.mapLatLng[0] + "," + this.mapLatLng[1] + "&key=" + this.mapKey + "&output=jsonp&callback=?"
      httpAction(url, null, "get").then((res) => {
        if (res.status == 0 && res.result) {
          let center = new window.qq.maps.LatLng(
            this.mapLatLng[0],
            this.mapLatLng[1]
          );
          this.map.panTo(center);
          let marker = new window.qq.maps.Marker({
            position: center,
            map: this.map,
          });
          me.mapAddress = res.result.address;
          me.mapCity = res.result.address_component.city;
        }
      });

      // this.$jsonp(
      //   "http://apis.map.qq.com/ws/geocoder/v1/?location=" +
      //   this.mapLatLng[0] +
      //   "," +
      //   this.mapLatLng[1] +
      //   "&key=" +
      //   this.mapKey +
      //   "&output=jsonp&callback=?"
      // ).then((res) => {
      //   if (res.status == 0 && res.result) {
      //     let center = new window.qq.maps.LatLng(
      //       this.mapLatLng[0],
      //       this.mapLatLng[1]
      //     );
      //     this.map.panTo(center);
      //     let marker = new window.qq.maps.Marker({
      //       position: center,
      //       map: this.map,
      //     });
      //     me.mapAddress = res.result.address;
      //     me.mapCity = res.result.address_component.city;
      //   }
      // });
    },
    //查询地址信息
    handleSearch() {
      if (!util.isNullEmpty(this.searchForm.key)) {
        let url = "https://apis.map.qq.com/ws/place/v1/search?keyword=" + this.searchForm.key + "&boundary=region(" + this.mapCity + ",0)&page_size=9&page_index=1&key=" + this.mapKey + "&output=jsonp&&callback=?"

        httpAction(url, null, "get").then((res) => {
          console.log(res);
          if (res.status == 0) {
            res.data.map((item, index) => {
              item.id = "mapItem" + index;
              item.active = false;
              item.hover = false;
              return item;
            });
            this.addressList = res.data;
            this.setMarker(res);
            this.map.setZoom(14);
          }
        });

        // this.$jsonp(
        //   "http://apis.map.qq.com/ws/place/v1/search?keyword=" +
        //   this.searchForm.key +
        //   "&boundary=region(" +
        //   this.mapCity +
        //   ",0)&page_size=9&page_index=1&key=" +
        //   this.mapKey +
        //   "&output=jsonp&&callback=?"
        // ).then((res) => {
        //   console.log(res);
        //   if (res.status == 0) {
        //     res.data.map((item, index) => {
        //       item.id = "mapItem" + index;
        //       item.active = false;
        //       item.hover = false;
        //       return item;
        //     });
        //     this.addressList = res.data;
        //     this.setMarker(res);
        //     this.map.setZoom(14);
        //   }
        // });
      } else {
        this.addressList = [];

        let url = "https://apis.map.qq.com/ws/geocoder/v1/?region=" + this.mapCity + "&address=" + this.mapCity + "&key=" + this.mapKey + "&output=jsonp&&callback=?"

        httpAction(url, null, "get").then((res) => {
          if (res.status == 0) {
            this.map.setCenter(
              new window.qq.maps.LatLng(
                res.result.location.lat,
                res.result.location.lng
              )
            );
            this.map.setZoom(14);
          }
        });

        // this.$jsonp(
        //   "http://apis.map.qq.com/ws/geocoder/v1/?region=" +
        //   this.mapCity +
        //   "&address=" +
        //   this.mapCity +
        //   "&key=" +
        //   this.mapKey +
        //   "&output=jsonp&&callback=?"
        // ).then((res) => {
        //   if (res.status == 0) {
        //     this.map.setCenter(
        //       new window.qq.maps.LatLng(
        //         res.result.location.lat,
        //         res.result.location.lng
        //       )
        //     );
        //     this.map.setZoom(14);
        //   }
        // });
      }
    },
    setMarker(res) {
      //设置Marker
      let me = this;
      let latlngBounds = new window.qq.maps.LatLngBounds();
      //删除Marker
      this.markerList.forEach((item) => {
        item.setMap(null);
      });
      //删除Marker事件
      this.markerEventList.forEach((item) => {
        window.qq.maps.event.removeListener(item);
      });

      this.markerEventList = [];
      this.markerList = [];
      res.data.forEach((item, index) => {
        let latlng = new window.qq.maps.LatLng(
          item.location.lat,
          item.location.lng
        );
        latlngBounds.extend(latlng);
        //创建Marker
        let marker = new window.qq.maps.Marker({
          map: this.map,
          position: latlng,
          zIndex: 10,
        });
        marker.index = index;
        marker.isClicked = false;
        this.setAnchor(marker, false);
        this.markerList.push(marker);
        //点击事件
        this.markerEventList.push(
          window.qq.maps.event.addDomListener(marker, "click", function () {
            me.setFlagClicked(this.index);
          })
        );
        this.markerEventList.push(
          window.qq.maps.event.addDomListener(marker, "mouseover", function () {
            me.setCurrentMarker(this.index, true);
            me.hoverAddress(this.index, true);
            me.mapLabel.setContent(
              this.position.getLat().toFixed(6) +
              "," +
              this.position.getLng().toFixed(6)
            );
            me.mapLabel.setPosition(this.position);
            me.mapLabel.setOptions({
              offset: new window.qq.maps.Size(15, -20),
            });
            document
              .getElementById("mapItem" + this.index)
              .scrollIntoView({behavior: "smooth"});
          })
        );
        this.markerEventList.push(
          window.qq.maps.event.addDomListener(marker, "mouseout", function () {
            me.setCurrentMarker(this.index, false);
            me.hoverAddress(this.index, false);
            me.mapLabel.setOptions({
              offset: new window.qq.maps.Size(15, -12),
            });
          })
        );
        this.map.fitBounds(latlngBounds);
      });
      if (this.markerList.length > 0) {
        this.map.setCenter(this.markerList[0].position);
      }
    },
    setAnchor(marker, flag) {
      let left = marker.index * 27;
      let anchor = new window.qq.maps.Point(10, 30),
        origin = new window.qq.maps.Point(left, flag ? 35 : 0),
        size = new window.qq.maps.Size(27, 33),
        icon = new window.qq.maps.MarkerImage(
          "/images/marker10.png",
          size,
          origin,
          anchor
        );
      marker.setIcon(icon);
    },
    //选择地址
    selectAddress(index) {
      this.setCurrentAddress(index);
      this.setFlagClicked(index);
      this.map.setCenter(this.markerList[index].position);
    },
    hoverAddress(mapIndex, flag) {
      this.addressList.map((item, index) => {
        item.hover = flag ? index == mapIndex : flag;
        return item;
      });
    },
    setCurrentAddress(mapIndex) {
      this.addressList.map((item, index) => {
        item.active = index == mapIndex;
        return item;
      });
    },
    setCurrentMarker(index, flag) {
      if (flag || (!flag && !this.markerList[index].isClicked)) {
        this.setAnchor(this.markerList[index], flag);
      }
    },
    setFlagClicked(mapIndex) {
      this.markerList.map((item, index) => {
        if (index == mapIndex) {
          item.isClicked = true;
          item.setZIndex(10);
          this.setAnchor(item, true);
          this.mapLatLng = [
            item.getPosition().getLat().toFixed(6),
            item.getPosition().getLng().toFixed(6),
          ];
          this.mapAddress = this.addressList[mapIndex].address;
        } else {
          item.isClicked = false;
          item.setZIndex(9);
          this.setAnchor(item, false);
        }
        return item;
      });
      this.setCurrentAddress(mapIndex);
      document
        .getElementById("mapItem" + mapIndex)
        .scrollIntoView({ behavior: "smooth" });
    },

  }
}
</script>
<style>

</style>