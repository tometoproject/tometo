<template>
  <section v-on:keyup.enter="submitForm">
    <h1 class="title is-2">New Status</h1>

    <b-field label="Content">
      <b-input maxlength="500" type="textarea" v-model="content" />
    </b-field>

    <b-field label="Pitch">
      <b-numberinput :editable="false" min="0" max="30" v-model="pitch" />
    </b-field>

    <b-button @click="submitForm" :disabled="loading">Submit</b-button>
    <b-loading :is-full-page="false" :active.sync="loading"></b-loading>
  </section>
</template>

<script>
import router from '../router'

export default {
  name: 'NewStatus',
  data () {
    return {
      content: '',
      pitch: 10,
    }
  },
  beforeMount () {
    if (!this.$store.state.user)
      router.back()
  },
  computed: {
    loading () {
      return this.$store.state.loading
    }
  },
  methods: {
    submitForm () {
      let { content, pitch } = this
      this.$store.dispatch('newStatus', { content, pitch })
    }
  }
}
</script>

<style>

</style>
