import { user } from './stores'
import { get } from 'svelte/store'
import navaid from 'navaid'

export function userCheck (route = null) {
  if (!get(user) && !route) {
    history.back()
  }

  if (!get(user) && route) {
    navaid().route(route)
  }
}

export function reverseUserCheck () {
  if (get(user)) {
    history.back()
  }
}

export function redirect (route) {
  navaid().route(route)
}
