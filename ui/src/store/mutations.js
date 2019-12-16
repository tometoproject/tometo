export default {
  setUsername (state, username) {
    localStorage.setItem('username', username)
    state.username = username
  },
  clearUsername (state) {
    state.username = null
    localStorage.removeItem('username')
  },
  setSessionId (state, id) {
    localStorage.setItem('sessionId', id)
    state.sessionId = id
  },
  clearSessionId (state, id) {
    state.sessionId = null
    localStorage.removeItem('sessionId')
  },
  toggleLoading (state) {
    state.loading = !state.loading
  },
  setInfoFlash (state, msg) {
    state.flash.info = msg
    setTimeout(() => {
      state.flash.info = null
    }, 3000)
  },
  setErrorFlash (state, msg) {
    state.flash.error = msg
    setTimeout(() => {
      state.flash.error = null
    }, 3000)
  },
  clearFlash (state) {
    state.flash = {
      info: null,
      error: null
    }
  },
  setCookies (state) {
    localStorage.setItem('cookiesAcknowledged', true)
    state.cookiesAcknowledged = true
  },
  setHasAvatar (state) {
    state.hasAvatar = true
  }
}
