<script>
  import { sendResetPassword } from '../actions'

  let email = ''

  async function submitForm () {
    await sendResetPassword(email)
    email = ''
  }
</script>

<h1>Forgot your password?</h1>

<p>If you provide your account's email address, we can send you an email with instructions to reset your password.</p>

<form on:keydown.enter={submitForm}>
  <fieldset class="form-group">
    <label class="form-label label-lg">Email</label>
    <input class="form-input input-lg" bind:value={email} type="email" />
  </fieldset>

  <button class="btn btn-primary" on:click|preventDefault={submitForm}>
    Submit
  </button>
</form>
