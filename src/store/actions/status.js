import { doCreateStatus } from '../service/status'
import router from '../../router'

export function createStatus ({ commit }, { content }) {
  commit('toggleLoading')

  doCreateStatus(content).then(data => {
    commit('toggleLoading')
    router.push(`/status/${data}`)
  }, error => {
    commit('toggleLoading')
    commit('setErrorFlash', error)
  })
}
