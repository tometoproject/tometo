<template>
	<section>
		<h1 v-if="!isLoaded">Loading...</h1>
		<div v-else>
			<div class="columns">
				<div class="column is-one-quarter">
					<img v-if="!audio.isLoud" v-bind:src="this.$data.images.pic1" />
					<img v-if="audio.isLoud" v-bind:src="this.$data.images.pic2" />
				</div>
				<div class="column">
					<h1>
						<div v-on:click="togglePlaying" id="playbutton">
							<span v-if="audio.playing && isLoaded">❚❚</span>
							<span v-else-if="!audio.playing && isLoaded">▶</span>
							<span v-else>侢</span>
						</div>
						<span>{{ this.$data.text.played.join(' ') }}</span>
						{{ this.$data.text.unplayed.join(' ') }}
					</h1>
				</div>
			</div>
		</div>
	</section>
</template>

<script>
import router from '../router'
import ctoml from '../../config.toml'
import { parse } from '@iarna/toml'
let config = parse(ctoml)

export default {
	name: 'GetStatus',
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
			loaded: {
				audio: false,
				json: false
			},
			images: {
				pic1: "",
				pic2: ""
			},
			text: {
				unplayed: [],
				played: [],
				words: [],
				interval: null,
				index: 0
			}
		}
	},

	computed: {
		isLoaded () {
			return this.$data.loaded.json && this.$data.loaded.audio
		}
	},

	methods: {
		tick () {
			if (this.isLoaded && this.$data.text.index < this.$data.text.words.length) {
				const cur = this.$data.text.words[this.$data.text.index]
				const time = this.$data.audio.ctx.currentTime
				console.log(this.$data.audio.ctx.currentTime)
				if (this.getVolume() > 1) {
					this.$data.audio.isLoud = true
				} else {
					this.$data.audio.isLoud = false
				}
				if (time > Number(cur.begin)) {
					this.$data.text.index += 1
					const word = this.$data.text.unplayed.shift()
					this.$data.text.played.push(word)
				}
			} else {
				this.$data.audio.isLoud = false
			}
		},

		getVolume () {
			let array = new Uint8Array(this.$data.audio.analyzer.fftSize)
			this.$data.audio.analyzer.getByteTimeDomainData(array)

			let average = 0
			for (let i = 0; i < array.length; i++) {
				let a = Math.abs(array[i] - 128)
				average += a
			}

			average /= array.length

			return average
		},

		togglePlaying () {
			if (this.$data.audio.media.paused && this.isLoaded) {
				this.$data.text.interval = setInterval(() => this.tick(), 100)
				this.$data.audio.ctx.resume()
				this.$data.audio.media.play()
				this.$data.audio.playing = !this.$data.audio.playing
			} else if (!this.$data.audio.media.paused && this.isLoaded) {
				this.$data.audio.media.pause()
				this.$data.audio.ctx.suspend()
				clearInterval(this.$data.text.interval)
				this.$data.audio.playing = !this.$data.audio.playing
			}
		},

		initAudio () {
			this.$data.audio.ctx = new window.AudioContext()
			this.$data.audio.src = this.$data.audio.ctx.createMediaElementSource(this.$data.audio.media)
			this.$data.audio.analyzer = this.$data.audio.ctx.createAnalyser()
			this.$data.audio.analyzer.fftSize = 512
			this.$data.audio.analyzer.smoothingTimeConstant = 0.9
			this.$data.audio.src.connect(this.$data.audio.analyzer)
			this.$data.audio.analyzer.connect(this.$data.audio.ctx.destination)
			this.$data.audio.ctx.suspend()
		}
	},



	mounted () {
		fetch(`${config.otemot.external_url}/api/status/${this.$route.params.id}`)
		.then(res => {
			if (res.ok) {
				return res.json()
			} else {
				router.back()
				// TODO: add a good error message
			}
		})
		.then(res => {
			this.$data.text.unplayed = res.content.split(' ')
			this.$data.audio.media = new Audio(res.audio)
			this.$data.audio.media.crossOrigin = 'anonymous'
			this.initAudio()
			this.$data.images.pic1 = res.pic1
			this.$data.images.pic2 = res.pic2

			this.$data.audio.media.addEventListener('canplaythrough', () => {
				this.$data.loaded.audio = true
			})

			this.$data.audio.media.addEventListener('ended', () => {
				this.initAudio()
				this.$data.text.unplayed = this.$data.text.played
				this.$data.text.played = []
				this.$data.text.index = 0
				clearInterval(this.$data.text.interval)
			})

			return fetch(res.timestamps, {method: 'GET'})
		})
		.then(res2 => res2.json())
		.then(res2 => {
			this.$data.text.words = res2.fragments
			this.$data.loaded.json = true
		})
	},

	beforeDestroy () {
		clearInterval(this.$data.text.interval)
	}
}
</script>
