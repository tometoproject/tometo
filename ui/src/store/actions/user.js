import api from '../api'
import router from '../../router'

export function register ({ commit }, { username, password, confirmPassword, email, code }) {
  commit('toggleLoading')

  const opts = {
    method: 'POST',
    url: '/api/users',
    body: { user: { username, password, password_confirmation: confirmPassword, email }, code }
  }

  api.request(opts).then(data => {
    commit('toggleLoading')
    router.push('/')
    commit('setInfoFlash', 'Successfully registered! You can log in now.')
  }, error => {
    commit('toggleLoading')
    commit('setErrorFlash', error)
  })
}

export function login ({ commit, dispatch }, { username, password, remember }) {
  commit('toggleLoading')

  const opts = {
    method: 'POST',
    url: '/api/sessions',
    body: { username, password, remember_me: remember }
  }

  api.request(opts).then(data => {
    commit('toggleLoading')
    commit('setUser', data.user)
    commit('setSessionId', data.session_id)
    router.push('/')
    dispatch('poll')
    commit('setInfoFlash', 'Signed in successfully.')
  }, error => {
    commit('toggleLoading')
    commit('setErrorFlash', error)
  })
}

export function logout ({ commit, state }) {
  const sessionId = state.sessionId

  const opts = {
    method: 'DELETE',
    url: `/api/sessions/${sessionId}`
  }

  api.request(opts).then(data => {
    commit('clearUser')
    commit('clearSessionId')
  })
}

export function poll ({ commit, state }) {
  if (state.user) {
    const userId = state.user.id

    const opts = {
      method: 'GET',
      url: `/api/users/${userId}/poll`
    }

    api.request(opts).then(data => {
      if (data && data.has_avatar) {
        commit('setHasAvatar')
      }
    }).catch(e => {
      // When there's an HTTP error (such as Unauthorized), clear localstorage
      commit('clearUser')
      commit('clearSessionId')
    })
  } else {
    // If user doesn't exist, clear the session ID too
    commit('clearSessionId')
  }
}
