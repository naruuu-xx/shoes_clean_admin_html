<template>
  <a-spin :spinning="confirmLoading">
    <j-form-container :disabled="formDisabled">
      <a-form-model ref="form" :model="model" :rules="validatorRules" slot="detail">
        <div class="diyDiv">
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
                <a-input v-model="model.lockerCode" placeholder="请输入机柜编码" autocomplete="off"></a-input>
              </a-form-model-item>
            </a-col>
            <a-col :span="24">
              <a-form-model-item label="机柜名称" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="name">
                <a-input v-model="model.name" placeholder="请输入机柜名称" autocomplete="off"></a-input>
                <span style="color: red">如果机柜发生较大的变动，请使用机柜迁移功能，请勿直接修改机柜名称跟地址，防止出现数据混乱！</span>
              </a-form-model-item>
            </a-col>
            <a-col :span="24">
              <a-form-model-item
                label="格子数"
                :labelCol="labelCol"
                :wrapperCol="wrapperCol"
                prop="num"
                v-if="model.lockerId !== null && model.lockerId !== '' && model.lockerId !== undefined"
              >
                <a-input-number
                  v-model="model.num"
                  placeholder="请输入格子数"
                  style="width: 10%"
                  autocomplete="off"
                  :disabled="true"
                />
              </a-form-model-item>
            </a-col>
            <a-col :span="24">
              <a-form-model-item label="权重" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="weight">
                <a-input-number v-model="model.weight" placeholder="请输入权重" autocomplete="off"></a-input-number>（权重值越高，排序越靠前）
              </a-form-model-item>
            </a-col>
            <!--            <a-col :span="24">-->
            <!--              <a-form-model-item label="机柜类型" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="type">-->
            <!--                <j-dict-select-tag type="radio" v-model="model.type" dictCode="shoe_locker_type" placeholder="请选择机柜类型"/>-->
            <!--              </a-form-model-item>-->
            <!--            </a-col>-->
            <a-col :span="24">
              <a-form-model-item label="状态" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="status">
                <j-dict-select-tag
                  type="radio"
                  v-model="model.status"
                  dictCode="shoe_locker_status"
                  placeholder="请选择状态"
                />
              </a-form-model-item>
            </a-col>
            <a-col :span="24">
              <a-form-model-item label="是否接单" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="orderStatus">
                <j-dict-select-tag
                  type="radio"
                  v-model="model.orderStatus"
                  dictCode="shoe_locker_order_status"

                />
              </a-form-model-item>
            </a-col>
            <a-col :span="24" v-if="model.orderStatus == 1">
              <a-form-model-item label="接单类型" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="selectedOrderType">
                <a-checkbox-group v-model="model.selectedOrderType">
                  <a-checkbox v-for="item in orderTypeOptions" :value="item.value" :key="item.value">{{ item.name }}</a-checkbox>
                </a-checkbox-group>
              </a-form-model-item>
            </a-col>

            <a-col :span="24" v-if="model.selectedOrderType.includes('service')">
              <a-form-model-item label="配送范围设置" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="matchingType">
                <a-radio-group v-model="model.matchingType">
                  <a-radio value="2">手绘范围</a-radio>
                  <a-radio value="1">系统设定</a-radio>
                </a-radio-group>
              </a-form-model-item>
            </a-col>
            <!--          <a-col :span="24">-->
            <!--            <a-form-model-item label="省市区" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="province">-->
            <!--             <j-area-linkage type="cascader" v-model="model.province" placeholder="请输入省市区"  />-->
            <!--              <al-cascader v-model="model.province" level="3" data-type="name"/>-->
            <!--            </a-form-model-item>-->
            <!--          </a-col>-->
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
                <!--              <a-input v-model="model.address" placeholder="请输入详细地址" id="c-address" :change="addressOnchange()"></a-input>-->
                <a-input-search
                  v-model="model.address"
                  placeholder="请输入详细地址"
                  id="c-address"
                  enter-button
                  @search="onSearch(model.address)"
                  autocomplete="off"
                ></a-input-search>
              </a-form-model-item>
            </a-col>
            <a-col :span="24">
              <a-form-model-item label="经度" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="longitude">
                <a-input-number
                  v-model="model.longitude"
                  placeholder="请输入经度"
                  style="width: 100%"
                  id="c-lng"
                  :disabled="false"
                />
              </a-form-model-item>
            </a-col>
            <a-col :span="24">
              <a-form-model-item label="纬度" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="latitude">
                <a-input-number
                  v-model="model.latitude"
                  placeholder="请输入纬度"
                  style="width: 100%"
                  id="c-lat"
                  :disabled="false"
                />
              </a-form-model-item>
            </a-col>
            <a-col :span="24">
              <a-form-model-item label="配送范围"  :labelCol="labelCol" :wrapperCol="wrapperCol" prop="paths">
                <a-input v-model="model.paths" placeholder="请设定配送范围" style="width: 100%" id="c-paths" :disabled="true"/>
              </a-form-model-item>
            </a-col>
            <a-col :span="24">
              <a-form-model-item label="地图操作" :labelCol="labelCol">
                <div class="ant-row-flex">
                  <div>
                    <button
                      @click="setActivePattern('marker')"
                      :class="['ant-btn', activePattern==='marker'?'ant-btn-primary':'']">
                      <span>设置机柜定位</span>
                    </button>
                  </div>
                  <div v-if="model.matchingType == 1">
                    <button
                      @click="setActivePattern('polygon')"
                      :class="['ant-btn', activePattern==='polygon'?'ant-btn-primary':'']"
                      style="margin: 0 30px 0 30px">
                      设置配送范围
                    </button>
                  </div>
                  <div v-if="activePattern==='polygon' && model.matchingType == 1">
                    <button class="ant-btn" @click="addPolygon()">添加</button>
                    <button class="ant-btn" @click="editPolygon()">编辑</button>
                    <button class="ant-btn" @click="delPolygon()">删除</button>
                  </div>
                </div>
              </a-form-model-item>
            </a-col>
            <a-col :span="24">
              <a-row>
                <a-col :span="16">
                  <div
                    id="tencentMapBox"
                    style="width: auto; height: 400px; margin-left: 200px; margin-bottom: 30px"
                  ></div>
                </a-col>
                <a-col :span="8">
                  <div id="container-text" style="width: auto; height: 400px; margin-left: 5px; overflow-y: auto">
                    <div
                      v-model="searchList"
                      v-for="(item, index) in searchList"
                      style="margin-bottom: 10px"
                      v-on:click="selectAddress(item)"
                    >
                      <span style="font-size: 14px">{{ index + 1 }}、{{ item.title }}</span
                      ><br />
                      <span style="font-size: 12px; color: #7a7b7d">{{ item.address }}</span>
                      <span style="display: none">{{ item.location.lat }}</span>
                      <span style="display: none">{{ item.location.lng }}</span>
                    </div>
                  </div>
                </a-col>
              </a-row>
            </a-col>
            <a-col :span="24">
              <a-form-model-item label="绘制说明" :labelCol="labelCol">
                <div class="ant-row-flex">
                  绘制：选择添加模式，鼠标左键点击及移动即可绘制图形<br/>
                  结束绘制：鼠标左键双击即可结束绘制，图形会自动闭合<br/>
                  编辑：选择编辑模式，选中图形后出现编辑点，拖动编辑点可移动顶点位置，双击编辑点可删除顶点<br/>
                  删除：选择删除模式，选中图形后按下delete键或点击删除按钮可删除图形
                </div>
              </a-form-model-item>
            </a-col>
          </a-row>
        </div>
      </a-form-model>
    </j-form-container>
  </a-spin>
