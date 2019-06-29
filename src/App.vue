<template>
  <div id="app">
    <main class="container">
        <app-header></app-header>
        <b-notification v-if="infoFlashMessage" type="is-info">{{ infoFlashMessage }}</b-notification>
        <b-notification v-if="errorFlashMessage" type="is-danger">{{ errorFlashMessage }}</b-notification>
        <router-view></router-view>
    </main>
  </div>
</template>

<script>
import Header from './Header.vue'

export default {
  name: 'App',
  computed: {
    errorFlashMessage () {
      return this.$store.state.flash.error
    },
    infoFlashMessage () {
      return this.$store.state.flash.info
    }
  },
  components: {
    'app-header': Header
  },
  mounted: function () {
    if (!this.$store.state.cookiesAcknowledged) {
      this.$snackbar.open({
        message: 'We use cookies to keep you logged in, but nothing else.',
        actionText: 'Got it!',
        indefinite: true,
        onAction: () => {
          this.$store.commit('acknowledgeCookies')
        }
      })
    }
  }
}
</script>
