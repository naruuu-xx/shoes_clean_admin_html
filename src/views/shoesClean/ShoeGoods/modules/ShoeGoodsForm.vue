<template>
  <a-spin :spinning="confirmLoading">
    <j-form-container :disabled="formDisabled">
      <a-form-model ref="form" :model="model" :rules="validatorRules" slot="detail">
        <a-row>
          <a-col :span="24">
            <a-form-model-item label="商品名称" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="title">
              <a-input v-model="model.title" placeholder="请输入商品名称"  ></a-input>
            </a-form-model-item>
          </a-col>
          <a-col :span="24">
            <a-form-model-item label="描述" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="describe">
              <a-input v-model="model.describe" placeholder="请输入描述"  ></a-input>
            </a-form-model-item>
          </a-col>
          <a-col :span="24" >
            <a-form-model-item label="商品规格" :labelCol="labelCol" :wrapperCol="wrapperCol" >
                <a-button class="editable-add-btn" @click="handleAdd">
                  添加
                </a-button>
                <a-table bordered :data-source="dataSource" :columns="columns" >
                  <template slot="skuTitle" slot-scope="text, record" prop="skuTitle">
                    <editable-cell :text="text" @change="onCellChange(record.key, 'skuTitle', $event)" v-model="model.skuTitle" />
                  </template>
                  <template slot="price" slot-scope="text, record" prop="price">
                    <editable-cell :text="text" @change="onCellChange(record.key, 'price',$event)" v-model="model.price"/>
                  </template>
                  <template slot="operation" slot-scope="text, record">
                    <a-popconfirm
                      v-if="dataSource.length"
                      title="确定要删除该规格么?"
                      @confirm="() => onDelete(record.key)"
                    >
                      <a href="javascript:;">删除</a>
                    </a-popconfirm>
                  </template>
                </a-table>


            </a-form-model-item>
          </a-col>

          <a-col :span="24">
            <a-form-model-item label="主图" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="images">
              <!--              <a-textarea v-model="model.images" rows="4" placeholder="请输入主图" />-->
              <j-image-upload text="上传" v-model="model.images" :isMultiple = "true"></j-image-upload>
            </a-form-model-item>
          </a-col>
          <a-col :span="24">
            <a-form-model-item label="详情" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="content">
<!--              <a-textarea v-model="model.content" rows="4" placeholder="请输入详情" />-->
              <JEditor v-model="model.content" placeholder="请输入详情" ></JEditor>
            </a-form-model-item>

          </a-col>
<!--          <a-col :span="24">-->
<!--            <a-form-model-item label="销量" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="sale">-->
<!--              <a-input-number v-model="model.sale" placeholder="请输入销量" style="width: 100%" />-->
<!--            </a-form-model-item>-->
<!--          </a-col>-->
<!--          <a-col :span="24">-->
<!--            <a-form-model-item label="浏览量" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="pv">-->
<!--              <a-input-number v-model="model.pv" placeholder="请输入浏览量" style="width: 100%" />-->
<!--            </a-form-model-item>-->
<!--          </a-col>-->
          <a-col :span="24">
            <a-form-model-item label="权重" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="weight">
              <a-input-number v-model="model.weight" placeholder="请输入权重" style="width: 100%" />
            </a-form-model-item>
          </a-col>
          <a-col :span="24">
            <a-form-model-item label="状态" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="status">
<!--              <a-input-number v-model="model.status" placeholder="请输入状态:0=下架,1=上架" style="width: 100%" />-->
              <j-switch v-model="model.status"  ></j-switch>
            </a-form-model-item>
          </a-col>
        </a-row>
      </a-form-model>
    </j-form-container>
  </a-spin>
</template>

<script>
  import { httpAction, getAction } from '@/api/manage'
  import { JeecgListMixin } from '@/mixins/JeecgListMixin'
  import { mixinDevice } from '@/utils/mixin'


