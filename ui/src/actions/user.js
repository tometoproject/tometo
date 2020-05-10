import navaid from 'navaid'
import { get } from 'svelte/store'
import * as stores from '../stores'
import { request } from '../api'

export async function login (user) {
  const opts = {
    method: 'POST',
    url: '/sessions',
    body: { user }
  }

  request(opts).then(data => {
    stores.user.set(data)
    navaid().route('/')
    stores.infoFlash.set('Successfully logged in!')
    return poll()
  }, error => {
    stores.errorFlash.set(error.message)
  })
}

export async function register (user, code) {
  const opts = {
    method: 'POST',
    url: '/users',
    body: { user, code }
  }

  request(opts).then(data => {
    navaid().route('/')
    stores.infoFlash.set('Successfully registered! Check your email for a confirmation mail to be able to use your account.')
  }).catch(err => {
    stores.errorFlash.set(err.message)
  })
}

export async function confirmAccount (token) {
  const opts = {
    method: 'GET',
    url: `/users/confirm/${token}`
  }

  return request(opts)
}

export async function logout () {
  const opts = {
    method: 'DELETE',
    url: '/sessions'
  }

  request(opts).then(() => {
    stores.sessionId.clear()
    stores.user.clear()
    stores.infoFlash.set('Successfully logged out!')
  }).catch(error => {
    stores.errorFlash.set(error.message)
  })
}

export async function sendResetPassword (email) {
  const opts = {
    method: 'POST',
    url: '/users/reset_password',
    body: { user: { email } }
  }

  request(opts).then(() => {
    stores.infoFlash.set('If the email exists, you\'ll receive instructions on how to reset your password soon!')
  }).catch(error => {
    stores.errorFlash.set(error.message)
  })
}

export async function performResetPassword (token, password, confirmPassword) {
  const opts = {
    method: 'PUT',
    url: `/users/reset_password/${token}`,
    body: {
      user: {
        password,
        password_confirmation: confirmPassword
      }
    }
  }

  request(opts).then(() => {
    stores.infoFlash.set('Password successfully reset!')
  }).catch(error => {
    stores.errorFlash(error.message)
  })
}

export async function poll () {
  if (!get(stores.user)) {
    stores.sessionId.clear()
    return
  }

  const userId = get(stores.user).id
  const opts = {
    method: 'GET',
    url: `/users/${userId}/poll`
  }

  request(opts).then(data => {
    stores.inboxes.set(data.inboxes)
    if (data && data.has_avatar) {
      stores.hasAvatar.set(true)
    }
  }).catch(e => {
    if ([401, 403].includes(e.status)) {
      stores.user.clear()
      stores.sessionId.clear()
    }
  })
}
