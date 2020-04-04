<script>
  import { onMount } from 'svelte'
  import { getAnswer, createComment, getComments } from '../actions'
  import { redirect } from '../utils'
  import { errorFlash } from '../stores'
  import AnswerDisplay from '../components/AnswerDisplay.svelte'

  export let params

  let timestamps, pic1, pic2, audioUrl, avatarName
  let question = {}
  let loading = true
  let comments = []
  let commentText = ''
  let commentSubmitting = false

  onMount(() => {
    getAnswer(params.id).then(answer => {
      pic1 = answer.pic1
      pic2 = answer.pic2
      audioUrl = answer.audio
      avatarName = answer.avatar.name
      timestamps = answer.timestamps
      question = answer.question
      document.title = `${answer.avatar.name}'s Answer - Tometo`
      loading = false

      return getComments(params.id)
    }, err => {
      errorFlash.set(`Unable to load answer: ${err}`)
      redirect('/')
    }).then(res => {
      comments = res
    })
  })

  async function submitComment (evt) {
    commentSubmitting = true
    await createComment(commentText, params.id)
    commentSubmitting = false
    comments = await getComments(params.id)
  }
</script>

{#if loading}
  <div class="loading loading-lg"></div>
{:else}
  <div class="columns">
    <div class="column col-2 v-mid">
      <img src="https://tometo.org/img/tome.png" width=100 />
    </div>
    <div class="column col-9 card v-mid card-speech-bubble">
      <div class="card-body">
        <span class="h3">{question.content}</span>
      </div>
    </div>
  </div>
  <div class="divider"></div>
  <AnswerDisplay
    id=0
    timestamps={timestamps}
    pic1={pic1}
    pic2={pic2}
    audioUrl={audioUrl}
    name={avatarName}
  />
  <h2 class="mt-2">Comments</h2>

  {#each comments as comment, key}
    <AnswerDisplay
      id={key + 1}
      timestamps={comment.timestamps}
      pic1={comment.pic1}
      pic2={comment.pic2}
      audioUrl={comment.audio}
      name={comment.avatar.name}
      isComment
    />
    {#if comments[key + 1]}
      <div class="divider"></div>
    {/if}
  {/each}

  {#if commentSubmitting}
    <div class="loading"></div>
  {:else}
    <div class="form-group">
      <label class="form-label">Post a new comment:</label>
      <textarea class="form-input" bind:value={commentText} placeholder="Your comment..."></textarea>
    </div>
    <button class="btn btn-primary float-right" on:click={submitComment}>Submit</button>
  {/if}
{/if}
