import Vue from 'vue'
import App from './App.vue'
import * as Sentry from '@sentry/browser'
import * as Integrations from '@sentry/integrations'
import router from './router'
import store from './store/index'

require('./css/index.css')

Vue.config.productionTip = false

new Vue({
  router,
  store,
  render: h => h(App)
}).$mount('#content')

Sentry.init({
  dsn: process.env.TOMETO_DSN,
  integrations: [
    new Integrations.Vue({
      Vue,
      attachProps: true
    })
  ]
})
