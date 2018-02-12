<template>
    <div class="layout">
        <Layout>
            <Header class="header">IP配置</Header>
            <Content>
                <Form :model="formLeft" label-position="left" :label-width="100">
                    <FormItem label="Title">
                        <Input v-model="formLeft.input1"></Input>
                    </FormItem>
                    <FormItem label="Title name">
                        <Input v-model="formLeft.input2"></Input>
                    </FormItem>
                    <FormItem label="Aligned title">
                        <Input v-model="formLeft.input3"></Input>
                    </FormItem>
                    <FormItem>
                        <Button type="primary"  >Submit</Button>
                        <Button type="ghost"   style="margin-left: 8px">Reset</Button>
                    </FormItem>
                </Form>

                <Table height="400"  border :columns="columns" :data="datas" ></Table>
            </Content>
            <Footer>
                <Button type="success" long @click="tst()">SUBMIT</Button>
            </Footer>
        </Layout>
    </div>

</template>
<style>
    .header {
        color: #2d8cf0;
    }
</style>
<!--<script>
    export default {
        data() {
            return {
                columns: [
                    {
                        title: '日期',
                        key: 'date',
                        sortable: true
                    },
                    {
                        title: '姓名',
                        key: 'name'
                    }

                ],
                datas: [
                    {
                        name: '王小明',
                        age: 18,
                        address: '北京市朝阳区芍药居',
                        date: '2016-10-03'
                    }

                ]
            }
        },

        methods: {
            created() {
                this.datas.push({
                    name: 'aaa',
                    age: 18,
                    address: '北京市朝阳区芍药居',
                    date: '2016-10-03'
                });
            }
        }
    }
</script>-->
<script lang="ts">
    import Vue from 'vue'
    import Component from 'vue-class-component'
    import iview from 'iview'
    import {ArrayList, HashMap} from "typescriptcollectionsframework";
    import 'iview/dist/styles/iview.css'    // 使用 CSS
    import ScanIP from './../../ScanIP'

    @Component
    export default class sf extends Vue {

        public datas:any=[];
        public  columns:any =[];
        public formLeft:any= {
            input1: '',
            input2: '',
            input3: ''
        };

        public tst():void{
            console.log("created "+this.formLeft.input1);
        }
        // lifecycle hook
        public mounted ():void {
            console.log("mounted");
            let str:string ='{"title" :"IP","key":"ip"}';
            // let s:any=JSON.parse(str);
            this.columns.push(JSON.parse(str));


            for(let i=0;i<40;i++){
                var ipp =''+i;
                var strfmt ='{"ip":"ip'+ipp+'"}';
                this.datas.push(JSON.parse(strfmt));
            }

        }


    }
</script>