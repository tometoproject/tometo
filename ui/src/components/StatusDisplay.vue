<template>
  <div
    v-if="!condensed"
    class="grid grid--2-50"
  >
    <div>
      <img
        v-if="!audio.isLoud"
        class="img--centered img--avatar"
        :src="pic1"
      >
      <img
        v-if="audio.isLoud"
        class="img--centered img--avatar"
        :src="pic2"
      >
    </div>
    <div>
      <span
        class="button button--vmid button--fullwidth"
        @click="togglePlaying"
      >
        <span v-if="audio.playing && isLoaded">❚❚</span>
        <span v-else-if="!audio.playing && isLoaded">▶</span>
        <span v-else>侢</span>
      </span>
      <p><span class="color--blue">{{ name }}</span> says:</p>
      <h1 class="h1--uncentered h1--nomargin">
        <span class="text--vmid text--lhdefault color--blue">{{ text.played.join(' ') }}</span>
        <span class="text--vmid text--lhdefault">{{ text.unplayed.join(' ') }}</span>
      </h1>
      <p class="text--small">
        <a :href="audioUrl">🔽 Download audio</a>
      </p>
    </div>
  </div>
  <div
    v-else
    class="grid grid--2-30"
  >
    <div>
      <img
        v-if="!audio.isLoud"
        class="img--centered img--avatar-small"
        :src="pic1"
      >
      <img
        v-if="audio.isLoud"
        class="img--centered img--avatar-small"
        :src="pic2"
      >
    </div>
    <div>
      <p>
        <span
          class="button button--vmid"
          @click="togglePlaying"
        >
          <span v-if="audio.playing && isLoaded">❚❚</span>
          <span v-else-if="!audio.playing && isLoaded">▶</span>
          <span v-else>侢</span>
        </span>
        &nbsp;<span class="color--blue">{{ name }}</span> says:
      </p>
      <h2 class="h2--noborder">
        <span class="text--vmid text--lhdefault color--blue">{{ text.played.join(' ') }}</span>
        <span class="text--vmid text--lhdefault">{{ text.unplayed.join(' ') }}</span>
      </h2>
      <p class="text--small">
        <a :href="audioUrl">🔽 Download audio</a>
      </p>
    </div>
  </div>
</template>

<script>
export default {
  name: 'StatusDisplay',
  props: {
    timestamps: {
      type: String,
      default: ''
    },
    pic1: {
      type: String,
      default: ''
    },
    pic2: {
      type: String,
      default: ''
    },
    audioUrl: {
      type: String,
      default: ''
    },
    name: {
      type: String,
      default: ''
    },
    condensed: Boolean
  },
  data () {
    return {
      audio: {
        ctx: null,
        src: null,
        analyzer: null,
        media: null,
        dest: null,
        isLoud: false,
        playing: false
      },
      text: {
        words: [],
        unplayed: [],
        played: [],
        interval: null,
        index: 0
      },
      loaded: {
        audio: false,
        json: false
      }
    }
  },

  computed: {
    isLoaded () {
      return this.loaded.audio && this.loaded.json
    }
  },

  mounted () {
    fetch(this.timestamps)
      .then(res => res.json())
      .then(res => {
        this.text.words = res.fragments
        this.text.unplayed = this.text.words.map(w => w.lines).flat()
        this.audio.media = new Audio(this.audioUrl)
        this.audio.media.crossOrigin = 'anonymous'
        this.loaded.json = true
        this.initAudio()

        this.audio.media.addEventListener('canplaythrough', () => {
          this.loaded.audio = true
        })

        this.audio.media.addEventListener('ended', () => {
          this.initAudio()
          this.text.unplayed = this.text.played
          this.text.played = []
          this.text.index = 0
          clearInterval(this.text.interval)
        })
      })
  },

  beforeDestroy () {
    clearInterval(this.text.interval)
  },

  methods: {
    initAudio () {
      this.audio.ctx = new window.AudioContext()
      this.audio.src = this.audio.ctx.createMediaElementSource(this.audio.media)
      this.audio.analyzer = this.audio.ctx.createAnalyser()
      this.audio.analyzer.fftSize = 512
      this.audio.analyzer.smoothingTimeConstant = 0.9
      this.audio.playing = false
      this.audio.src.connect(this.audio.analyzer)
      this.audio.analyzer.connect(this.audio.ctx.destination)
      this.audio.ctx.suspend()
    },

    togglePlaying () {
      if (this.audio.media.paused && this.isLoaded) {
        this.text.interval = setInterval(() => this.tick(), 100)
        this.audio.ctx.resume()
        this.audio.media.play()
        this.audio.playing = true
      } else if (!this.audio.media.paused && this.isLoaded) {
        this.audio.media.pause()
        this.audio.ctx.suspend()
        clearInterval(this.text.interval)
        this.audio.playing = false
      }
    },

    tick () {
      if (this.isLoaded && this.text.index < this.text.words.length) {
        const cur = this.text.words[this.text.index]
        const time = this.audio.ctx.currentTime
        this.audio.isLoud = this.getVolume() > 1
        if (time > Number(cur.begin)) {
          this.text.index += 1
          const words = this.text.unplayed.shift()
          this.text.played.push(words)
        }
      } else {
        this.audio.isLoud = false
      }
    },

    getVolume () {
      let array = new Uint8Array(this.audio.analyzer.fftSize)
      this.audio.analyzer.getByteTimeDomainData(array)

      let average = 0
      for (let i = 0; i < array.length; i++) {
        let a = Math.abs(array[i] - 128)
        average += a
      }

      average /= array.length

      return average
    }
  }
}
</script>
