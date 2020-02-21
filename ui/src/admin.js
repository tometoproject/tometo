import Vue from 'vue'
import Vuex from 'vuex'
import VueRouter from 'vue-router'

import App from './admin/App.vue'
import Home from './components/admin/AdminHomePage.vue'

Vue.config.productionTip = false
Vue.use(Vuex)
Vue.use(VueRouter)

const router = new VueRouter({
  mode: 'history',
  routes: [
    {
      path: '/admin',
      component: Home
    }
  ]
})

new Vue({
  router,
  render: h => h(App)
}).$mount('#content')
