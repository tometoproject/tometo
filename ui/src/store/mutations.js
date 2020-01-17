export default {
  setUser (state, user) {
    localStorage.setItem('user', JSON.stringify(user))
    state.user = user
  },
  clearUser (state) {
    state.user = null
    localStorage.removeItem('user')
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