</template>

<script>
import { httpAction, getAction } from '@/api/manage'
import { validateDuplicateValue } from '@/utils/util'
import AlCascader from '@views/shoesClean/ShoeLocker/modules/al-cascader'
import $ from 'jquery'

let map, marker, polygon, ap,mapEditor;

export default {
  name: 'ShoeLockerForm',
  components: {
    AlCascader,
  },
  props: {
    //表单禁用
    disabled: {
      type: Boolean,
      default: false,
      required: false,
    },
  },
  data() {
    return {
      model: {
        selectedOrderType:[],
        matchingType:''
      },
      labelCol: {
        xs: { span: 24 },
        sm: { span: 5 },
      },
      wrapperCol: {
        xs: { span: 24 },
        sm: { span: 18 },
      },
      confirmLoading: false,
      validatorRules: {
        lockerId: [{ required: true, message: '请输入ID!' }],
        lockerCode: [{ required: true, message: '请输入机柜编码!' }],
        orgCode: [{ required: true, message: '请选择区域!' }],
        weight: [{ required: true, message: '请选择权重值!' }],
        type: [{ required: true, message: '请选择机柜类型' }],
        status: [{ required: true, message: '请选择状态' }],
        longitude: [
          { required: true, message: '请输入经度!' },
          { pattern: /^-?\d+\.?\d*$/, message: '请输入数字!' },
        ],
        latitude: [
          { required: true, message: '请输入纬度!' },
          { pattern: /^-?\d+\.?\d*$/, message: '请输入数字!' },
        ],
        address: [{ required: true, message: '请输入详细地址!' }],
        province: [{ required: true, message: '请输入省!' }],
        city: [{ required: true, message: '请输入市!' }],
        area: [{ required: true, message: '请输入区/县!' }],
        num: [
          { required: false, message: '请输入格子数!' },
          { pattern: /^-?\d+$/, message: '请输入整数!' },
        ],
        free: [
          { required: true, message: '请输入空闲格子数!' },
          { pattern: /^-?\d+$/, message: '请输入整数!' },
        ],
        paths:[
          {required: true, message: '请设置配送范围'},
          {validator:this.handleIsIn}
        ],
        selectedOrderType: [
          {required: true, message: '请选择接单类型!'},
        ],
        matchingType: [
          {required: true, message: '请选择配送范围类型!'},
        ],
      },
      url: {
        add: '/shoes/shoeLocker/add',
        edit: '/shoes/shoeLocker/edit',
        queryById: '/shoes/shoeLocker/queryById',
      },
      areaList: [],
      //以下变量与腾讯地图相关
      //=================
      map: null,
      temp: null,
      option: {
        center: new window.qq.maps.LatLng(24.500646, 118.12699), // 设置地图中心点坐标
        zoom: 12, // 设置地图缩放级别
        mapTypeId: window.qq.maps.MapTypeId.ROADMAP, //设置地图样式详情参见MapType
      },
      //markerLayer: [],
      markerLayer: '',
      markIsHover: false,

      mapKey: '4FPBZ-5YC6F-M2RJN-NBEC4-UQQEV-P2B2U',
      mapLatLng: null,
      mapCity: '',
      searchForm: {
        key: '',
      },
      addressList: [],
      markerList: [],
      markerEventList: [],
      areaJson: [],

      searchList: [],

      activePattern:'marker', //地图操作模式，marker设置机柜定位，polygon设置配送范围
      orderTypeOptions: [{"value":"self", "name":"自提"}, {"value": "service", "name":"配送"}],
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
    this.modelDefault = JSON.parse(JSON.stringify(this.model))
  },
  mounted() {
    const script = document.createElement('script')
    script.type = "text/javascript";
    script.src = `https://map.qq.com/api/gljs?v=1.exp&key=${this.mapKey}&callback=init&libraries=tools`;
    document.body.appendChild(script);

    const script1 = document.createElement('script')
    script1.type = "text/javascript";
    script1.src = `https://map.qq.com/api/gljs?v=1.exp&key=${this.mapKey}&callback=init&libraries=geometry`;
    document.body.appendChild(script1);
  },
  beforeDestroy() {
    this.destroyMap()
  },
  methods: {
    add() {
      // this.edit(this.modelDefault);
      this.model = {
        status: 1,
        type: 'real',
        address: '',
        longitude: '',
        latitude: '',
        orderStatus: 1,
        paths:''

      }
      let center = new window.qq.maps.LatLng(24.500646, 118.12699) // 设置地图中心点坐标
      this.option = {
        center: center, // 设置地图中心点坐标
        zoom: 12, // 设置地图缩放级别
        mapTypeId: qq.maps.MapTypeId.ROADMAP, //设置地图样式详情参见MapType
      }
      setTimeout(()=>{   //设置延迟执行
        this.initMapByJQ(24.500646, 118.12699)
      },1000);

    },
    edit(record) {
      this.model = Object.assign({}, record)
      this.model.orgCode = record.orgCode + ''
      this.model.departName = record.departName
      let center = new qq.maps.LatLng(record.latitude, record.longitude) // 设置地图中心点坐标
      this.option = {
        center: center, // 设置地图中心点坐标
        zoom: 16, // 设置地图缩放级别
        mapTypeId: window.qq.maps.MapTypeId.ROADMAP, //设置地图样式详情参见MapType
      }
      this.visible = true
      setTimeout(()=>{   //设置延迟执行
        this.initMapByJQ(record.latitude, record.longitude)
      },1000);
    },
    submitForm() {
      const that = this
      // 触发表单验证
      this.$refs.form.validate((valid) => {
        if (valid) {
          that.confirmLoading = true
          let httpurl = ''
          let method = ''
          if (!this.model.lockerId) {
            httpurl += this.url.add
            method = 'post'
          } else {
            httpurl += this.url.edit
            method = 'put'
          }

          //处理省市区
          // let province = this.model.province[0];
          // let city = this.model.province[1];
          // let area = this.model.province[2];

          let data = {
            lockerId: this.model.lockerId,
            orgCode: this.model.orgCode,
            lockerCode: this.model.lockerCode,
            name: this.model.name,
            status: this.model.status,
            province: this.model.province,
            city: this.model.city,
            area: this.model.area,
            address: this.model.address,
            longitude: this.model.longitude,
            latitude: this.model.latitude,
            num: this.model.num,
            type: this.model.type,
            weight: this.model.weight,
            orderStatus: this.model.orderStatus,
            paths:this.model.paths,
          }

          // console.log(data);
          httpAction(httpurl, data, method)
            .then((res) => {
              if (res.success) {
                that.$message.success(res.message)
                that.$emit('ok')
              } else {
                that.$message.warning(res.message)
              }
            }).finally(() => {
              that.confirmLoading = false
            })
          // that.confirmLoading = false;
        }
      })
    },
    getAreaList() {
      httpAction('/shoes/shoeLocker/getAreaList', null, 'get').then((res) => {
        let areaList = res.result

        this.areaList = areaList
      })
    },
    //=====================================================
    //以下是腾讯地图的方法
    //位置信息在地图上展示
    //js直接改造的方法
    initMapByJQ(lat, lng) {
      let _this = this

      let center = new TMap.LatLng(lat, lng) //设置中心点坐标(厦门sm)

      //初始化地图
      this.map = new TMap.Map('tencentMapBox', {
        //pitch: 30, //设置俯仰角度（0~45）
        zoom: 12, //设置地图缩放级别
        center: center, //设置地图中心点坐标
      })

      //初始化marker图层
      this.initMarker();

      //初始化几何图形及编辑器
      this.initGeometry()
    },

    //初始化几何图形及编辑器
    initGeometry() {
      let _this = this;

      let polygon;

      if (_this.model.paths){
        //初始化数据
        let simplePath = [];
        // let pathArr = JSON.parse(_this.paths)
        let pathArr = JSON.parse(this.model.paths)
        if (pathArr.length > 0) {
          pathArr.forEach(item => {
            simplePath.push(new TMap.LatLng(item.lat, item.lng))
          })
        }
        // 初始化几何图形及编辑器
        polygon = new TMap.MultiPolygon({
          map: _this.map,
          geometries:[{ paths:simplePath }],
        });
      }else{
        polygon = new TMap.MultiPolygon({
          map: _this.map,
        });
      }

      mapEditor = new TMap.tools.GeometryEditor({
        map:_this.map, // 编辑器绑定的地图对象
        overlayList: [ // 可编辑图层
          {
            overlay: polygon,
            id: 'polygon',
            drawingStyleId: 'highlight',
            selectedStyleId: 'highlight'  //选中样式
          }
        ],
        actionMode: TMap.tools.constants.EDITOR_ACTION.DRAW, // 编辑器的工作模式
        activeOverlayId: 'polygon', // 激活图层
        selectable: true, // 开启点选功能
        snappable: true // 开启吸附
      });
      mapEditor.setActiveOverlay('');

      // 监听绘制结束事件，获取绘制几何图形
      mapEditor.on('draw_complete', (geometry) => {
        if (mapEditor.getActiveOverlay().id === 'polygon'){
          let  polygonObj = mapEditor.getOverlayList();

          //只允许添加一个配送范围
          if ( polygonObj[0].overlay.geometries.length>1){
            polygon.remove(geometry.id);
            alert('只能添加一个配送范围');
          }else{
            let paths = _this.pathElems(geometry);
            _this.model.paths =JSON.stringify(paths)
            _this.$refs.form.validateField(['paths'])
            _this.$forceUpdate();
          }

          //设置为编辑模式
          mapEditor.setActionMode(TMap.tools.constants.EDITOR_ACTION.INTERACT);
        }
      });

      // 监听修改事件
      mapEditor.on('adjust_complete', (geometry) => {
        let paths = _this.pathElems(geometry);
        _this.model.paths =JSON.stringify(paths)
        _this.$refs.form.validateField(['paths'])
        this.$forceUpdate();
      });
    },

    /**
     * 判断机柜位置是否在配送范围内
     */
    isIn(){
      let latLngArr = this.model.paths;
      let lat =this.model.latitude;
      let lng = this.model.longitude;
      let pos= new TMap.LatLng(lat, lng);
      latLngArr = JSON.parse(latLngArr);
      let paths = [];
      latLngArr.forEach(item => {
        paths.push(new TMap.LatLng(item.lat, item.lng))
      })
      // 判断点是否在多边形内
      return TMap.geometry.isPointInPolygon(pos, paths)
    },

    handleIsIn(rule,value,callback){
        let flag = this.isIn();
        if(!flag){
          callback(new Error('机柜必须在配送范围内'))
        }else{
          callback()
        }
    },

    //格式化返回的经纬度
    pathElems(geometry){
      var lngLat = [];
      for (const item of geometry.paths) {
        const lng = item.getLng();
        const lat = item.getLat();
        lngLat.push({
          lat: lat,
          lng: lng
        });
      }
      return lngLat;
    },

    /**
     * 设置编辑模式
     * @param type  marker=设置机柜定位，polygon=设置配送范围
     */
    setActivePattern(type){
      console.log(type)
      this.activePattern = type;
      if (type==='marker'){
        mapEditor.setActiveOverlay('');
      }else{
        mapEditor.setActiveOverlay(type);
      }
    },

    //删除
    delPolygon(){
      mapEditor.setActionMode(TMap.tools.constants.EDITOR_ACTION.INTERACT);
      mapEditor.delete();
      let  polygonObj = mapEditor.getOverlayList();

      //只允许添加一个配送范围
      if ( polygonObj[0].overlay.geometries.length===0){
        this.model.paths ='';
        this.$forceUpdate();
      }
    },
    //添加
    addPolygon() {
      mapEditor.setActionMode(TMap.tools.constants.EDITOR_ACTION.DRAW);
    },
    //编辑
    editPolygon() {
      mapEditor.setActionMode(TMap.tools.constants.EDITOR_ACTION.INTERACT);
    },


    initMarker(){
      let _this = this;
      //初始化marker图层
      _this.markerLayer = new TMap.MultiMarker({
        id: 'marker-layer',
        map: this.map,
      })

      if (this.model.lockerId) {
        _this.markerLayer.updateGeometries([
          {
            styleId: 'marker',
            id: '1',
            position: new TMap.LatLng(this.model.latitude, this.model.longitude),
          },
        ])
      }

      //绑定点击事件
      this.selectPoint()
    },

    //marker图层地址选择事件
    selectPoint() {
      let _this = this
      //绑定点击事件
      this.map.on('click', (evt) => {
        //修改标记
          if (_this.activePattern === 'marker'){
            this.markerLayer.updateGeometries([
              {
                styleId: 'marker',
                id: '1',
                position: evt.latLng,
              },
            ])

            //经纬度赋值给input框
            var lat = evt.latLng.getLat().toFixed(6)
            var lng = evt.latLng.getLng().toFixed(6)

            $.ajax({
              type: 'get',
              async: false,
              url: 'https://apis.map.qq.com/ws/geocoder/v1',
              data: {
                location: evt.latLng.getLat() + ',' + evt.latLng.getLng(),
                key: '4FPBZ-5YC6F-M2RJN-NBEC4-UQQEV-P2B2U',
                get_poi: 1,
                output: 'jsonp',
              },
              dataType: 'jsonp',
              //jsonp: "callback",//传递给请求处理程序或页面的，用以获得jsonp回调函数名的参数名(一般默认为:callback)
              //jsonpCallback:"?",//自定义的jsonp回调函数名称，默认为jQuery自动生成的随机函数名，也可以写"?"，jQuery会自动为你处理数据
              success: (res) => {
                if (res.status === 0) {
                  let address = res.result !== undefined ? res.result.address : ''
                  let lng = res.result !== undefined ? res.result.location.lng : ''
                  let lat = res.result !== undefined ? res.result.location.lat : ''

                  this.model.address = address
                  this.model.longitude = lng
                  this.model.latitude = lat

                  this.model.province =
                    res.result.address_component.province !== undefined ? res.result.address_component.province : ''
                  this.model.city = res.result.address_component.city !== undefined ? res.result.address_component.city : ''
                  this.model.area =
                    res.result.address_component.district !== undefined ? res.result.address_component.district : ''
                  this.$refs.form.validateField(['address', 'longitude', 'latitude'])
                }
              },
              error: function () {
                //  alert('fail');
              },
            })
          }
      })
    },

    onSearch(searchValue) {
      let _this = this
      $.ajax({
        url: 'https://apis.map.qq.com/ws/place/v1/search',
        type: 'GET',
        async: false,
        data: {
          boundary: 'region(厦门,1)',
          key: '4FPBZ-5YC6F-M2RJN-NBEC4-UQQEV-P2B2U',
          output: 'jsonp',
          keyword: searchValue,
          page_size: 20,
          orderby: '_distance',
        },
        dataType: 'jsonp',
        success: function (res) {
          let str = ''
          _this.searchList = res.data
        },
      })
    },
    selectAddress(obj) {
      let lat = obj.location.lat
      let lng = obj.location.lng

      this.model.address = obj.address
      this.model.longitude = lng
      this.model.latitude = lat

      this.model.province = obj.ad_info.province
      this.model.city = obj.ad_info.city
      this.model.area = obj.ad_info.district

      this.markerLayer.updateGeometries([
        {
          styleId: 'marker',
          id: '1',
          position: new TMap.LatLng(lat, lng),
        },
      ])
      this.map.setCenter(new TMap.LatLng(lat, lng))
      this.$refs.form.validateField(['address','longitude','latitude'])
    },
    destroyMap() {
      this.map.destroy()
    },
  },
}
</script>
<style>
.diyDiv {
  width: 100%;
  height: 660px;
  overflow-y: scroll;
}
</style>