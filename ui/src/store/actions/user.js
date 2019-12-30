import { doRegister, doLogin, doLogout, doPoll } from '../service/user'
import router from '../../router'

export function register ({ commit }, { username, password, confirmPassword, email, code }) {
  commit('toggleLoading')

  doRegister(username, password, confirmPassword, email, code).then(data => {
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
    commit('setUsername', user.data.username)
    commit('setSessionId', user.data.session_id)
    router.push('/')
    dispatch('poll')
    commit('setInfoFlash', 'Signed in successfully.')
  }, error => {
    commit('toggleLoading')
    commit('setErrorFlash', error)
  })
}

export function logout ({ commit, state }) {
  doLogout(state.sessionId).then(data => {
    commit('clearUsername')
    commit('clearSessionId')
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
