export function doCreateAvatar (name, pitch, speed, language, gender, pic1, pic2) {
  let formdata = new FormData()
  formdata.set('name', name)
  formdata.set('pitch', pitch)
  formdata.set('speed', speed)
  formdata.set('language', language)
  formdata.set('gender', gender)
  formdata.set('pic1', pic1)
  formdata.set('pic2', pic2)

  const requestOptions = {
    method: 'POST',
    body: formdata,
    credentials: 'include'
  }

  return fetch(`${process.env.TOMETO_BACKEND_URL}/api/avatar/new`, requestOptions)
    .then(res => res.text().then(text => {
      const data = text && JSON.parse(text)
      if (!res.ok) {
        const error = (data && data.message) || res.statusText
        return Promise.reject(error)
      }
      return data
    })).then(res => {
      return res.data
    })
}

export function doEditAvatar (options) {
  let { id, name, pitch, speed, language, gender, pic1, pic2 } = options
  let formdata = new FormData()
  formdata.set('name', name)
  formdata.set('pitch', pitch)
  formdata.set('speed', speed)
  formdata.set('language', language)
  formdata.set('gender', gender)
  formdata.set('pic1', pic1)
  formdata.set('pic2', pic2)

  const requestOptions = {
    method: 'PUT',
    body: formdata,
    credentials: 'include'
  }

  return fetch(`${process.env.TOMETO_BACKEND_URL}/api/avatar/edit/${id}`, requestOptions)
    .then(res => res.text().then(text => {
      const data = text && JSON.parse(text)
      if (!res.ok) {
        const error = (data && data.message) || res.statusText
        return Promise.reject(error)
      }
      return data
    })).then(data => {
      return data
    })
}
