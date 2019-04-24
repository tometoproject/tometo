import Vue from 'vue'
import App from './App.vue'
import Buefy from 'buefy'
import './custom.scss'
import router from './router'
import store from './store'

Vue.use(Buefy)
Vue.config.productionTip = false

new Vue({
  router,
  store,
  render: h => h(App)
}).$mount('#content')

router.beforeEach((to, from, next) => {
  store.commit('clearFlash')
  next()
})