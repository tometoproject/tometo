<script>
  import { register } from '../actions'
  export let params

  let username = ''
  let password = ''
  let passwordConfirmation = ''
  let email = ''
  let loading = false

  async function submitForm () {
    loading = true
    // Breaking with naming conventions here due to convenience when it comes to submitting the
    // API request — this is the key name the API expects.
    /* eslint-disable camelcase */
    await register({ username, password, password_confirmation: passwordConfirmation, email }, params.code)
    loading = false
  }
</script>

<form on:keydown.enter={submitForm}>
  <h1>Register</h1>

  <fieldset class="form-group">
    <label class="form-label label-lg">Username</label>
    <input class="form-input input-lg" bind:value={username} type="text" />
  </fieldset>

  <fieldset class="form-group">
    <label class="form-label label-lg">Email</label>
    <input class="form-input input-lg" bind:value={email} type="text" />
  </fieldset>

  <fieldset class="form-group">
    <label class="form-label label-lg">Password</label>
    <input class="form-input input-lg" bind:value={password} type="password" />
  </fieldset>

  <fieldset class="form-group">
    <label class="form-label label-lg">Confirm Password</label>
    <input class="form-input input-lg" bind:value={passwordConfirmation} type="password" />
  </fieldset>

  <button class="btn btn-primary btn-lg" disabled={loading} on:click|preventDefault={submitForm}>
    Submit
  </button>
</form>
