<template>
	<div id="app">
		<div class="container">
			<app-header></app-header>
		</div>
		<section class="section">
			<div class="container">
					<div class="notification is-info" @click="hideCookies" v-if="!cookiesAcknowledged">
							We use cookies to keep you logged in, but nothing else.<br>
							<i>Click anywhere on this notification to close it.</i>
					</div>
					<div class="notification is-info" v-if="infoFlashMessage">{{ infoFlashMessage }}</div>
					<div class="notification is-danger" v-if="errorFlashMessage">{{ errorFlashMessage }}</div>
				<router-view></router-view>
			</div>
		</section>
	</div>
</template>

<script>
import Header from './Header.vue'

export default {
	name: 'App',
	computed: {
		errorFlashMessage () {
			return this.$store.state.flash.error
		},
		infoFlashMessage () {
			return this.$store.state.flash.info
		},
		cookiesAcknowledged () {
				return this.$store.state.cookiesAcknowledged
		}
	},
	components: {
		'app-header': Header
	},
	methods: {
		hideCookies () {
			this.$store.commit('acknowledgeCookies')
		}
	}
}
</script>
