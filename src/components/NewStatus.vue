<template>
	<section v-on:keyup.enter="submitForm">
		<h1 class="title is-2">New Status</h1>

		<fieldset class="field">
				<label class="label">Content</label>
				<textarea class="textarea" maxlength="500" type="textarea" v-model="content"></textarea>
		</fieldset>

		<button class="button is-info" @click="submitForm" :disabled="loading">Submit</button>
	</section>
</template>

<script>
import router from '../router'

export default {
	name: 'NewStatus',
	data () {
		return {
			content: '',
		}
	},
	beforeMount () {
		if (!this.$store.state.username)
			router.back()
	},
	computed: {
		loading () {
			return this.$store.state.loading
		}
	},
	methods: {
		submitForm () {
			let { content, pitch } = this
			this.$store.dispatch('newStatus', { content })
		}
	}
}
</script>

<style>

</style>
