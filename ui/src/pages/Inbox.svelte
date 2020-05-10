<script>
  import { onMount } from 'svelte'
  import { fade } from 'svelte/transition'
  import { getInboxes, createAnswer } from '../actions'

  let inboxes = []
  let loading = true
  const answers = []

  onMount(async () => {
    const res = await getInboxes()
    inboxes = res.map(inbox => {
      return {
        submitting: false,
        content: inbox,
        answerLink: null
      }
    })
    loading = false
  })

  const onSubmit = (inboxNum) => async () => {
    const inbox = inboxes[inboxNum]
    const answer = answers[inboxNum]

    inboxes[inboxNum].submitting = true

    const res = await createAnswer(answer, inbox.content.id)
    inboxes[inboxNum].submitting = false
    inboxes[inboxNum].answerLink = `/answer/${res.id}`
  }
</script>

<h1>Inbox</h1>

{#if loading}
  <div class="loading loading-lg"></div>
{/if}

{#if inboxes.length === 0 && !loading}
  <div class="empty">
    <p class="empty-title h5">No questions!</p>
    <p class="empty-subtitle">
      Looks like there's no questions waiting for you right now. Check back later!
    </p>
  </div>
{/if}

{#each inboxes as inbox, key}
  <div class="card" key={key}>
    {#if inbox.submitting}
      <div class="card-body" in:fade>
        <div class="loading loading-lg"></div>
      </div>
    {:else if inbox.answerLink}
      <div class="card-body" in:fade>
        Successfully posted your answer! You can view it here: <a href={inbox.answerLink}>{inbox.answerLink}</a>
      </div>
    {:else}
      <div class="card-header card-gray-header">
        <div class="card-subtitle text-dark-gray">You got asked:</div>
        <h2 class="card-title">{inbox.content.question.content}</h2>
      </div>
      <div class="card-body">
        <textarea class="form-input" bind:value={answers[key]} placeholder="Your answer..."></textarea>
        <button class="btn btn-primary float-right" on:click|preventDefault={onSubmit(key)}>Submit</button>
      </div>
    {/if}
  </div>

  {#if inboxes[key + 1]}
    <div class="divider"></div>
  {/if}
{/each}
