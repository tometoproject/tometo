<template>
  <section v-on:keyup.enter="submitForm">
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
      <b-input type="password" v-model="confirmPassword"></b-input>
    </b-field>

    <b-button @click="submitForm" :disabled="loading">Submit</b-button>
    <b-loading :is-full-page="false" :active.sync="loading"></b-loading>
  </section>
</template>

<script>
export default {
  name: 'Register',
  data () {
    return {
      username: '',
      password: '',
      confirmPassword: '',
      email: ''
    }
  },
  beforeMount () {
    if (this.$store.state.user)
      router.back()
  },
  computed: {
    loading () {
      return this.$store.state.loading
    }
  },
  methods: {
    submitForm () {
      let { username, email, password, confirmPassword } = this
      this.$store.dispatch('register', { username, password, confirmPassword, email })
    }
  }
}
</script>

<style>

</style>
