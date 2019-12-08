<template>
  <form @keydown.enter="submitForm">
    <h1>Register</h1>
    <fieldset>
      <label>Username</label>
      <input
        v-model="username"
        type="text"
      ></input>
    </fieldset>

    <fieldset>
      <label>Email</label>
      <input
        v-model="email"
        type="email"
      ></input>
    </fieldset>

    <fieldset>
      <label>Password</label>
      <input
        v-model="password"
        type="password"
      ></input>
    </fieldset>

    <fieldset>
      <label>Password Confirmation</label>
      <input
        v-model="confirmPassword"
        type="password"
      ></input>
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
