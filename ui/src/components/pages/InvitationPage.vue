<template>
  <main>
    <h1>Invitations</h1>

    <div class="text-center">
      <p>You have <strong>{{ this.limit - this.invitations.length }}</strong> invitations left.</p>
      <button>New invitation</button>
    </div>

    <h2>Your invitations</h2>
    <div class="grid grid__outline grid--3-2-1-1">
      <p><strong>Link</strong></p>
      <p><strong>Status</strong></p>
      <p><strong>Used by</strong></p>
    </div>
    <div class="grid grid--3-2-1-1" v-for="(inv, k) in invitations" :key="k">
      <p><a>tometo.org/i/{{ inv.code }}</a></p>
      <p>
        <strong v-if="inv.used_by">USED</strong>
        <strong v-else>UNUSED</strong>
      </p>
      <p>{{ inv.used_by  }}</p>
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
      limit: 0
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
  }
}
</script>
