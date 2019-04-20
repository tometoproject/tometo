<template>
  <span>
    <div>{{ message }} world!</div>
    <button @click="changeMessage('test')">change me</button>
  </span>
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
