<template>
	<form v-on:keyup.enter="submitForm">
		<fieldset>
			<label>Content</label>
			<textarea maxlength="500" type="textarea" v-model="content"></textarea>
		</fieldset>

		<button @click="submitForm" :disabled="loading">Submit</button>
	</form>
</template>

<script>
export default {
	name: 'CreateStatusForm',
	data () {
		return {
			content: ''
		}
	},
	computed: {
		loading () {
			return this.$store.state.loading
		}
	},
	methods: {
		submitForm (e) {
			e.preventDefault()
			let { content } = this
			this.$store.dispatch('createStatus', { content })
		}
	}
}
</script>
