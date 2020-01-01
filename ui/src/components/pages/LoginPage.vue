<template>
  <form @keydown.enter="submitForm">
    <h1>Login</h1>

    <fieldset>
      <label>Username</label>
      <input
        v-model="username"
        type="text"
      >
    </fieldset>

    <fieldset>
      <label>Password</label>
      <input
        v-model="password"
        type="password"
      >
    </fieldset>

    <fieldset>
      <input type="checkbox" class="text--vmid" v-model="remember" />
      <span class="text--vmid">Remember me</span>
    </fieldset>

    <button
      :disabled="loading"
      @click="submitForm"
    >
      Submit
    </button>
  </form>
</template>

<script>
import router from '../../router'

export default {
  name: 'LoginPage',
  data () {
    return {
      username: '',
      password: '',
      remember: false
    }
  },
  computed: {
    loading () {
      return this.$store.state.loading
    }
  },
  beforeMount () {
    if (this.$store.state.username) { router.back() }
  },
  methods: {
    submitForm (e) {
      e.preventDefault()
      let { username, password, remember } = this
      this.$store.dispatch('login', { username, password, remember })
    }
  }
}
</script>
