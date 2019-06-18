var WebSocketServer = require('websocket').server;//获取websocketserver模块

var http = require('http');//获取http模块

//建立http服务器对象

var server = http.createServer(function(request, response) {

console.log((new Date()) + ' Received request for ' + request.url);

response.writeHead(404);

response.end();

});

 

//http服务器对象监听端口8080

server.listen(9999, function() {

console.log((new Date()) + ' Server is listening on port 8080');

});

//建立WebSocketServer对象 绑定http服务器对象

wsServer = new WebSocketServer({

httpServer: server,

// You should not use autoAcceptConnections for production

// applications, as it defeats all standard cross-origin protection

// facilities built into the protocol and the browser. You should

// *always* verify the connection's origin and decide whether or not

// to accept it.

autoAcceptConnections: false

});

//验证是否时允许来源的请求

function originIsAllowed(origin) {

// put logic here to detect whether the specified origin is allowed.

return true;

}

 

wsServer.on('request', function(request)

{

if (!originIsAllowed(request.origin)) //不是允许来源的请求 就拒绝连接 确保我们只接受来自允许来源的请求

{

request.reject();

console.log((new Date()) + ' Connection from origin ' + ' rejected.');

return;

}

//同意连接

var connection = request.accept(request.origin);

console.log((new Date()) + connection.remoteAddress +' Connection accepted.');

//监听这个连接 收到客户端发来的消息执行

connection.on('message', function(message)

{

if (message.type === 'utf8')

{

console.log('Received Message: ' + message.utf8Data);

connection.sendUTF("来自服务器的消息:我收到你的消息了"+connection.remoteAddress+" "+message.utf8Data);

}

else if (message.type === 'binary')

{

console.log('Received Binary Message of ' + message.binaryData.length + ' bytes');

connection.sendBytes(message.binaryData);

}

});

 

//监听的连接关闭时

connection.on('close', function(reasonCode, description)

{

console.log((new Date()) + ' Peer ' + connection.remoteAddress + ' disconnected.');

});

 

});
// --------------------- 
// 作者：爆肝码农 
// 来源：CSDN 
// 原文：https://blog.csdn.net/qq_36984465/article/details/89520026 
// 版权声明：本文为博主原创文章，转载请附上博文链接！