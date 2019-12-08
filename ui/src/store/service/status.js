export function doCreateStatus (content, id) {
	const requestOptions = {
		method: 'POST',
		headers: { 'Content-Type': 'application/json' },
		body: JSON.stringify({ content, id }),
		credentials: 'include'
	}

	return fetch(`${process.env.TOMETO_BACKEND_URL}/api/status/new`, requestOptions)
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
