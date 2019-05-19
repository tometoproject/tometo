import Vue from 'vue'
import Vuex from 'vuex'
import { register, login } from './service/auth'
import { postStatus } from './service/status'
import router from './router';

Vue.use(Vuex)

export default new Vuex.Store({
  state: {
    user: JSON.parse(localStorage.getItem('user')) || null,
    loading: false,
    flash: {
      error: null,
      info: null
    }
  },
  mutations: {
    setUser (state, user) {
      state.user = user
    },
    clearUser (state) {
      state.user = null
    },
    toggleLoading (state) {
      state.loading = !state.loading
    },
    setInfoFlash (state, msg) {
      state.flash.info = msg
    },
    setErrorFlash (state, msg) {
      state.flash.error = msg
    },
    clearFlash (state) {
      state.flash = {
        info: null,
        error: null
      }
    }
  },
  actions: {
    register ({ commit }, { username, password, confirm_password, email }) {
      commit('toggleLoading')

      register(username, password, confirm_password, email).then(user => {
        commit('toggleLoading')
        router.push('/')
        commit('setInfoFlash', 'Registered successfully. You can sign in now.')
      }, error => {
        commit('toggleLoading')
        commit('setErrorFlash', `There was an error during registration: ${error}`)
      })
    },
    login ({ commit }, { username, password }) {
      commit('toggleLoading')

      login(username, password).then(user => {
        commit('toggleLoading')
        commit('setUser', user)
        router.push('/')
        commit('setInfoFlash', 'Signed in successfully.')
      }, error => {
        commit('toggleLoading')
        commit('setErrorFlash', `There was an error during login: ${error}`)
      })
    },
    logout ({ commit }) {
      commit('clearUser')
      localStorage.removeItem('user')
    },
    newStatus ({ commit, state }, { content, pitch }) {
      commit('toggleLoading')

      postStatus(content, pitch, state.user.signin_user.id, state.user.token).then(data => {
        commit('toggleLoading')
        router.push(`/status/${data.id}`)
      }, error => {
        commit('toggleLoading')
        commit('setErrorFlash', `There was an error while creating your status: ${error}`)
      })
    }
  }
})
