import Vue from 'vue'
import App from './App.vue'
import Buefy from 'buefy'
import './custom.scss'
import router from './router'
import store from './store'

import { library } from '@fortawesome/fontawesome-svg-core';
import { faMinus, faPlus } from "@fortawesome/free-solid-svg-icons";
import { FontAwesomeIcon } from "@fortawesome/vue-fontawesome";

library.add(faMinus, faPlus);
Vue.component('vue-fontawesome', FontAwesomeIcon);

Vue.use(Buefy, {
  defaultIconComponent: 'vue-fontawesome',
  defaultIconPack: 'fas'
})
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
