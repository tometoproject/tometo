<template>
	<nav role="navigation" aria-label="main navigation">
		<span>
			<router-link to="/"><img class="img--vmid" width=30 src="https://tometo.org/img/tome.png"><strong> Tometo</strong></router-link>
			<router-link to="/status/new" v-if="user && hasAvatar">New Status</router-link>
			<router-link to="/avatar/new" v-if="user && !hasAvatar">Create Avatar</router-link>
		</span>
		<span class="nav-right">
			<span v-if="!user">
				<router-link to="/register"><strong>Register</strong></router-link> |
				<router-link to="/login"><strong>Log in</strong></router-link>
			</span>
			<span v-else>
				<span>Logged in as <strong>{{ user }}</strong></span> |
				<span><strong><a class="link" @click="logout">Log out</a></strong></span>
			</span>
		</span>
	</nav>
</template>

<script>
export default {
	name: 'TheHeader',
	computed: {
		user () {
			return this.$store.state.username
		},
		hasAvatar () {
			return this.$store.state.hasAvatar
		}
	},
	methods: {
		logout () {
			this.$store.dispatch('logout')
		}
	},
	beforeCreate () {
		this.$store.dispatch('poll')
	}
}
</script>
