<template>
  <div class="text-center">
    <h1><strong>{{ invitation.created_by.username }}</strong> invited you to join Tometo!</h1>
    <p>Click the button below to register using this invitation.</p>
    <a :href="registerUrl"><button>Register</button></a>
  </div>
</template>

<script>
export default {
  name: 'RedeemInvitationPage',
  data () {
    return {
      invitation: null,
      registerUrl: null
    }
  },

  mounted () {
    fetch(`${process.env.TOMETO_BACKEND_URL}/api/invitations/${this.$route.params.code}`)
      .then(res => {
        if (res.ok) {
          return res.json()
        } else {
          return this.$store.commit('setErrorFlash', 'Unable to load invitation!')
        }
      })
      .then(res => {
        this.invitation = res.data
        this.registerUrl = `/register/${this.invitation.code}`
      })
  }
}
</script>
