'use strict';
var WebSocketClient = require('websocket').client;
let option = {
  length: 12000,      
  // portMpa: [8009],
  // ip: '127.0.0.1',
  isLogin: false,
  firstLogin: true,
  // portMpa: [7019,7020,7021,7022],
  // portMpa: [27009], // sccs
  portMpa: [9999],
  ip: '192.168.1.2',
  // ip: '192.168.66.165',
  // isHttp: true,
  isHttp: false
}

function start() {
var WebSocket = new WebSocket("ws://192.168.1.2:9999");
WebSocket.onopen = function(){
  console.log('websocket open');
  document.getElementById("recv").innerHTML = "Connected";
}
WebSocket.onclose = function(){
  console.log('websocket close');
}
WebSocket.onmessage = function(e){
  console.log(e.data);
  document.getElementById("recv").innerHTML = e.data;
}
document.getElementById("sendBtn").onclick = function(){
  var txt = document.getElementById("sendTxt").value;
  WebSocket.send(txt);
}
return WebSocket;
}

const sendData = (WebSocket,  data) => {
  return new Promise((resolve, reject) => {
    WebSocket.send(data);
  });
}


/**
 * 多个终端登入
 * @param {*} option 
 */
const multitudeBoxLogin = async (option) => {
  try {
    const { length, portMpa, ip, isLogin, isHttp, firstLogin } = option
    const cookieObj = 0; // = await http.getCookie(isHttp, ip, portMpa[0])
    let discount = 0;
    console.log(cookieObj)
    console.log(`${ip}:${portMpa[0]}`)
    const sockets = Array.apply(null, { length: length })
    let count = 0
    for (let i = 0; i < length; i++) {

      var client = new WebSocketClient();

      client.on('connectFailed', function(error) {
        discount++;
        count--;
        console.log(` -- 第${i}个 -- connectFailed  --   -- ,断开连接数:${discount}`)
      });

      client.on('connect', function(connection) {
        count++;
        // console.log(` -- 第${i}个 --   -- 连接 -- 目前连接总数 ${count} -- `);
        connection.send(i);
          connection.on('error', function(error) {
            console.log(` -- 第${i}个 -- 断开 -- error: ${error} -- ,断开连接数:${discount}`)
          });
          connection.on('close', function() {
            discount++;
            count--;
            console.log(` -- 第${i}个 -- 断开 --   -- ,断开连接数:${discount}`)
          });
          connection.on('message', function(message) {
              if (message.type === 'utf8') {
                  // console.log("Received: '" + message.utf8Data + "'");
              }
          });

         
      });
      client.connect('ws://localhost:9999/');
       
 
    }
  } catch (e) {
    console.log(e)
  }
}

multitudeBoxLogin(option)
// init()