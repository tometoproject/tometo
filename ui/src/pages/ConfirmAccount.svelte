<script>
  import { confirmAccount } from '../actions'
  import { redirect } from '../utils'
  import { errorFlash, infoFlash } from '../stores'

  export let params

  confirmAccount(params.token).then(() => {
    infoFlash.set('Successfully confirmed your account! You can log in now.')
    redirect('/login')
  }).catch(err => {
    errorFlash.set(err.message)
    redirect('/')
  })
</script>

Confirming your account...
