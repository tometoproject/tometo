<template>
  <section>
    <h1 v-if="!isLoaded">Loading...</h1>
    <div v-else>
      <div class="columns">
        <div class="column is-one-quarter">
          <img src="https://i.imgur.com/8yR89wl.jpg" />
        </div>
        <div class="column">
          <h1 class="subtitle is-1">
            <span class="has-text-info">{{ this.$data.played.join(' ') }}</span>
            {{ this.$data.unplayed.join(' ') }}
          </h1>
        </div>
      </div>
    </div>
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
      fullyLoaded: false,
      words: [],
      interval: null,
      index: 0
    }
  },

  computed: {
    isLoaded () {
      return this.$data.jsonLoaded && this.$data.fullyLoaded
    }
  },

  methods: {
    tick () {
      if (this.isLoaded && this.$data.index < this.$data.words.length) {
        const cur = this.$data.words[this.$data.index]
        const time = this.$data.src.currentTime
        if (time > Number(cur.end)) {
          this.$data.index += 1
          const word = this.$data.unplayed.shift()
          this.$data.played.push(word)
        }
      }
    }
  },

  mounted () {
    fetch(`${process.env.API_URL}/api/status/${this.$route.params.id}`)
    .then(res => res.json())
    .then(res => {
      this.$data.unplayed = res.content.split(' ')
      this.$data.src = new Audio(res.audio)

      this.$data.src.addEventListener('loadeddata', () => {
        this.$data.fullyLoaded = true
        this.$data.interval = setInterval(() => this.tick(), 10)
        this.$data.src.play()
      })

      return fetch(res.timestamps, {method: 'GET', cache: 'no-store'}) // for now
    })
    .then(res2 => res2.json())
    .then(res2 => {
      this.$data.words = res2
      this.$data.jsonLoaded = true
    })
  },

  beforeDestroy () {
    clearInterval(this.$data.interval)
  }
}
</script>

<style>

</style>
