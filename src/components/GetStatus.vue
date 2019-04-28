<template>
  <section>
    {{ $route.params.id }}
  </section>
</template>

<script>
export default {
  name: 'GetStatus',
  data () {
    return {
      unplayed: [],
      played: [],
      src: null,
      jsonLoaded: false,
      fullyLoaded: false
    }
  },

  mounted () {
    fetch(`${process.env.API_URL}/api/status/${this.$route.params.id}`)
    .then(res => res.json())
    .then(res => {
      this.$data.unplayed = res.content.split(' ')
      this.$data.src = new Audio(res.audio)

      return fetch(res.timestamps, {method: 'GET'})
    })
    .then(res2 => res2.text())
    .then(res2 => {
      console.log(res2)
    })
  }
}
</script>

<style>

</style>
