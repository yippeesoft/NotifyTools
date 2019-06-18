'use strict';
// const http = require('./http-request')
const { start, sendData } = require('./socket-client')
 
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
      let socket = start(cookieObj, portMpa[i % portMpa.length], ip, isHttp, firstLogin, `A${i.toString().padStart(10, '0')}`)
      // socket.open()
      socket.on('connect', async () => {
        count = sockets.filter(socket => {
          return socket.connected
        }).length
        // isLogin && boxLogin(socket, 1, '.1.2.', !firstLogin && `A${i.toString().padStart(10, '0')}`)
        socket.emit('/api/v1/box/login', `目前连接总数 ${count}`);
        console.log(` -- 第${i}个 -- socket.id: ${socket.id} -- 连接 -- 目前连接总数 ${count} -- `);
      });
      socket.on('error', (e) => {
        console.log('connect error', e);
      });
      socket.on('/api/v1/box/command', (data)=>{
        console.log(data)
      })
      socket.on('disconnect', (reason) => {
        discount++;
        count--;
        console.log(` -- 第${i}个 -- 断开 -- reason: ${reason} -- ,断开连接数:${discount}`)
      })
      sockets[i] = socket
    }
  } catch (e) {
    console.log(e)
  }
}


module.exports = {
 
  multitudeBoxLogin
}