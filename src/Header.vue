<template>
	<nav class="navbar" role="navigation" aria-label="main navigation">
		<div class="navbar-brand">
			<router-link to="/" class="navbar-item"><strong>Tometo</strong></router-link>
			<router-link to="/status/new" class="navbar-item" v-if="user && hasAvatar">New Status</router-link>
			<router-link to="/avatar/new" class="navbar-item" v-if="user && !hasAvatar">Create Avatar</router-link>
			<a
				@click="toggleBurger"
				class="navbar-burger burger"
				role="button"
				aria-label="menu"
				aria-expanded="false"
				v-bind:class="{ 'is-active': burgerActivated }">
				<span aria-hidden="true"></span>
				<span aria-hidden="true"></span>
				<span aria-hidden="true"></span>
			</a>
			</div>
		<div class="navbar-menu" id="mainNavbar" v-bind:class="{ 'is-active' : burgerActivated }">
			<div class="navbar-end" v-if="!user">
				<div class="navbar-item">
					<div class="buttons">
						<router-link class="button is-info" to="/register"><strong>Register</strong></router-link>
						<router-link class="button is-light" to="/login"><strong>Log in</strong></router-link>
					</div>
				</div>
			</div>
			<div class="navbar-end" v-else>
				<div class="navbar-item">Logged in as&nbsp; <strong>{{ user }}</strong></div>
				<div class="navbar-item"><button class="button is-light" @click="logout"><strong>Log out</strong></button></div>
			</div>
		</div>
	</nav>
</template>

<script>
export default {
	name: 'Header',
	data () {
		return {
			burgerActivated: false
		}
	},
	computed: {
		user () {
			return this.$store.state.username
		},
		hasAvatar () {
			return this.$store.state.hasAvatar
		}
	},
	methods: {
		toggleBurger () {
			this.burgerActivated = !this.burgerActivated
		},
		logout () {
			this.$store.dispatch('logout')
		}
	},
	beforeCreate () {
		this.$store.dispatch('poll')
	}
}
</script>

<style>

</style>
