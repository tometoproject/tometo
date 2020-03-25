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

  <fieldset>
    <label>Username</label>
    <input bind:value={username} type="text" />
  </fieldset>

  <fieldset>
    <label>Email</label>
    <input bind:value={email} type="text" />
  </fieldset>

  <fieldset>
    <label>Password</label>
    <input bind:value={password} type="password" />
  </fieldset>

  <fieldset>
    <label>Confirm Password</label>
    <input bind:value={passwordConfirmation} type="password" />
  </fieldset>

  <button disabled={loading} on:click|preventDefault={submitForm}>
    Submit
  </button>
</form>
