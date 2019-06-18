'use strict';

const io = require('socket.io-client');
// const http = require('./http-request')

const start = (cookieObj, port, ip, isHttp = false, firstLogin = false, boxId = null) => {
  const protocol = isHttp ? 'https': 'ws'
  let option = {
    transportOptions: {
      polling: {
        extraHeaders: { 'cookie': 'abc' }
      }
    },
    reconnection: false,
    rejectUnauthorized : false,
    // autoConnect: false
    // transports: ['websocket'],
    query:{}
  }
  // let option = {
  //   query: {
  //     login:JSON.stringify({
  //         officeid: '1',
  //         windowid: '2',
  //         from: 'scc',
  //     })
  //   },
  //   reconnection: false,
  //   transports: ['websocket']
  // } // sccs
  !firstLogin && boxId && (option.query.bid = boxId);
  // const socket = io(`${protocol}://${ip}:${port}/sccs`, option); //sccs
  const socket = io.connect(`${protocol}://${ip}:${port}`);
  // const socket = io(`${protocol}://${ip}:${port}/wbms`, option);
  return socket
}

const sendData = (socket, route, data) => {
  return new Promise((resolve, reject) => {
    socket.once(route, (recvdata) => {
      if (recvdata) {
        const jsonData = JSON.parse(recvdata);
        if (jsonData && jsonData.code == 0) {
          resolve(jsonData.data);
        } else {
          reject(jsonData.message);
        }
      }
    });
    socket.emit(route, JSON.stringify(data));
  });
}

module.exports = {
  start,
  sendData
}