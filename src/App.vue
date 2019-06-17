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
  data () {
    return {
      greeting: 'Hello'
    }
  },
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
  }
}
</script>