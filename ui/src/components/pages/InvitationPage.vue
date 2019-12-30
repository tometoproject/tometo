<template>
  <main>
    <h1>Invitations</h1>

    <div class="text-center">
      <p>You have <strong>{{ limit - invitations.length }}</strong> invitations left.</p>
      <button>New invitation</button>
    </div>

    <h2>Your invitations</h2>
    <div class="grid grid__outline grid--3-2-1-1">
      <p><strong>Link</strong></p>
      <p><strong>Status</strong></p>
      <p><strong>Used by</strong></p>
    </div>
    <div
      v-for="(inv, k) in invitations"
      :key="k"
      class="grid grid--3-2-1-1"
    >
      <p><a :href="composeInviteUrl(inv.code)">{{ inv.code }}</a></p>
      <p>
        <strong v-if="inv.used_by">USED</strong>
        <strong v-else>UNUSED</strong>
      </p>
      <p v-if="inv.used_by">
        {{ inv.used_by.username }}
      </p>
    </div>
  </main>
</template>

<script>
import router from '../../router'

export default {
  name: 'InvitationPage',
  data () {
    return {
      invitations: [],
      limit: 0,
      frontend_url: process.env.TOMETO_FRONTEND_URL
    }
  },

  mounted () {
    fetch(`${process.env.TOMETO_BACKEND_URL}/api/invitations`, { credentials: 'include' })
      .then(res => {
        if (res.ok) {
          return res.json()
        } else {
          this.$store.commit('setErrorFlash', 'Unable to load invitations!')
          return router.push('/')
        }
      })
      .then(res => {
        this.limit = res.limit
        this.invitations = res.data
      })
  },

  methods: {
    composeInviteUrl (code) {
      return `${this.frontend_url}/i/${code}`
    }
  }
}
</script>
