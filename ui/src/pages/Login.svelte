<script>
  import { login } from '../actions'

  let email = ''
  let password = ''
  let remember = false
  let loading = false

  async function submitForm () {
    loading = true
    await login({ email, password, remember_me: remember })
    loading = false
  }
</script>

<form on:keydown.enter={submitForm}>
  <h1 class="mb-0">Login</h1>
  <small class="mb-2">or <a href="/reset_password">reset your password</a></small>

  <fieldset class="form-group">
    <label class="form-label label-lg">Email</label>
    <input class="form-input input-lg" bind:value={email} type="email" />
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
