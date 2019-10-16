<template>
	<form v-on:keyup-enter="submitForm">
		<h1>Edit your Avatar</h1>

		<fieldset>
			<label>Name</label>
			<input type="text" v-model="name" />
		</fieldset>

		<fieldset>
			<label>Closed Mouth image</label>
			<label>
				<input type="file" accept="image/png, image/jpeg" v-on:change="updatePic(1, $event)" />
			</label>
		</fieldset>

		<fieldset>
			<label>Open Mouth image</label>
			<label>
				<input type="file" accept="image/png, image/jpeg" v-on:change="updatePic(1, $event)" />
			</label>
		</fieldset>

		<button @click="submitForm" :disabled="loading">Submit</button>
	</form>
</template>

<script>
import ctoml from '../../config.toml'
import { parse } from '@iarna/toml'
let config = parse(ctoml)

export default {
	name: 'EditAvatar',
	data () {
		return {
			name: ''
		}
	},
	computed: {
		loading () {
			return this.$store.state.loading
		}
	},

	methods: {
		submitForm () {

		}
	},

	beforeMount () {
		const requestOptions = {
			method: 'GET',
			credentials: 'include'
		}

		fetch(`${config.otemot.external_url}/api/avatar/edit/${this.$route.params.id}`, requestOptions)
			.then(res => res.text().then(text => {
				const data = text && JSON.parse(text)
				if (!res.ok) {
					const error = (data && data.message) || res.statusText
					return Promise.reject(error)
				}
				return data
			})).then(data => {
				this.$data.name = data.name
			}, err => {
				this.$store.commit('setErrorFlash', error)
			})
	}
}
</script>
