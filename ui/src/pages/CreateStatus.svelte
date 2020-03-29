<script>
  import { createStatus } from '../actions'
  import { userCheck, redirect } from '../utils'
  userCheck()

  let content = ''
  let loading = false

  async function submitForm (evt) {
    loading = true
    const status = await createStatus(content)
    redirect(`/status/${status.id}`)
  }
</script>

<section>
  <h1>New Status</h1>

  <form on:keyup.enter={submitForm}>
    <fieldset class="form-group">
      <label class="form-label" for="content">Content</label>
      <textarea class="form-input" bind:value={content} maxlength=500 name="content" type="textarea" />
    </fieldset>

    <button class="btn btn-primary" disabled={loading} on:click|preventDefault={submitForm}>
      Submit
    </button>
  </form>
</section>
