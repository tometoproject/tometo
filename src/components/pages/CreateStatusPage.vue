<template>
	<section>
		<h1>New Status</h1>
		<CreateStatusForm />
	</section>
</template>

<script>
import router from '../../router'
import CreateStatusForm from '../forms/CreateStatusForm.vue'

export default {
	name: 'CreateStatusPage',
	components: {
		CreateStatusForm
	},
	beforeMount () {
		if (!this.$store.state.username)
			router.back()
	}
}
</script>
