import navaid from 'navaid'
import { get } from 'svelte/store'
import * as stores from '../stores'
import { request } from '../api'

export async function login (user) {
  const opts = {
    method: 'POST',
    url: '/api/sessions',
    body: user
  }

  request(opts).then(data => {
    stores.user.set(data.user)
    stores.sessionId.set(data.session_id)
    navaid().route('/')
    stores.infoFlash.set('Successfully logged in!')
  }, error => {
    stores.errorFlash.set(error)
  })
}

export async function register (user, code) {
  const opts = {
    method: 'POST',
    url: '/api/users',
    body: { user, code }
  }

  request(opts).then(data => {
    navaid().route('/')
    stores.infoFlash.set('Successfully registered! You can log in now.')
  }).catch(err => {
    stores.errorFlash.set(err)
  })
}

export async function logout () {
  const opts = {
    method: 'DELETE',
    url: `/api/sessions/${get(stores.sessionId)}`
  }

  request(opts).then(() => {
    stores.sessionId.clear()
    stores.user.clear()
    stores.infoFlash.set('Successfully logged out!')
  }).catch(error => {
    stores.errorFlash.set(error)
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
    url: `/api/users/${userId}/poll`
  }

  request(opts).then(data => {
    if (data && data.has_avatar) {
      stores.hasAvatar.set(true)
    }
  }).catch(() => {
    stores.user.clear()
    stores.sessionId.clear()
  })
}
