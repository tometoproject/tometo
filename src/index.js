import Vue from 'vue'
import App from './App.vue'
import * as Sentry from '@sentry/browser'
import * as Integrations from '@sentry/integrations'
import router from './router'
import store from './store'
import ctoml from '../config.toml'
import { parse } from '@iarna/toml'

require('./custom.scss')

let config = parse(ctoml)

Vue.config.productionTip = false

new Vue({
	router,
	store,
	render: h => h(App)
}).$mount('#content')

Sentry.init({
	dsn: config.tometo.dsn,
	integrations: [
		new Integrations.Vue({
			Vue,
			attachProps: true
		})
	]
})
