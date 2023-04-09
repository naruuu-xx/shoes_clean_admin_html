<template>
  <a-spin :spinning="confirmLoading">
    <j-form-container :disabled="formDisabled">
      <a-form-model ref="form" :model="model" :rules="validatorRules" slot="detail">
        <div class="diyDiv">
          <a-row>

            <a-col :span="24">
              <a-form-model-item label="站点名称" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="lockerName">
                <a-input v-model="model.lockerName" placeholder="请输入站点名称" autocomplete="off"></a-input>
              </a-form-model-item>
            </a-col>
            <a-col :span="24">
              <a-form-model-item label="区域" :labelCol="labelCol" :wrapperCol="wrapperCol">
                <h4>&nbsp;{{ this.departName }}</h4>
              </a-form-model-item>
            </a-col>
            <a-col :span="24">
              <a-form-model-item label="站长姓名" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="name">
                <a-input v-model="model.name" placeholder="请输入站长姓名" autocomplete="off"></a-input>
              </a-form-model-item>
            </a-col>
            <a-col :span="24">
              <a-form-model-item label="手机号" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="phone">
                <a-input placeholder="请输入手机号" v-model="model.phone"></a-input>
              </a-form-model-item>
            </a-col>

            <a-col :span="24" >
              <a-form-model-item label="绑定小程序账号" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="userId">
                <XfSelect
                  :list="weekList"
                  @change="checkedSelect"
                  @changeList="changeSelect"
                  v-model="model.userId"
                  :url='`/shoes/shoeUser/getUserListBytype?type=site`'
                >
                </XfSelect>
              </a-form-model-item>
            </a-col>


            <a-col :span="24">
              <a-form-model-item label="银行卡号" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="cardNo">
                <a-input v-model="model.cardNo" placeholder="请输入银行卡号"></a-input>
              </a-form-model-item>
            </a-col>

            <a-col :span="24">
              <a-form-model-item label="持卡人" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="cardName">
                <a-input v-model="model.cardName" placeholder="请输入持卡人"></a-input>
              </a-form-model-item>
            </a-col>
            <a-col :span="24">
              <a-form-model-item label="开户行" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="bank">
                <a-input v-model="model.bank" placeholder="请输入开户行"></a-input>
              </a-form-model-item>
            </a-col>

            <a-col :span="24">
              <a-form-model-item label="开户行地址" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="openBank">
                <a-input v-model="model.openBank" placeholder="请输入开户行地址"></a-input>
              </a-form-model-item>
            </a-col>

            <a-col :span="24">
              <a-form-model-item label="状态" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="statusRadio">
                <a-radio-group v-model:value="model.statusRadio">
                  <a-radio value="1">启用</a-radio>
                  <a-radio value="0">禁用</a-radio>
                </a-radio-group>
              </a-form-model-item>
            </a-col>

            <a-col :span="24">
              <a-form-model-item label="是否接单" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="orderStatusRadio">
                <a-radio-group v-model:value="model.orderStatusRadio">
                  <a-radio value="1">是</a-radio>
                  <a-radio value="0">否</a-radio>
                </a-radio-group>
              </a-form-model-item>
            </a-col>

            <a-col :span="24">
              <a-form-model-item label="详细地址" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="address">
                <!--              <a-input v-model="model.address" placeholder="请输入详细地址" id="c-address" :change="addressOnchange()"></a-input>-->
                <a-input-search v-model="model.address" placeholder="请输入详细地址" id="c-address" enter-button
                                @search="onSearch(model.address)" autocomplete="off"></a-input-search>
              </a-form-model-item>
            </a-col>
            <a-col :span="24">
              <a-form-model-item label="经度" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="longitude">
                <a-input-number v-model="model.longitude" placeholder="请输入经度" style="width: 100%" id="c-lng"
                                :disabled="false"/>
              </a-form-model-item>
            </a-col>
            <a-col :span="24">
              <a-form-model-item label="纬度" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="latitude">
                <a-input-number v-model="model.latitude" placeholder="请输入纬度" style="width: 100%" id="c-lat"
                                :disabled="false"/>
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
                  <div>
                    <button
                      @click="setActivePattern('polygon')"
                      :class="['ant-btn', activePattern==='polygon'?'ant-btn-primary':'']"
                      style="margin: 0 30px 0 30px">
                      设置配送范围
                    </button>
                  </div>
                  <div v-if="activePattern==='polygon'">
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
                  <div id="tencentMapBox" style="width:auto;height:400px;margin-left: 200px;margin-bottom: 30px"></div>
                </a-col>
                <a-col :span="8">
                  <div id="container-text" style="width:auto;height: 400px;margin-left: 5px; overflow-y:auto;">
                    <div v-model="searchList" v-for="(item, index) in searchList" style="margin-bottom: 10px"
                         v-on:click="selectAddress(item)">
                      <span style="font-size: 14px">{{ index + 1 }}、{{ item.title }}</span><br>
                      <span style="font-size: 12px; color: #7A7B7D">{{ item.address }}</span>
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

