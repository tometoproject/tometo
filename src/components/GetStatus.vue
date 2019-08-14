<template>
	<section>
		<h1 v-if="!isLoaded">Loading...</h1>
		<div v-else>
			<div class="columns">
				<div class="column is-one-quarter">
					<img v-bind:src="this.$data.images.pic1" />
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
import router from '../router'
import config from '../../config.json'
import { createAudioMeter } from '../audioMeter'

export default {
	name: 'GetStatus',
	data () {
		return {
			unplayed: [],
			played: [],
			audio: {
				ctx: null,
				src: null,
				analyzer: null,
				media: null,
				dest: null
			},
			jsonLoaded: false,
			fullyLoaded: false,
			images: {
				pic1: "",
				pic2: ""
			},
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
				const time = this.$data.audio.ctx.currentTime
				if (time > Number(cur.begin)) {
					this.$data.index += 1
					const word = this.$data.unplayed.shift()
					this.$data.played.push(word)
				}
			}
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
			this.$data.unplayed = res.content.split(' ')
			this.$data.audio.ctx = new window.AudioContext()
			this.$data.audio.media = new Audio(res.audio)
			this.$data.audio.media.crossOrigin = 'anonymous'
			this.$data.audio.src = this.$data.audio.ctx.createMediaElementSource(this.$data.audio.media)
			this.$data.audio.analyzer = this.$data.audio.ctx.createAnalyser()
			this.$data.audio.src.connect(this.$data.audio.analyzer)
			this.$data.audio.analyzer.connect(this.$data.audio.ctx.destination)
			this.$data.images.pic1 = res.pic1
			this.$data.images.pic2 = res.pic2

			this.$data.audio.media.addEventListener('loadeddata', () => {
				this.$data.fullyLoaded = true
				this.$data.interval = setInterval(() => this.tick(), 10)
				this.$data.audio.media.play()
			})

			return fetch(res.timestamps, {method: 'GET'})
		})
		.then(res2 => res2.json())
		.then(res2 => {
			this.$data.words = res2.fragments
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
