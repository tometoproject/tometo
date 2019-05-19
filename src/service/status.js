export function postStatus (content, pitch, id, jwt) {
  const requestOptions = {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({ content, pitch, user_id: id, jwt })
  }

  return fetch(`${process.env.API_URL}/api/status/new`, requestOptions)
}
