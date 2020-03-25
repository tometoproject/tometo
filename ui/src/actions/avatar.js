import { request } from '../api'
import navaid from 'navaid'
import * as stores from '../stores'

export async function createAvatar ({ name, pitch, speed, language, gender, pic1, pic2 }) {
  const formdata = new FormData()
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

  request(opts).then(data => {
    stores.hasAvatar.set(true)
    stores.infoFlash.set(`Avatar ${data.name} created!`)
    navaid().route('/')
  }).catch(err => {
    stores.errorFlash.set(err)
  })
}
