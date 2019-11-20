import ctoml from '../../../config.toml'
import { parse } from '@iarna/toml'
let config = parse(ctoml)

export function doRegister (username, password, confirmPassword, email) {
	const requestOptions = {
		method: 'POST',
		headers: { 'Content-Type': 'application/json' },
		body: JSON.stringify({ username, password, confirmPassword, email })
	}

	return fetch(`${config.otemot.external_url}/api/register`, requestOptions)
		.then(res => res.text().then(text => {
			const data = text && JSON.parse(text)
			if (!res.ok) {
				const error = (data && data.message) || res.statusText
				return Promise.reject(error)
			}
			return data
		}))
}

export function doLogin (username, password) {
	const requestOptions = {
		method: 'POST',
		headers: { 'Content-Type': 'application/json' },
		body: JSON.stringify({ username, password }),
		credentials: 'include'
	}

	return fetch(`${config.otemot.external_url}/api/auth`, requestOptions)
		.then(res => res.text().then(text => {
			const data = text && JSON.parse(text)
			if (!res.ok) {
				const error = (data && data.message) || res.statusText
				return Promise.reject(error)
			}
			return data
		}))
}

export function doLogout () {
	const requestOptions = {
		method: 'DELETE',
		credentials: 'include'
	}

	return fetch(`${config.otemot.external_url}/api/auth`, requestOptions)
		.then(res => res.text().then(text => {
			const data = text && JSON.parse(text)
			if (!res.ok) {
				const error = (data && data.message) || res.statusText
				return Promise.reject(error)
			}
			return data
		}))
}

export function doPoll () {
	const requestOptions = {
		method: 'GET',
		credentials: 'include'
	}

	return fetch(`${config.otemot.external_url}/api/poll`, requestOptions)
		.then(res => res.text().then(text => {
			const data = text && JSON.parse(text)
			if (res.status === 401) {
				return null
			}
			if (!res.ok) {
				const error = (data && data.message) || res.statusText
				return Promise.reject(error)
			}
			return data
		}))
}
