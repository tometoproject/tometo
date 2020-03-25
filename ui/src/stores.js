import { writable } from 'svelte/store'

export const user = localStorageStore('user')
export const sessionId = localStorageStore('sessionId')
export const hasAvatar = writable(false)
export const cookiesAcknowledged = localStorageStore('cookiesAcknowledged')
export const infoFlash = flashStore()
export const errorFlash = flashStore()

// Flash messages expire after a time (three seconds).
function flashStore () {
  const { subscribe, set } = writable(null)

  return {
    subscribe,
    set: value => {
      set(value)
      setTimeout(() => set(null), 3000)
    }
  }
}

// A store that tries to load a key from localStorage, and writes the store value
// to the same key on store#set, too.
function localStorageStore (key) {
  const item = localStorage.getItem(key)
  const { subscribe, set } = writable(JSON.parse(item) || null)

  return {
    subscribe,
    set: value => {
      localStorage.setItem(key, JSON.stringify(value))
      set(value)
    },
    clear: () => {
      localStorage.removeItem(key)
      set(null)
    }
  }
}
