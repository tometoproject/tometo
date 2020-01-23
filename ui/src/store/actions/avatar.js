import api from '../api'
import router from '../../router'

export function createAvatar ({ commit }, { name, pitch, speed, language, gender, pic1, pic2 }) {
  commit('toggleLoading')

  let formdata = new FormData()
  formdata.set('name', name)
  formdata.set('pitch', pitch)
  formdata.set('speed', speed)
  formdata.set('language', language)
  formdata.set('gender', gender)
  formdata.set('pic1', pic1)
  formdata.set('pic2', pic2)

  const opts = {
    method: 'POST',
    url: '/api/avatars',
    isMultipart: true,
    body: formdata
  }

  api.request(opts).then(data => {
    commit('toggleLoading')
    commit('setHasAvatar')
    commit('setInfoFlash', `Avatar ${data.name} created!`)
    // FIXME: Redirect this somewhere smarter
    router.push('/')
  }).catch(error => {
    commit('toggleLoading')
    commit('setErrorFlash', error)
  })
}

export function editAvatar ({ commit }, { id, name, pitch, speed, language, gender, pic1, pic2 }) {
  commit('toggleLoading')

  let formdata = new FormData()
  formdata.set('name', name)
  formdata.set('pitch', pitch)
  formdata.set('speed', speed)
  formdata.set('language', language)
  formdata.set('gender', gender)
  formdata.set('pic1', pic1)
  formdata.set('pic2', pic2)

  const opts = {
    method: 'PUT',
    url: `/api/avatars/${id}`,
    isMultipart: true,
    body: formdata
  }

  api.request(opts).then(data => {
    commit('toggleLoading')
    commit('setHasAvatar')
    commit('setInfoFlash', 'Avatar successfully updated!')
    // FIXME: Redirect this somewhere smarter
    router.push('/')
  }, error => {
    commit('toggleLoading')
    commit('setErrorFlash', error)
  })
}
