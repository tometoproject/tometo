<template>
  <form @keyup-enter="submitForm">
    <h1>Edit your Avatar</h1>

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
import AvatarDetails from '../AvatarDetails.vue'

export default {
  name: 'EditAvatarPage',
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
    const requestOptions = {
      method: 'GET',
      credentials: 'include'
    }

    fetch(`${process.env.TOMETO_BACKEND_URL}/api/avatars/${this.$route.params.id}`, requestOptions)
      .then(res => res.text().then(text => {
        const data = text && JSON.parse(text)
        if (!res.ok) {
          const error = (data && data.message) || res.statusText
          return Promise.reject(error)
        }
        return data
      })).then(data => {
        this.name = data.name
        this.pitch = data.pitch
        this.speed = data.speed
        this.language = data.language
        this.gender = data.gender
        document.title = `Edit ${this.name} - Tometo`
      }, error => {
        this.$store.commit('setErrorFlash', error)
      })
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
      let id = this.$route.params.id
      let { name, pitch, speed, language, gender, pic1, pic2 } = this
      this.$store.dispatch('editAvatar', { id, name, pitch, speed, language, gender, pic1, pic2 })
    }
  }
}
</script>
