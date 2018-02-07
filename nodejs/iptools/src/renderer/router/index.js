import Vue from 'vue'
import Router from 'vue-router'
import sf from '../components/sf.vue'
Vue.use(Router)

export default new Router({
  routes: [
    {
      path: '/',
      name: 'sf',
      component: require('@/components/sf.vue').default
    },
    {
      path: '*',
      redirect: '/',
        component: require('@/components/sf.vue').default
    }
  ]
})
