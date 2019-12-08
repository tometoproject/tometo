<template>
	<span>
		<div class="banner" v-if="isStaging">
			This is a <strong>staging environment</strong>! All content is reset every hour at zero
			minutes, including user accounts!
		</div>
		<nav role="navigation" aria-label="main navigation">
			<span class="nav__subnav">
				<router-link class="link--no-underline" to="/">
					<img class="nav__brandimg img--vmid" width=50 src="https://tometo.org/img/tome.png">
					<p class="nav__brand">
						tometo alpha
						<span class="nav__brand--small nav__brand--is-dev" v-if="isDevelopment">(development)</span>
						<span class="nav__brand--small nav__brand--is-stage" v-if="isStaging">(staging)</span>
					</p>
				</router-link>
				<router-link class="nav__item" to="/status/new" v-if="user && hasAvatar">New Status</router-link>
					<router-link class="nav__item" to="/avatar/new" v-if="user && !hasAvatar">Create Avatar</router-link>
			</span>
			<span class="nav__subnav">
				<span v-if="!user">
					<router-link class="nav__item" to="/register"><strong>Register</strong></router-link> |
					<router-link class="nav__item" to="/login"><strong>Log in</strong></router-link>
				</span>
				<span v-else>
					<span>Logged in as <strong>{{ user }}</strong></span> |
					<span><strong><a class="link" @click="logout">Log out</a></strong></span>
				</span>
			</span>
		</nav>
	</span>
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
		},
		isDevelopment () {
			return process.env.TOMETO_ENV === 'development'
		},
		isStaging () {
			return process.env.TOMETO_ENV === 'staging'
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