const EditableCell = {
  template: `
    <div class="editable-cell">
    <div v-if="editable" class="editable-cell-input-wrapper">
      <a-input :value="value" @change="handleChange" @pressEnter="check" :value="value" @input="inputChange" /><a-icon
      type="check"
      class="editable-cell-icon-check"
      @click="check"
    />
    </div>
    <div v-else class="editable-cell-text-wrapper">
      {{ value || ' ' }}
      <a-icon type="edit" class="editable-cell-icon" @click="edit" />
    </div>
    </div>
  `,
  props: {
    text: String,
  },
  model: {
    prop: "value", //绑定的值，通过父组件传递
    event: "input" //自定义时间名
  },
  data() {
    return {
      value: this.text,
      editable: false,
    };
  },
  methods: {

    handleChange(e) {
      const value = e.target.value;
      this.value = value;
    },
    inputchange(e){
        this.$emit("input", e.target.value);
    },
    check() {
      this.editable = false;
      this.$emit('change', this.value);
    },
    edit() {
      this.editable = true;
    },
  },
};

  export default {
    name: 'ShoeGoodsForm',
    mixins:[JeecgListMixin, mixinDevice],
    components: {
      EditableCell,
    },
    props: {
      //表单禁用
      disabled: {
        type: Boolean,
        default: false,
        required: false
      }
    },
    data () {
      return {
        model:{
         },
        labelCol: {
          xs: { span: 24 },
          sm: { span: 5 },
        },
        wrapperCol: {
          xs: { span: 24 },
          sm: { span: 16 },
        },
        confirmLoading: false,
        validatorRules: {
           title: [
              { required: true, message: '请输入商品名称!'},
           ],
           content: [
              { required: true, message: '请输入详情!'},
           ],
           weight: [
              { required: true, message: '请输入权重!'},
           ],
          goodsSku:[
            {required: true, message: '请填写商品规格！'},
          ],
          skuTitle: [
            {required: true, message: '请填写规格名称!'},
          ],
          price:[
            {required: true, message:'测'},
          ],
           status: [
              { required: true, message: '请输入状态'},
           ],
        },
        url: {
          add: "/shoes/shoeGoods/add",
          edit: "/shoes/shoeGoods/edit",
          queryById: "/shoes/shoeGoods/queryById"
        },
        typeList:[],
        dataSource:[

        ],
        columns: [
          {
          title: '产品名称',
          align:"center",
          dataIndex: 'skuTitle',
            scopedSlots: { customRender: 'skuTitle' },


        },
          {
            title: '价格',
            align: "center",
            dataIndex: "price",
            scopedSlots: { customRender: 'price' },

          },
          {
            title: '操作',
            dataIndex: 'operation',
            scopedSlots: { customRender: 'operation' },
          },

        ],
        count:0,


      }
    },
    computed: {
      formDisabled(){
        return this.disabled
      },
    },
    created () {
      this.getTypeList();
       //备份model原始值
      this.model.type="repair";
      this.modelDefault = JSON.parse(JSON.stringify(this.model));
    },
    methods: {
      onCellChange(key, dataIndex, value) {
        const dataSource = [...this.dataSource];

        const target = dataSource.find(item => item.key === key);
        if (target) {
          target[dataIndex] = value;
          this.dataSource = dataSource;
        }
      },
      onDelete(key) {
        console.log("这是key："+key);
        const dataSource = [...this.dataSource];
        console.log(dataSource);
        this.dataSource = dataSource.filter(item => item.key !== key);
      },
      handleAdd() {
        const { count, dataSource } = this;
        const newData = {
          key: count,
          skuTitle: '',
          price:'',
        };
        this.dataSource = [...dataSource, newData];
        this.count = count + 1;
      },

      add () {
        this.modelDefault.type="repair";
        this.edit(this.modelDefault);
      },
      edit (record) {
        this.model = Object.assign({}, record);
        this.visible = true;
      },
      submitForm () {
        const that = this;
        console.log(that.model.skuTitle);
        // 触发表单验证
        this.$refs.form.validate(valid => {
          if (valid) {
            that.confirmLoading = true;
            let httpurl = '';
            let method = '';
            if(!this.model.goodsId){
              httpurl+=this.url.add;
              method = 'post';
            }else{
              httpurl+=this.url.edit;
               method = 'put';
            }
            httpAction(httpurl,this.model,method).then((res)=>{
              if(res.success){
                that.$message.success(res.message);
                that.$emit('ok');
              }else{
                that.$message.warning(res.message);
              }
            }).finally(() => {
              that.confirmLoading = false;
            })
          }

        })
      },
      getTypeList() {
        httpAction("/shoes/shoeGoods/typeList", null, "get").then((res) => {
          if (res.success) {
            this.typeList = res.result;

          }
        })
      },

    },
  }
</script>

<style lang="less">
.editable-cell {
  position: relative;
}

.editable-cell-input-wrapper,
.editable-cell-text-wrapper {
  padding-right: 24px;
}

.editable-cell-text-wrapper {
  padding: 5px 24px 5px 5px;
}

.editable-cell-icon,
.editable-cell-icon-check {
  position: absolute;
  right: 0;
  width: 20px;
  cursor: pointer;
}

.editable-cell-icon {
  line-height: 18px;
  display: none;
}

.editable-cell-icon-check {
  line-height: 28px;
}

.editable-cell:hover .editable-cell-icon {
  display: inline-block;
}

.editable-cell-icon:hover,
.editable-cell-icon-check:hover {
  color: #108ee9;
}

.editable-add-btn {
  margin-bottom: 8px;
}
</style>