import ctoml from '../../../config.toml'
import { parse } from '@iarna/toml'
let config = parse(ctoml)

export function doCreateStatus (content) {
	const requestOptions = {
		method: 'POST',
		headers: { 'Content-Type': 'application/json' },
		body: JSON.stringify({ content }),
		credentials: 'include'
	}

	return fetch(`${config.otemot.external_url}/api/status/new`, requestOptions)
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
