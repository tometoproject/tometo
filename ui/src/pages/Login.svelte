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

  <fieldset>
    <label>Username</label>
    <input bind:value={username} type="text" />
  </fieldset>

  <fieldset>
    <label>Password</label>
    <input bind:value={password} type="password" />
  </fieldset>

  <fieldset>
    <label class="text--vmid">
      <input bind:checked={remember} type="checkbox" class="text--vmid" />
      Remember me
    </label>
  </fieldset>

  <button disabled={loading} on:click|preventDefault={submitForm}>
    Submit
  </button>
</form>
