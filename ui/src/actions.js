import { request } from './api'
import { errorFlash } from './stores'

export * from './actions/user'
export * from './actions/avatar'
export * from './actions/invitation'
// This will get removed very soon so no extra file for it
export async function createStatus (content) {
  const opts = {
    method: 'POST',
    url: '/api/statuses',
    body: { content }
  }

  return request(opts).then(data => {
    return data
  }).catch(err => {
    errorFlash.set(err)
  })
}

export function getStatus (id) {
  return request({ method: 'GET', url: `/api/statuses/${id}` })
}
