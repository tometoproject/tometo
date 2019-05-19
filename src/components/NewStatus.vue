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
  </section>
</template>

<script>
export default {
  data () {
    return {
      content: '',
      pitch: 10
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
