<template>
	<section>
		<h1 v-if="!ready">Loading...</h1>
		<div v-else>
			<StatusDisplay :timestamps="timestamps" :pic1="pic1" :pic2="pic2" :audioUrl="audio" :name="name" />
			<h2>Comments</h2>
			<CreateStatusForm :status-id="this.$route.params.id" />
		</div>
	</section>
</template>

<script>
import router from '../../router'
import ctoml from '../../../config.toml'
import CreateStatusForm from '../forms/CreateStatusForm.vue'
import StatusDisplay from '../StatusDisplay.vue'
import { parse } from '@iarna/toml'
let config = parse(ctoml)

export default {
	name: 'GetStatusPage',
	data () {
		return {
			timestamps: '',
			pic1: '',
			pic2: '',
			audio: null,
			name: '',
			comments: [],
			ready: false
		}
	},
	components: {
		CreateStatusForm,
		StatusDisplay
	},

	mounted () {
		fetch(`${config.otemot.external_url}/api/status/${this.$route.params.id}`)
		.then(res => {
			if (res.ok) {
				return res.json()
			} else {
				this.$store.commit('setErrorFlash', 'Unable to load status!')
				router.back()
			}
		})
		.then(res => {
			this.pic1 = res.pic1
			this.pic2 = res.pic2
			this.audio = res.audio
			this.name = res.avatar_name
			this.timestamps = res.timestamps
			this.ready = true

			return fetch(`${config.otemot.external_url}/api/status/${this.$route.params.id}/comments`)
		}).then(res => {
			if (res.ok) {
				return res.json()
			} else {
				this.$store.commit('setErrorFlash', 'Unable to load status comments!')
			}
		}).then(res => {
			this.comments = res
		})
	}
}
</script>
