import Vue from 'vue'
import Vuex from 'vuex'

import mutations from './mutations'
import { register, login, logout, poll } from './actions/user'
import { createStatus } from './actions/status'
import { createAvatar, editAvatar } from './actions/avatar'

Vue.use(Vuex)

export default new Vuex.Store({
	state: {
		username: localStorage.getItem('username') || null,
		cookiesAcknowledged: localStorage.getItem('cookiesAcknowledged') || false,
		hasAvatar: false,
		loading: false,
		flash: {
			error: null,
			info: null
		}
	},
	mutations,
	actions: {
		register,
		login,
		logout,
		poll,
		createStatus,
		createAvatar,
		editAvatar
	}
})
