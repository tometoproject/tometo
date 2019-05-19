<template>
  <section class="hero is-warning">
    <div class="hero-body">
      <div class="container">
        <p class="title">this page is under construction!!</p>
        <p class="subtitle">check back later</p>
      </div>
    </div>
  </section>
</template>

<script>
import { mapMutations } from 'vuex'

export default {
  name: 'Home',
  computed: {
    message () {
      return this.$store.state.message
    }
  },
  methods: {
    ...mapMutations(['changeMessage'])
  }
}
</script>
