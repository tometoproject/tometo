export function register (username, password, confirm_password, email) {
  const requestOptions = {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({ username, password, confirm_password, email })
  }

  return fetch(`${process.env.API_URL}/user/signup`, requestOptions)
    .then(res => res.text().then(text => {
      const data = text && JSON.parse(text)
      if (!res.ok || data.status !== 200) {
        const error = (data && data.message) || res.statusText
        return Promise.reject(error)
      }
      return data
    })).then(user => {
      if (user.token) {
        localStorage.setItem('user', JSON.stringify(user))
      }
      return user
    })
}

export function login (username, password) {
  const requestOptions = {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({ username, password })
  }

  return fetch(`${process.env.API_URL}/user/signin`, requestOptions)
  .then(res => res.text().then(text => {
    const data = text && JSON.parse(text)
    if (!res.ok || data.status !== 200) {
      const error = (data && data.message) || res.statusText
      return Promise.reject(error)
    }
    return data
  })).then(user => {
    if (user.token) {
      localStorage.setItem('user', JSON.stringify(user))
    }
    return user
  })
}