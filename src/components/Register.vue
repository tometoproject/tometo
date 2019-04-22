<template>
  <section>
    <h1 class="title is-2">Register</h1>
    <b-field label="Username">
      <b-input v-model="username"></b-input>
    </b-field>

    <b-field label="Email">
      <b-input type="email" v-model="email"></b-input>
    </b-field>

    <b-field label="Password">
      <b-input type="password" v-model="password"></b-input>
    </b-field>

    <b-field label="Password Confirmation">
      <b-input type="password" v-model="confirm_password"></b-input>
    </b-field>

    <b-button @click="submitForm" :disabled="loggingIn">Submit</b-button>
  </section>
</template>

<script>
export default {
  name: 'Register',
  data () {
    return {
      username: '',
      password: '',
      confirm_password: '',
      email: ''
    }
  },
  computed: {
    loggingIn () {
      return this.$store.state.loading
    }
  },
  methods: {
    submitForm () {
      let { username, email, password, confirm_password } = this
      this.$store.dispatch('register', { username, password, confirm_password, email })
    }
  }
}
</script>

<style>

</style>
