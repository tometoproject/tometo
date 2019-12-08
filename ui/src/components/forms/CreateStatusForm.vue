<template>
  <form @keyup.enter="submitForm">
    <fieldset>
      <label>Content</label>
      <textarea
        v-model="content"
        maxlength="500"
        type="textarea"
      />
    </fieldset>

    <button
      :disabled="loading"
      @click="submitForm"
    >
      Submit
    </button>
  </form>
</template>

<script>
export default {
  name: 'CreateStatusForm',
  props: {
    statusId: {
      type: String,
      default: ''
    },
    noRedirect: Boolean
  },
  data () {
    return {
      content: ''
    }
  },
  computed: {
    loading () {
      return this.$store.state.loading
    }
  },
  methods: {
    submitForm (e) {
      e.preventDefault()
      let { content, statusId } = this
      this.$store.dispatch('createStatus', { content, id: statusId, redirect: !this.noRedirect }).then(() => {
        this.content = ''
        this.$emit('posted')
      })
    }
  }
}
</script>
