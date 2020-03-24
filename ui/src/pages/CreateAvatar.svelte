<script>
  import AvatarDetails from '../components/AvatarDetails.svelte'
  import { createAvatar } from '../actions'
  import { userCheck } from '../utils'
  userCheck()

  let loading = false
  let name, pitch, speed, language, gender, pic1, pic2

  async function submitForm () {
    loading = true
    await createAvatar({ name, pitch, speed, language, gender, pic1, pic2 })
    loading = false
  }
</script>

<form on:keydown.enter={submitForm}>
  <h1>Create an Avatar</h1>

  <AvatarDetails
    bind:name
    bind:pitch
    bind:speed
    bind:language
    bind:gender
    on:updatePic1={e => pic1 = e.detail}
    on:updatePic2={e => pic2 = e.detail}
    />

  <button disabled={loading} on:click|preventDefault={submitForm}>
    Submit
  </button>
</form>
