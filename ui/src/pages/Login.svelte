<script>
  import { login } from '../actions'

  let username = ''
  let password = ''
  let remember = false
  let loading = false

  async function submitForm () {
    loading = true
    await login({ username, password, remember_me: remember })
    loading = false
  }
</script>

<form on:keydown.enter={submitForm}>
  <h1>Login</h1>

  <fieldset class="form-group">
    <label class="form-label label-lg">Username</label>
    <input class="form-input input-lg" bind:value={username} type="text" />
  </fieldset>

  <fieldset class="form-group">
    <label class="form-label label-lg">Password</label>
    <input class="form-input input-lg" bind:value={password} type="password" />
  </fieldset>

  <fieldset class="form-group">
    <label class="form-inline form-checkbox">
      <input bind:checked={remember} type="checkbox" />
      <i class="form-icon"></i>
      Remember me
    </label>
  </fieldset>

  <button class="btn btn-primary" disabled={loading} on:click|preventDefault={submitForm}>
    Submit
  </button>
</form>
