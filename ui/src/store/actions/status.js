import api from '../api'
import router from '../../router'

export async function createStatus ({ commit }, { content, id, redirect }) {
  commit('toggleLoading')

  let opts = {
    method: 'POST',
    url: '/api/statuses',
    body: { content }
  }
  if (id.length > 0) {
    opts.body.parent_id = id
  }

  try {
    let res = await api.request(opts)
    commit('toggleLoading')
    if (redirect) {
      router.push(`/status/${res.id}`)
    }
  } catch (error) {
    commit('toggleLoading')
    commit('setErrorFlash', error)
  }
}
