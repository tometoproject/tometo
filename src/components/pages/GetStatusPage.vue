<template>
	<section>
		<h1 v-if="!ready">Loading...</h1>
		<div v-else>
			<StatusDisplay :timestamps="timestamps" :pic1="pic1" :pic2="pic2" :audioUrl="audio" :name="avatar_name" />
			<h2>Comments</h2>
			<StatusDisplay
				v-for="(status, k) in comments"
				:key="k"
				condensed
				:timestamps="status.timestamps"
				:pic1="status.pic1"
				:pic2="status.pic2"
				:audioUrl="status.audio"
				:name="status.avatar_name" />
			<CreateStatusForm :status-id="this.$route.params.id" v-on:posted="onCommentPosted" noRedirect />
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
			avatar_name: '',
			comments: [],
			ready: false
		}
	},
	components: {
		CreateStatusForm,
		StatusDisplay
	},

	methods: {
		async fetchComments () {
			let res = await fetch(`${config.otemot.external_url}/api/status/${this.$route.params.id}/comments`)
			if (res.ok) {
				res = await res.json()
				return res.data
			} else {
				this.$store.commit('setErrorFlash', 'Unable to load status comments!')
				return []
			}
		},

		async onCommentPosted () {
			let comments = await this.fetchComments()
			this.comments = comments
		}
	},

	mounted () {
		fetch(`${config.otemot.external_url}/api/status/${this.$route.params.id}`)
		.then(res => {
			if (res.ok) {
				return res.json()
			} else {
				this.$store.commit('setErrorFlash', 'Unable to load status!')
				// TODO: Redirect this somewhere else
				return router.push('/')
			}
		})
		.then(res => {
			if (res.data.related_status_id) {
				router.push(`/status/${res.related_status_id}`)
			}

			this.pic1 = res.data.pic1
			this.pic2 = res.data.pic2
			this.audio = res.data.audio
			this.avatar_name = res.data.avatar_name
			this.timestamps = res.data.timestamps
			this.ready = true
			document.title = `${this.avatar_name}'s Status - Tometo`

			return this.fetchComments()
		}).then(res => {
			this.comments = res
		})
	}
}
</script>
