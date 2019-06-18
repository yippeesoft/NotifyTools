'use strict';
const { create, multitudeBoxLogin } = require('./util')
// const init = require('./httpsServer')
let option = {
  length: 2000,      
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

multitudeBoxLogin(option)

// init()