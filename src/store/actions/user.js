import { doRegister, doLogin, doLogout, doPoll } from '../service/user'
import router from '../../router'

export function register ({ commit }, { username, password, confirmPassword, email }) {
  commit('toggleLoading')

  doRegister(username, password, confirmPassword, email).then(data => {
    commit('toggleLoading')
    router.push('/')
    commit('setInfoFlash', data.message)
  }, error => {
    commit('toggleLoading')
    commit('setErrorFlash', error)
  })
}

export function login ({ commit, dispatch }, { username, password }) {
  commit('toggleLoading')

  doLogin(username, password).then(user => {
    commit('toggleLoading')
    commit('setUsername', user.username)
    router.push('/')
    dispatch('poll')
    commit('setInfoFlash', 'Signed in successfully.')
  }, error => {
    commit('toggleLoading')
    commit('setErrorFlash', error)
  })
}

export function logout ({ commit }) {
  doLogout().then(data => {
    commit('clearUsername')
  })
}

export function poll ({ commit }) {
  doPoll().then(data => {
    if (!data) {
      commit('clearUsername')
    }

    if (data && data.has_avatar) {
      commit('setHasAvatar')
    }
  })
}
