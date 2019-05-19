export function postStatus (content, pitch, id, jwt) {
  const requestOptions = {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({ content, pitch, user_id: id, jwt })
  }

  return fetch(`${process.env.API_URL}/api/status/new`, requestOptions)
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
