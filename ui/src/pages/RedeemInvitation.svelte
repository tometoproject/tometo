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

<div class="text--center">
  <h1><strong>{invitation && invitation.created_by.username}</strong> invited you to join Tometo!</h1>
  <p>Click the button below to register using this invitation.</p>
  <a href={registerUrl}><button>Register</button></a>
</div>
