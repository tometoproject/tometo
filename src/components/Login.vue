<template>
  <section>
    <h1 class="title is-2">Login</h1>

    <b-field label="Username">
        <b-input v-model="username"></b-input>
      </b-field>

      <b-field label="Password">
        <b-input type="password" v-model="password"></b-input>
      </b-field>

      <b-button @click="submitForm" :disabled="loggingIn">Submit</b-button>
    </section>
</template>

<script>
import router from '../router'

export default {
  name: 'Login',
  data () {
    return {
      username: '',
      password: ''
    }
  },
  beforeMount () {
    if (this.$store.state.user)
      router.back()
  },
  computed: {
    loggingIn () {
      return this.$store.state.loading
    }
  },
  methods: {
    submitForm () {
      let { username, password } = this
      this.$store.dispatch('login', { username, password })
    }
  }
}
</script>

<style>

</style>
