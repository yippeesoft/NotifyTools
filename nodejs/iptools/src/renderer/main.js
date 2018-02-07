import Vue from 'vue'
import axios from 'axios'
import VueRouter from 'vue-router'
import VueClipboard from 'vue-clipboard2'
import Vuex from 'vuex'
import App from './App'
import router from './router'
import store from './store'
import iview from 'iview'
import 'iview/dist/styles/iview.css'    // 使用 CSS


Vue.use(VueRouter)
Vue.use(Vuex)
Vue.use(iview)
if (!process.env.IS_WEB) Vue.use(require('vue-electron'))
Vue.http = Vue.prototype.$http = axios
Vue.config.productionTip = false

/* eslint-disable no-new */
new Vue({
  components: { App },
  router,
  store,
  template: '<App/>',

}).$mount('#app')
