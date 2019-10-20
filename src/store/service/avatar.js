import ctoml from '../../../config.toml'
import { parse } from '@iarna/toml'
let config = parse(ctoml)

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

	return fetch(`${config.otemot.external_url}/api/avatar/new`, requestOptions)
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

export function doEditAvatar (id, name, pic1, pic2) {
	let formdata = new FormData()
	formdata.set('name', name)
	if (pic1.length !== 0)
		formdata.set('pic1', pic1)
	if (pic2.length !== 0)
		formdata.set('pic2', pic2)

	const requestOptions = {
		method: 'POST',
		body: formdata,
		credentials: 'include'
	}

	return fetch(`${config.otemot.external_url}/api/avatar/edit/${id}`, requestOptions)
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
