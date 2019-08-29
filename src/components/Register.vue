<template>
	<section v-on:keyup.enter="submitForm">
		<h1 class="title is-2">Register</h1>
		<fieldset class="field">
				<label class="label is-large">Username</label>
				<input class="input is-large" type="text" v-model="username"></input>
		</fieldset>

		<fieldset class="field">
				<label class="label is-large">Email</label>
				<input class="input is-large" type="email" v-model="email"></input>
		</fieldset>

		<fieldset class="field">
				<label class="label is-large">Password</label>
				<input class="input is-large" type="password" v-model="password"></input>
		</fieldset>

		<fieldset class="field">
				<label class="label is-large">Password Confirmation</label>
				<input class="input is-large" type="password" v-model="confirmPassword"></input>
		</fieldset>

		<button class="button is-info" @click="submitForm" :disabled="loading">Submit</button>
	</section>
</template>

<script>
export default {
	name: 'Register',
	data () {
		return {
			username: '',
			password: '',
			confirmPassword: '',
			email: ''
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
			let { username, email, password, confirmPassword } = this
			this.$store.dispatch('register', { username, password, confirmPassword, email })
		}
	}
}
</script>

<style>

</style>
