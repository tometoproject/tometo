<template>
	<section v-on:keyup.enter="submitForm">
		<h1 class="title is-2">Login</h1>

		<fieldset class="field">
				<label class="label is-large">Username</label>
				<input class="input is-large" type="text" v-model="username" />
		</fieldset>

		<fieldset class="field">
				<label class="label is-large">Password</label>
				<input class="input is-large" type="password" v-model="password" />
		</fieldset>

		<button class="button is-info" @click="submitForm" :disabled="loading">Submit</button>
	</section>
</template>

<script>
import router from '../router'

export default {
	name: 'Login',
	data () {
		return {
			username: '',
			password: ''
		}
	},
	beforeMount () {
		if (this.$store.state.username)
			router.back()
	},
	computed: {
		loading () {
			return this.$store.state.loading
		}
	},
	methods: {
		submitForm () {
			let { username, password } = this
			this.$store.dispatch('login', { username, password })
		}
	}
}
</script>

<style>

</style>
