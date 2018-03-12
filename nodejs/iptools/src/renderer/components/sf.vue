<template>
    <div class="layout">
<!--        <Spin size="large" fix v-if="spinShow"></Spin>
        <Circle :percent="percent" :stroke-color="color">
            <Icon v-if="percent == 255" type="ios-checkmark-empty" size="60" style="color:#5cb85c"></Icon>
            <span v-else style="font-size:24px">{{ percent }}%</span>
        </Circle>-->
        <Spin fix  v-if="spinShow">
            <Icon type="load-c" size=30 class="demo-spin-icon-load"></Icon>
            <div>Loading</div>
        </Spin>
        <Layout>
            <Header class="header">IP配置</Header>
            <Content>
                <Form :model="formips" label-position="left" :label-width="100">
                    <FormItem label="起始IP：">
                        <Input v-model="formips.ipstart"></Input>
                    </FormItem>
                    <FormItem label="结束IP：">
                        <Input v-model="formips.ipend"></Input>
                    </FormItem>
                    <FormItem label="子网掩码：">
                        <Input v-model="formips.mask"></Input>
                    </FormItem>
                    <FormItem label="网关：">
                        <Input v-model="formips.gateway"></Input>
                    </FormItem>
                    <FormItem label="DNS1：">
                        <Input v-model="formips.dns1"></Input>
                    </FormItem>
                    <FormItem label="DNS2：">
                        <Input v-model="formips.dns2"></Input>
                    </FormItem>
                    <FormItem>
                        <Button type="primary"  @click="scan()">扫描网段</Button>
                        <Button type="ghost"  @click="setip()" style="margin-left: 8px">设置静态IP</Button>
                    </FormItem>
                </Form>

                <Table height="400"  border :columns="columns" :data="datas" ></Table>
            </Content>
           <!-- <Footer>
                <Button type="success" long @click="scan()">SUBMIT</Button>
            </Footer>-->
        </Layout>
    </div>

</template>
<style>
    .header {
        color: #2d8cf0;
    }
    .demo-spin-icon-load{
        animation: ani-demo-spin 1s linear infinite;
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
    import {ScanIP} from './../../ScanIP.ts'
    import axios, {AxiosInstance, AxiosPromise,AxiosResponse} from "axios";

    // export default class MyClass { /* ... */ } ==> import MyClassAlias from "./MyClass";
    // export class MyClass { /* ... */ } == > import {MyClass} from "./MyClass";
    @Component
    export default class sf extends Vue {
        public spinShow:boolean=false;
        public datas:any=[];
        public  columns:any =[];
        public ips:Array<string>=new Array<string>();
        public formips:any= {
            ipstart: '192.168.1.1',
            ipend: '192.168.1.255',
            mask: '255.255.255.0',
            gateway: '192.168.1.1',
            dns1:'8.8.8.8',
            dns2:'8.8.4.4'
        };
        public staticip:any= {
            ip: '192.168.1.1',
            mask: '255.255.255.0',
            gateway: '192.168.1.1',
            dns1:'8.8.8.8',
            dns2:'8.8.4.4'
        };

        private scanIP:ScanIP;
        constructor(){
            super();
            this.scanIP=new ScanIP("192.168.1.1","192.168.1.255",8182);
            this.scanIP.setOnScanEnd(this.onScanEnd);
            this.update.bind(this);
        }
        public onScanEnd():void{
            this.ips =this.scanIP.getResult();
            console.log("onScanEnd "+this.ips);
            for(let i=0;i<this.ips.length;i++){
                var ipp =this.ips[i];
       /*         var strfmt ='[{"ip":"'+ipp+'"},{"status":"'+0+'"}]';
                console.log(strfmt);
                this.datas.push(JSON.parse(strfmt));*/
                var strfmt =  {"ip": ipp,"status": "0"} ;
                console.log(strfmt);
                this.datas.push( (strfmt));
            }
            this.spinShow=false;
        }
        public update(strfmt:any){
            this.datas.push( (strfmt));
        }
         public async setip() {
            this.staticip.mask=this.formips.mask;
            this.staticip.gateway=this.staticip.gateway;
            this.staticip.dns1=this.formips.dns1;
            this.staticip.dns2=this.formips.dns2;
            for(let i=0;i<this.ips.length;i++){
                var ipp = this.ips[i];
                this.staticip.ip=ScanIP.int2ip(ScanIP.ip2int(this.formips.ipstart)+i);
                console.log("setip:"+JSON.stringify(this.staticip));
                // axios.post("http://"+ipp+":8182",JSON.stringify(this.staticip)).then(function (response) {
                //     console.log(response.status);
                //     var strfmt =  {"ip": ipp,"status": response.status} ;
                //     console.log(strfmt);
                //     this.update(strfmt);
                // });
                const response = await axios.post("http://"+ipp+":8182",JSON.stringify(this.staticip));

                var strfmt =  {"ip": ipp,"status": "200"} ;
                console.log(strfmt);
                this.datas[i].status=200;
            }
        }
        public scan():void{
            let ss=this.formips.ipstart.split('.');
            let sss=ss[0]+'.'+ss[1]+'.'+ss[2]+'.';
            this.scanIP=new ScanIP(sss+"1",sss+"255",8182);
            this.scanIP.setOnScanEnd(this.onScanEnd);
            this.spinShow=true;
            //console.log("scan "+this.formLeft.input1);
            this.scanIP.scan(100);
        }
        // lifecycle hook
        public mounted ():void {
            console.log("mounted");
            // let str:string ='[{"title" :"IP","key":"ip"},{"title" :"状态","key":"status"}]';
            // let str ="[{title :'IP',key:'ip'},{title :'status',key:'status'}]";
            this.columns =[{title :"IP",key:"ip"},{title :"status",key:"status"}];//.push( (str));
/*            let s:any=JSON.parse(str);
            this.columns.push(JSON.parse(str));*/

        }



    }
</script>