<template>
  <div id="app">
    <app-header></app-header>
    <main class="container">
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
  components: {
    'app-header': Header
  }
}
</script>