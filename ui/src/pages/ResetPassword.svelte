<script>
  import { performResetPassword } from '../actions'

  export let params

  let password = ''
  let confirmPassword = ''

  async function submitForm () {
    await performResetPassword(params.token, password, confirmPassword)
  }
</script>

<h1>Reset your password</h1>

<form on:keydown.enter={submitForm}>
  <fieldset class="form-group">
    <label class="form-label label-lg">New Password</label>
    <input class="form-input input-lg" bind:value={password} type="password" />
  </fieldset>

  <fieldset class="form-group">
    <label class="form-label label-lg">Confirm New Password</label>
    <input class="form-input input-lg" bind:value={confirmPassword} type="password" />
  </fieldset>

  <button class="btn btn-primary" on:click|preventDefault={submitForm}>
    Submit
  </button>
</form>
