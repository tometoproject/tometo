import { get } from 'svelte/store'
import { request } from '../api'
import * as stores from '../stores'

export async function getInboxes () {
  const userId = get(stores.user).id
  const opts = {
    method: 'GET',
    url: `/users/${userId}/inboxes`
  }

  return request(opts)
}

export async function createAnswer (content, inboxId) {
  const opts = {
    method: 'POST',
    url: '/answers',
    body: {
      content,
      inbox_id: inboxId
    }
  }

  return request(opts)
}

export async function getAnswer (id) {
  const opts = {
    method: 'GET',
    url: `/answers/${id}`
  }

  return request(opts)
}

export async function createComment (content, answerId) {
  const opts = {
    method: 'POST',
    url: '/comments',
    body: {
      content,
      answer_id: answerId
    }
  }

  return request(opts)
}

export async function getComments (answerId) {
  const opts = {
    method: 'GET',
    url: `/answers/${answerId}/comments`
  }

  return request(opts)
}
