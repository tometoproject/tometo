import { doCreateAvatar, doEditAvatar } from '../service/avatar'
import router from '../../router'

export function createAvatar ({ commit }, { name, pitch, speed, language, gender, pic1, pic2 }) {
	commit('toggleLoading')

	doCreateAvatar(name, pitch, speed, language, gender, pic1, pic2).then(data => {
		commit('toggleLoading')
		commit('setHasAvatar')
		commit('setInfoFlash', data.message)
		// FIXME: Redirect this somewhere smarter
		router.push('/')
	}, error => {
		commit('toggleLoading')
		commit('setErrorFlash', error)
	})
}

export function editAvatar({ commit }, { id, name, pic1, pic2 }) {
	commit('toggleLoading')

	doEditAvatar(id, name, pic1, pic2).then(data => {
		commit('toggleLoading')
		commit('setHasAvatar')
		commit('setInfoFlash', data.message)
		// FIXME: Redirect this somewhere smarter
		router.push('/')
	}, error => {
		commit('toggleLoading')
		commit('setErrorFlash', error)
	})
}
