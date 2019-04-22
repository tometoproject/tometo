import Vue from 'vue'
import Vuex from 'vuex'
import { register } from './service/auth'
import router from './router';

Vue.use(Vuex)

export default new Vuex.Store({
  state: {
    user: JSON.parse(localStorage.getItem('user')) || null,
    loading: false
  },
  mutations: {
    setUser (state, user) {
      state.user = user
    },
    toggleLoading (state, user) {
      state.loading = !state.loading
    }
  },
  actions: {
    register ({ commit }, { username, password, confirm_password, email }) {
      commit('toggleLoading')

      register(username, password, confirm_password, email).then(user => {
        commit('toggleLoading')
        commit('setUser', user)
        router.push('/')
      }, error => {
        commit('toggleLoading')
        router.push('/')
      })
    }
  }
})