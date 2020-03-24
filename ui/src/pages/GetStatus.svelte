<script>
  export let params
  import { onMount } from 'svelte'
  import { getStatus } from '../actions'
  import { redirect } from '../utils'
  import { errorFlash } from '../stores'
  import StatusDisplay from '../components/StatusDisplay.svelte'

  let timestamps, pic1, pic2, audioUrl, avatarName
  let loading = true

  onMount(() => {
    getStatus(params.id).then(status => {
      console.log(status)
      pic1 = status.pic1
      pic2 = status.pic2
      audioUrl = status.audio
      avatarName = status.avatar.name
      timestamps = status.timestamps
      document.title = `${status.avatar.name}'s Status - Tometo`
      loading = false
    }).catch(err => {
      errorFlash.set('Unable to load status!')
      redirect('/')
    })
  })
</script>

{#if loading}
  Loading...
{:else}
  <StatusDisplay
    id=0
    timestamps={timestamps}
    pic1={pic1}
    pic2={pic2}
    audioUrl={audioUrl}
    name={avatarName}
  />
  <h2>Comments</h2>
  <!-- Pretend there's something here -->
{/if}
