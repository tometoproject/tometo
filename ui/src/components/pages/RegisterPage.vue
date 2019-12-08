<template>
  <form @keydown.enter="submitForm">
    <h1>Register</h1>
    <fieldset>
      <label>Username</label>
      <input
        v-model="username"
        type="text"
      >
    </fieldset>

    <fieldset>
      <label>Email</label>
      <input
        v-model="email"
        type="email"
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
      <label>Password Confirmation</label>
      <input
        v-model="confirmPassword"
        type="password"
      >
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
  name: 'RegisterPage',
  data () {
    return {
      username: '',
      password: '',
      confirmPassword: '',
      email: ''
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
      let { username, email, password, confirmPassword } = this
      this.$store.dispatch('register', { username, password, confirmPassword, email })
    }
  }
}
</script>
