import * as http from "http";
import { IncomingMessage,IncomingHttpHeaders,ServerResponse} from "http";

function  httpsrv(req:IncomingMessage,res:ServerResponse){
    //console.log(req);
    let body:string = "";
    //每当接收到请求体数据，累加到post中
    req.on('data', function (chunk) {
        body += chunk;  //一定要使用+=，如果body=chunk，因为请求favicon.ico，body会等于{}
        // console.log("chunk:",chunk);
    });
    //在end事件触发后，通过querystring.parse将post解析为真正的POST请求格式，然后向客户端返回。
    req.on('end', function () {
        console.log("body:",body);
        res.writeHead(200);
        res.end('Hello1 Typescript!');
    });

}
function listen(){
    console.log('listening');
}

let httpServer:http.Server = http.createServer(httpsrv);
httpServer.listen(8182,listen);