import { doCreateStatus } from '../service/status'
import router from '../../router'

export function createStatus ({ commit }, { content, id }) {
	commit('toggleLoading')

	doCreateStatus(content, id).then(data => {
		commit('toggleLoading')
		router.push(`/status/${data}`)
	}, error => {
		commit('toggleLoading')
		commit('setErrorFlash', error)
	})
}
