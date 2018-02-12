<template>
    <div class="layout">
        <Layout>
            <Header>Header</Header>
            <Content>
                <Table border :columns="columns" :data="datas" ></Table>
            </Content>
            <Footer>
                <Button type="success" long @click="created()">SUBMIT</Button>
            </Footer>
        </Layout>
    </div>

</template>
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
    import {ArrayList, HashMap} from "typescriptcollectionsframework";

    @Component
    export default class sf extends Vue {

        public datas:any=[];
        public  columns:any =[];
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

            //     var map=new Object();
            //     map["title"]="title"+i ;
            //     map["key"]="key"+i ;
            //
            //     this.datas.add(map)
            //     // let m:object={"titile":"AA"};
            //     // var key1 = "title";
            //     // var key2 = "key";
            //     // m[key1]=key1+i;
            //     // m[key2]=key2+i;
            //     // this.datas[i]=m;
            // }

        }


    }
</script>