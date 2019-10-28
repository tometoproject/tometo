import { doCreateStatus } from '../service/status'
import router from '../../router'

export async function createStatus ({ commit }, { content, id, redirect }) {
	commit('toggleLoading')

	try {
		let data = await doCreateStatus(content, id)
		commit('toggleLoading')
		if (redirect) {
			router.push(`/status/${data}`)
		}
	} catch (error) {
		commit('toggleLoading')
		commit('setErrorFlash', error)
	}
}
