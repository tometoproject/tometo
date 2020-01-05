<template>
  <form @keyup-enter="submitForm">
    <h1>Create an Avatar</h1>

    <AvatarDetails
      :a-name.sync="name"
      :a-pitch.sync="pitch"
      :a-speed.sync="speed"
      :a-language.sync="language"
      :a-gender.sync="gender"
      @update:pic1="updatePic1"
      @update:pic2="updatePic2"
    />

    <button
      :disabled="loading"
      @click="submitForm"
    >
      Submit
    </button>
  </form>
</template>

<script>
import router from '../../router'
import AvatarDetails from '../AvatarDetails.vue'

export default {
  name: 'CreateAvatarPage',
  components: {
    AvatarDetails
  },
  data () {
    return {
      name: '',
      pitch: 10,
      speed: 1.0,
      language: 'en',
      gender: 'FEMALE',
      pic1: '',
      pic2: ''
    }
  },
  computed: {
    loading () {
      return this.$store.state.loading
    }
  },
  beforeMount () {
    if (!this.$store.state.username) { router.back() }
  },
  methods: {
    updatePic1 (pic) {
      this.pic1 = pic
    },

    updatePic2 (pic) {
      this.pic2 = pic
    },

    submitForm (e) {
      e.preventDefault()
      let { name, pitch, speed, language, gender, pic1, pic2 } = this
      this.$store.dispatch('createAvatar', { name, pitch, speed, language, gender, pic1, pic2 })
    }
  }
}
</script>
