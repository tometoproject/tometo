<template>
	<div id="app">
		<app-header></app-header>
		<section class="page center">
			<div>
				<div class="flash flash--info" @click="hideCookies" v-if="!cookiesAcknowledged">
					We use cookies to keep you logged in, but nothing else.<br>
					<i>Click anywhere on this notification to close it.</i>
				</div>
				<div class="flash" v-if="infoFlashMessage">{{ infoFlashMessage }}</div>
				<div class="flash flash--error" v-if="errorFlashMessage">{{ errorFlashMessage }}</div>
				<router-view></router-view>
			</div>
		</section>
	</div>
</template>

<script>
import TheHeader from './components/TheHeader.vue'

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
		'app-header': TheHeader
	},
	methods: {
		hideCookies () {
			this.$store.commit('setCookies')
		}
	}
}
</script>
