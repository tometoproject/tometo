<template>
  <nav class="navbar is-link" role="navigation" aria-label="main navigation">
    <div class="navbar-brand">
      <router-link to="/" class="navbar-item"><strong>Metomo</strong></router-link>
      <a
        @click="toggleBurger"
        class="navbar-burger burger"
        role="button"
        aria-label="menu"
        aria-expanded="false"
        v-bind:class="{ 'is-active': burgerActivated }">
        <span aria-hidden="true"></span>
        <span aria-hidden="true"></span>
        <span aria-hidden="true"></span>
      </a>
      </div>
    <div class="navbar-menu" id="mainNavbar" v-bind:class="{ 'is-active' : burgerActivated }">
      <div class="navbar-end">
        <div class="navbar-item">
          <div class="buttons">
            <router-link class="button is-info" to="/signup"><strong>Sign up</strong></router-link>
            <router-link class="button is-light" to="/login"><strong>Log in</strong></router-link>
          </div>
        </div>
      </div>
    </div>
  </nav>
</template>

<script>
export default {
  name: 'Header',
  data () {
    return {
      burgerActivated: false
    }
  },
  methods: {
    toggleBurger () {
      this.burgerActivated = !this.burgerActivated
    }
  }
}
</script>

<style>

</style>
