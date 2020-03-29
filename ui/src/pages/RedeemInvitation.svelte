<script>
  import { getInvitation } from '../actions'
  import { redirect } from '../utils'
  import { errorFlash } from '../stores'

  export let params

  let invitation, registerUrl

  getInvitation(params.code).then(inv => {
    invitation = inv.data
    registerUrl = `/register/${invitation.code}`
  }).catch(err => {
    errorFlash.set('Unable to load invitation! Check if you have the right code.')
    console.error('Invitation error:', err)
    redirect('/')
  })
</script>

<div class="empty">
  <h1 class="empty-title">{invitation && invitation.created_by.username} invited you to join Tometo!</h1>
  <p class="empty-subtitle">Click the button below to register using this invitation.</p>
  <div class="empty-action">
    <a class="btn btn-lg btn-primary" href={registerUrl}>Join</a>
  </div>
</div>
