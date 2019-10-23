<template>
	<form v-on:keyup.enter="submitForm">
		<h1>Register</h1>
		<fieldset>
			<label>Username</label>
			<input type="text" v-model="username"></input>
		</fieldset>

		<fieldset>
			<label>Email</label>
			<input type="email" v-model="email"></input>
		</fieldset>

		<fieldset>
			<label>Password</label>
			<input type="password" v-model="password"></input>
		</fieldset>

		<fieldset>
			<label>Password Confirmation</label>
			<input type="password" v-model="confirmPassword"></input>
		</fieldset>

		<button @click="submitForm" :disabled="loading">Submit</button>
	</form>
</template>

<script>
export default {
	name: 'RegisterPage',
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
		submitForm (e) {
			e.preventDefault()
			let { username, email, password, confirmPassword } = this
			this.$store.dispatch('register', { username, password, confirmPassword, email })
		}
	}
}
</script>
