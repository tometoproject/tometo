<template>
  <section>
    <h1 v-if="!ready">
      Loading...
    </h1>
    <div v-else>
      <StatusDisplay
        :timestamps="timestamps"
        :pic1="pic1"
        :pic2="pic2"
        :audio-url="audio"
        :name="avatar_name"
      />
      <h2>Comments</h2>
      <StatusDisplay
        v-for="(status, k) in comments"
        :key="k"
        condensed
        :timestamps="status.timestamps"
        :pic1="status.pic1"
        :pic2="status.pic2"
        :audio-url="status.audio"
        :name="status.avatar.name"
      />
      <CreateStatusForm
        :status-id="this.$route.params.id"
        no-redirect
        @posted="onCommentPosted"
      />
    </div>
  </section>
</template>

<script>
import api from '../../store/api'
import router from '../../router'
import CreateStatusForm from '../forms/CreateStatusForm.vue'
import StatusDisplay from '../StatusDisplay.vue'

export default {
  name: 'GetStatusPage',
  components: {
    CreateStatusForm,
    StatusDisplay
  },
  data () {
    return {
      timestamps: '',
      pic1: '',
      pic2: '',
      audio: null,
      avatar_name: '',
      comments: [],
      ready: false
    }
  },

  mounted () {
    api.request({ method: 'GET', url: `/api/statuses/${this.$route.params.id}` })
      .then(res => {
        if (res.related_status_id) {
          router.push(`/status/${res.related_status_id}`)
        }

        this.pic1 = res.pic1
        this.pic2 = res.pic2
        this.audio = res.audio
        this.avatar_name = res.avatar.name
        this.timestamps = res.timestamps
        this.ready = true
        document.title = `${this.avatar_name}'s Status - Tometo`

        return this.fetchComments()
      }).then(res => {
        this.comments = res
      }).catch(() => {
        this.$store.commit('setErrorFlash', 'Unable to load status!')
        // TODO: Redirect this somewhere else
        return router.push('/')
      })
  },

  methods: {
    async fetchComments () {
      return api.request({ method: 'GET', url: `/api/statuses/${this.$route.params.id}/comments` })
    },

    async onCommentPosted () {
      let comments = await this.fetchComments()
      this.comments = comments
    }
  }
}
</script>
