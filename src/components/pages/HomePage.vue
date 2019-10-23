<template>
	<section>
		<p>this page is under construction!!</p>
		<p>check back later</p>
	</section>
</template>

<script>
import { mapMutations } from 'vuex'

export default {
	name: 'HomePage',
	computed: {
		message () {
			return this.$store.state.message
		}
	},
	methods: {
		...mapMutations(['changeMessage'])
	}
}
</script>
