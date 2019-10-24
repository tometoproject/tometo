<template>
	<div class="grid grid--2-50">
		<div>
			<img class="img--centered img--avatar" v-if="!audio.isLoud" v-bind:src="pic1" />
			<img class="img--centered img--avatar" v-if="audio.isLoud" v-bind:src="pic2" />
		</div>
		<div>
			<span class="button button--vmid button--fullwidth" v-on:click="togglePlaying" id="playbutton">
				<span v-if="audio.playing && audioLoaded">❚❚</span>
				<span v-else-if="!audio.playing && audioLoaded">▶</span>
				<span v-else>侢</span>
			</span>
			<p><span class="color--blue">{{ name }}</span> says:</p>
			<h1 class="h1--uncentered h1--nomargin">
				<span class="text--vmid text--lhdefault color--blue">{{ text.played.join(' ') }}</span>
				<span class="text--vmid text--lhdefault">{{ text.unplayed.join(' ') }}</span>
			</h1>
		</div>
	</div>
</template>

<script>
export default {
	name: 'StatusDisplay',
	props: ['words', 'pic1', 'pic2', 'audioUrl', 'name'],
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
				unplayed: [],
				played: [],
				interval: null,
				index: 0
			},
			audioLoaded: false
		}
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
			if (this.audio.media.paused && this.audioLoaded) {
				this.text.interval = setInterval(() => this.tick(), 100)
				this.audio.ctx.resume()
				this.audio.media.play()
				this.audio.playing = true
			} else if (!this.audio.media.paused && this.audioLoaded) {
				this.audio.media.pause()
				this.audio.ctx.suspend()
				clearInterval(this.text.interval)
				this.audio.playing = false
			}
		},

		tick () {
			if (this.audioLoaded && this.text.index < this.words.length) {
				const cur = this.words[this.text.index]
				const time = this.audio.ctx.currentTime
				this.audio.isLoud = this.getVolume() > 1 ? true : false
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
	},

	mounted () {
		let unplayed = this.words.map(w => w.lines).flat()
		this.text.unplayed = unplayed
		this.audio.media = new Audio(this.audioUrl)
		this.audio.media.crossOrigin = 'anonymous'
		this.initAudio()

		this.audio.media.addEventListener('canplaythrough', () => {
			this.audioLoaded = true
		})

		this.audio.media.addEventListener('ended', () => {
			this.initAudio()
			this.text.unplayed = this.text.played
			this.text.played = []
			this.text.index = 0
			clearInterval(this.text.interval)
		})
	},

	beforeDestroy () {
		clearInterval(this.text.interval)
	}
}
</script>
