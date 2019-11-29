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
		<section class="footer">
			running tometo
			<span v-if="isDevelopment">off {{ branch }}</span>
			<span v-else-if="isStaging">{{ gitVersion }} off {{ branch }}</span>
			<span v-else>{{ version }}</span>
			• <a class="footer__link" href="https://github.com/tometoproject/tometo">github</a>
		</section>
	</div>
</template>

<script>
import ctoml from '../config.toml'
import { parse } from '@iarna/toml'
let config = parse(ctoml)
import TheHeader from './components/TheHeader.vue'
import { version } from '../package.json'

export default {
	name: 'App',
	data () {
		return {
			version,
			gitVersion: VERSION,
			branch: BRANCH
		}
	},
	computed: {
		errorFlashMessage () {
			return this.$store.state.flash.error
		},
		infoFlashMessage () {
			return this.$store.state.flash.info
		},
		cookiesAcknowledged () {
			return this.$store.state.cookiesAcknowledged
		},
		isStaging () {
			return config.both.env === 'staging'
		},
		isDevelopment () {
			return config.both.env === 'development'
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
