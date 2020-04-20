import { request } from '../api'
import { user } from '../stores'

export async function getQuestions () {
  if (!user) {
    return false
  }
  return request({ method: 'GET', url: '/api/questions' })
}

export async function postQuestion (content, date) {
  if (!user) {
    return false
  }

  const opts = {
    method: 'POST',
    url: '/api/questions',
    body: {
      content,
      date
    }
  }

  return request(opts)
}
