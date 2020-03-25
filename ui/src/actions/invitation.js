import { get } from 'svelte/store'
import { request } from '../api'
import { user } from '../stores'

export async function getInvitations () {
  if (!user) {
    return false
  }
  return request({ method: 'GET', url: `/api/users/${get(user).id}/invitations` })
}

export async function getInvitation (code) {
  return request({ method: 'GET', url: `/api/invitations/${code}` })
}

export async function createInvitation () {
  return request({ method: 'POST', url: '/api/invitations' })
}
