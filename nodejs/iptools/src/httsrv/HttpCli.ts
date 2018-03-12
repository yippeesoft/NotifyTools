import * as http from "http";
import {RequestOptions, OutgoingHttpHeaders, ServerResponse, ClientRequest, IncomingMessage} from "http";
import axios, {AxiosInstance, AxiosPromise} from "axios";

function income(res:IncomingMessage){
    // console.log('-----income-------',res);
    res.setEncoding('utf-8');

    var responseString = '';

    res.on('data', function(data) {
        responseString += data;
    });

    res.on('end', function() {
        //这里接收的参数是字符串形式,需要格式化成json格式使用
        // var resultObject = JSON.parse(responseString);
        console.log('-----resBody-----',responseString);
    });

}
let httpcli:http.ClientRequest;

function request(opt:RequestOptions){
    httpcli = http.request(opt ,income);
    httpcli.on('error', function(e:Error) {
        // TODO: handle error.
        console.log('-----error-------',e);
    });
    console.log('-----request-------',opt);
    httpcli.write(strpost)
}

function reqAxios(){
    var axiosInstan:AxiosPromise=axios.get("http://192.168.9.111");

}
let strpost:string="{'AA':'BBB'}";
let headers:OutgoingHttpHeaders={};
headers["Content-Type"]='application/json';
headers['Content-Length']=strpost.length;

let opts:RequestOptions={};
opts.hostname="192.168.1.123";
opts.port=8182;
opts.path="/";
opts.method="post";
opts.headers=headers;

function fun1(msg:string):void{
    alert(msg);
}
var message = new Function('msg','console.log(msg)');
message("AAAA");
//request(opts);
