export function register (username, password, confirmPassword, email) {
	const requestOptions = {
		method: 'POST',
		headers: { 'Content-Type': 'application/json' },
		body: JSON.stringify({ username, password, confirmPassword, email })
	}

	return fetch(`${process.env.API_URL}/api/register`, requestOptions)
		.then(res => res.text().then(text => {
			const data = text && JSON.parse(text)
			if (!res.ok) {
				const error = (data && data.message) || res.statusText
				return Promise.reject(error)
			}
			return data
		})).then(user => user)
}

export function login (username, password) {
	const requestOptions = {
		method: 'POST',
		headers: { 'Content-Type': 'application/json' },
		body: JSON.stringify({ username, password }),
		credentials: 'include'
	}

	return fetch(`${process.env.API_URL}/api/auth`, requestOptions)
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

export function logout () {
	const requestOptions = {
		method: 'DELETE',
		credentials: 'include'
	}

	return fetch(`${process.env.API_URL}/api/auth`, requestOptions)
		.then(res => res.text().then(text => {
			const data = text && JSON.parse(text)
			if (!res.ok) {
				const error = (data && data.message) || res.statusText
				return Promise.reject(error)
			}
			return data
		}))
}
