<template>
	<form v-on:keyup.enter="submitForm">
		<h1>New Status</h1>

		<fieldset>
			<label>Content</label>
			<textarea maxlength="500" type="textarea" v-model="content"></textarea>
		</fieldset>

		<button @click="submitForm" :disabled="loading">Submit</button>
	</form>
</template>

<script>
import router from '../router'

export default {
	name: 'CreateStatus',
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
			this.$store.dispatch('createStatus', { content })
		}
	}
}
</script>

<style>

</style>