import {httpAction, getAction} from '@/api/manage'
import {validateDuplicateValue} from '@/utils/util'
import AlCascader from '@views/shoesClean/ShoeLocker/modules/al-cascader'
import $ from 'jquery'
import debounce from '@/utils/debounce'
import XfSelect from '@/components/Xf/XfSelect'


let map, marker, polygon, ap,mapEditor;

export default {
  name: 'ShoeLockerForm',
  components: {
    AlCascader,
    XfSelect
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
      weekList:[],
      model: {
        lockerName:"",
        cardNo:"",
        statusRadio:"",
        cardName:"",
        bank:"",
        openBank:"",
        address:"",
        latitude:"",
        longitude:"",
        userId:"",
        name:"",
        phone:"",
        orderStatusRadio:"",
        paths:'',

      },
      disabledStatus: false,
      departName: '',
      value:'',

      shoeUserList: [],
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
        name: [
          {required: true, message: '请输入站长姓名!'},
        ],
        lockerName: [
          {required: true, message: '请输入站点名称!'},
        ],
        statusRadio: [
          {required: true, message: '请选择状态'},
        ],
        orderStatusRadio: [
          {required: true, message: '请选择接单状态'},
        ],
        phone: [
          {required: true, message: '请输入手机号!'},
          {pattern: /^1[3456789]\d{9}$/, message: '请输入正确的手机号码!'},
        ],
        cardNo: [
          {required: true, message: '请输入银行卡号!'},
        ],
        cardName: [
          {required: true, message: '请输入持卡人!'},
        ],
        bank: [
          {required: true, message: '请输入开户行!'},
        ],
        openBank: [
          {required: true, message: '请输入开户行地址!'},
        ],
        userId: [
          {required: true, message: '请选择绑定小程序用户!'},
        ],
        longitude: [
          {required: true, message: '请输入经度!'},
          {pattern: /^-?\d+\.?\d*$/, message: '请输入数字!'},
        ],
        latitude: [
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
        paths:[
          {required: true, message: '请设置配送范围'},
          {validator:this.handleIsIn}
        ]

      },
      url: {
        add: "/shoes/shoeLocker/addBySitemanager",
        edit: "/shoes/shoeLocker/editBySitemanager",
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

      searchList: [],

      userList: [],
      fetching: false,
      lastFetchId: 0,

      activePattern:'marker', //地图操作模式，marker设置机柜定位，polygon设置配送范围
      //=================
    }
  },
  computed: {
    formDisabled() {
      return this.disabled
    },
  },
  created() {
    this.getDepartName();
    //备份model原始值address
    this.modelDefault = JSON.parse(JSON.stringify(this.model));
  },
  beforeDestroy() {
    this.destroyMap()
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
  methods: {
    changeSelect(data) {
      this.weekList = data.records.map(item => ({
        label: item.nickname+'('+item.phone+')',
        value: +item.userId
      }));
    },
    checkedSelect(val) {
    },
    add() {
      // this.edit(this.modelDefault);
      this.disabledStatus = false;
      this.model = {
        status: 1,
        type: "real",
        statusRadio: '0',
        address:"",
        longitude:"",
        latitude:"",
        orderStatusRadio: "1",
        paths: "",
      };
      let center = new window.qq.maps.LatLng(24.500646, 118.126990);// 设置地图中心点坐标
      this.option = {
        center: center,// 设置地图中心点坐标
        zoom: 12, // 设置地图缩放级别
        mapTypeId: qq.maps.MapTypeId.ROADMAP  //设置地图样式详情参见MapType
      };
      setTimeout(()=>{   //设置延迟执行
        this.initMapByJQ(24.500646, 118.12699)
      },1000);
    },
    edit(record) {

      this.disabledStatus = true;

      Object.assign(this.model, record, {orderStatusRadio: record.orderStatus + ""});
      this.model.orgCode = record.orgCode + "";
      //this.model.departName = record.departName;
      this.model.sitemanagerId = record.sitemanagerId;


      httpAction("/shoes/shoeLocker/getEdit?id="+record.sitemanagerId, "", "get").then((res)=> {
        this.model.lockerName = res.name;
        this.model.cardNo=res.cardNo;
        this.model.statusRadio=res.statusRadio+ "";
        this.model.cardName=res.cardName;
        this.model.bank=res.bank;
        this.model.openBank=res.openBank;
        this.model.address=res.address;
        this.model.latitude=res.latitude;
        this.model.longitude=res.longitude;
        this.model.userId=res.nickname[0].userId;
        this.weekList.push({label:res.nickname[0].nickname+"("+res.nickname[0].phone+")",value:res.nickname[0].userId});
        this.model.paths=res.paths;

        let center = new qq.maps.LatLng(res.latitude, res.longitude);// 设置地图中心点坐标
        this.option = {
          center: center,// 设置地图中心点坐标
          zoom: 16, // 设置地图缩放级别
          mapTypeId: window.qq.maps.MapTypeId.ROADMAP  //设置地图样式详情参见MapType
        };
        this.visible = true;

        setTimeout(()=>{   //设置延迟执行
          this.initMapByJQ(res.latitude, res.longitude)
        },1000);

      })

      this.getShoeUserList();

    },
    fetchUser (value) {
      debounce(() => {
        this.lastFetchId += 1;

        this.userList = [];

        this.fetching = true;

        httpAction("/shoes/shoeUser/queryWXUserList?searchWord="+value, null, "get").then((res) => {
          this.userList = res.result;
          this.fetching = false;
        })
      }, 1000);
    },
    handleChange (value) {
      Object.assign(this.model, {userId: value.key});
      Object.assign(this, {
        value,
        userList: [],
        fetching: false,
      });
    },
    submitForm() {
      const that = this;
      // 触发表单验证
      this.$refs.form.validate(valid => {
        if (valid) {
          that.confirmLoading = true;
          let httpurl = '';
          let method = '';
          if (!this.model.sitemanagerId) {
            httpurl += this.url.add;
            method = 'post';
          } else {
            httpurl += this.url.edit;
            method = 'put';
          }

          //处理省市区
          // let province = this.model.province[0];
          // let city = this.model.province[1];
          // let area = this.model.province[2];

          let data = {
            "lockerName": this.model.lockerName,
            "departName": this.model.departName,
            "name": this.model.name,
            "status": this.model.statusRadio,
            "phone": this.model.phone,
            "userId": this.model.userId,
            "cardNo": this.model.cardNo,
            "bank": this.model.bank,
            "openBank": this.model.openBank,
            "cardName": this.model.cardName,
            "province": this.model.province,
            "city": this.model.city,
            "area": this.model.area,
            "address": this.model.address,
            "longitude": this.model.longitude,
            "latitude": this.model.latitude,
            "num": this.model.num,
            "type": this.model.type,
            "sitemanagerId": this.model.sitemanagerId,
            "orderStatus":this.model.orderStatusRadio,
            "paths":this.model.paths,
          }

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
    destroyMap() {
      this.map.destroy();
    },

    getAreaList() {
      httpAction("/shoes/shoeLocker/getAreaList", null, "get").then((res) => {
        let areaList = res.result;

        this.areaList = areaList;
      })
    },
    //=====================================================
    //以下是腾讯地图的方法
    //加载地图
    initMapByJQ(lat, lng) {
      let _this = this;

      let center = new TMap.LatLng(lat, lng);//设置中心点坐标(厦门sm)

      //初始化地图
      this.map = new TMap.Map("tencentMapBox", {
        //pitch: 30, //设置俯仰角度（0~45）
        zoom: 12,//设置地图缩放级别
        center: center //设置地图中心点坐标
      });

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
        // activeOverlayId: 'polygon', // 激活图层
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
            this.$forceUpdate();
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
      let _this=this;
      //初始化marker图层
      _this.markerLayer = new TMap.MultiMarker({
        id: 'marker-layer',
        map: this.map
      });

      if (this.model.lockerId) {
        _this.markerLayer.updateGeometries([
          {
            "styleId": "marker",
            "id": "1",
            "position": new TMap.LatLng(this.model.latitude, this.model.longitude)
          }
        ])
      }

      //绑定点击事件
      this.selectPoint()
    },

    //marker图层地址选择事件
    selectPoint(){
      let _this=this;
      //绑定点击事件
      this.map.on('click', (evt)=> {
        //修改标记
        if (_this.activePattern === 'marker'){
          this.markerLayer.updateGeometries([
            {
              "styleId": "marker",
              "id": "1",
              "position": evt.latLng,
            }
          ])

          //经纬度赋值给input框
          var lat = evt.latLng.getLat().toFixed(6);
          var lng = evt.latLng.getLng().toFixed(6);

          $.ajax({
            type: "get",
            async: false,
            url: "https://apis.map.qq.com/ws/geocoder/v1",
            data: {
              location: evt.latLng.getLat() + "," + evt.latLng.getLng(),
              key: '4FPBZ-5YC6F-M2RJN-NBEC4-UQQEV-P2B2U',
              get_poi: 1,
              output: "jsonp"
            },
            dataType: "jsonp",
            //jsonp: "callback",//传递给请求处理程序或页面的，用以获得jsonp回调函数名的参数名(一般默认为:callback)
            //jsonpCallback:"?",//自定义的jsonp回调函数名称，默认为jQuery自动生成的随机函数名，也可以写"?"，jQuery会自动为你处理数据
            success: (res)=> {
              if (res.status === 0) {
                let address = res.result !== undefined ? res.result.address : "";
                let lng = res.result !== undefined ? res.result.location.lng : null;
                let lat = res.result !== undefined ? res.result.location.lat : null;

                this.model.address = address;
                this.model.longitude = lng;
                this.model.latitude = lat;

                this.model.province = res.result.address_component.province !== undefined ? res.result.address_component.province : "";
                this.model.city = res.result.address_component.city !== undefined ? res.result.address_component.city : "";
                this.model.area = res.result.address_component.district !== undefined ? res.result.address_component.district : "";
                this.$refs.form.validateField(['address','longitude','latitude'])
              }
            },
            error: function () {
              //  alert('fail');
            }
          })
        }
      })
    },

    onSearch(searchValue) {
      let _this = this;
      $.ajax({
        url: 'https://apis.map.qq.com/ws/place/v1/search',
        type: 'GET',
        async: false,
        data: {
          boundary: "region(厦门,1)",
          key: '4FPBZ-5YC6F-M2RJN-NBEC4-UQQEV-P2B2U',
          output: "jsonp",
          keyword: searchValue,
          page_size: 20,
          orderby: '_distance'
        },
        dataType: "jsonp",
        success: function (res) {
          let str = '';
          _this.searchList = res.data;
        }
      })
    },
    selectAddress(obj) {
      let lat = obj.location.lat;
      let lng = obj.location.lng;

      this.model.address = obj.address;

      this.model.longitude = lng;

      this.model.latitude = lat;

      this.model.province = obj.ad_info.province;
      this.model.city = obj.ad_info.city;
      this.model.area = obj.ad_info.district;

      this.markerLayer.updateGeometries([
        {
          "styleId": "marker",
          "id": "1",
          "position": new TMap.LatLng(lat, lng)
        }
      ])
      this.map.setCenter(new TMap.LatLng(lat, lng))
      this.$refs.form.validateField(['address','longitude','latitude'])
    },
    getShoeUserList() {
      httpAction("/shoes/shoeUser/shoeUserListBySitemanagerId?sitemanagerId=" + this.model.sitemanagerId, "", "get").then((res) => {
        if (res) {
          this.shoeUserList = res.result;
        }
      })
    },
    getDepartName() {
      httpAction("/shoes/shoeLocker/getDepartNameBySitemanager", "", "get").then((res) => {
        if (res) {
          this.departName = res.departName;

        }
      })
    },
  }
}
</script>
<style>
.diyDiv {
  width: 100%;
  height: 660px;
  overflow-y: scroll;
}
</style>