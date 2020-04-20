<script>
  import { onMount } from 'svelte'
  import { getQuestions, postQuestion } from '../../actions'
  import {
    format,
    add,
    set,
    differenceInHours,
    parse,
    parseISO
  } from 'date-fns'

  const curDate = new Date()
  let questions = null
  let addModalActive = false
  let content
  let date = format(curDate, 'yyyy-MM-dd')
  let time = format(add(curDate, { minutes: 10 }), 'kk:mm')
  $: combinedDate = set(parse(date, 'yyyy-MM-dd', new Date()), { hours: time.split(':')[0], minutes: time.split(':')[1] })
  $: timeUntilPost = differenceInHours(combinedDate, curDate)

  function toggleModal (e) {
    addModalActive = !addModalActive
  }

  async function submitQuestion (e) {
    const isoTime = combinedDate.toISOString()
    await postQuestion(content, isoTime)
  }

  onMount(async () => {
    questions = await getQuestions()
  })
</script>

<div class="btn mb-2" on:click={toggleModal}>Add question</div>

<div class="modal {addModalActive && 'active'}">
  <div on:click={toggleModal} class="modal-overlay" aria-label="Close"></div>
  <div class="modal-container">
    <div class="modal-header">
      <div on:click={toggleModal} class="btn btn-clear float-right" aria-label="Close"></div>
      <div class="modal-title h5">Add Question</div>
    </div>
    <div class="modal-body">
      <div class="form-group">
        <label class="form-label">Content</label>
        <textarea class="form-input" rows=3 bind:value={content}></textarea>
      </div>
      <div class="form-group">
        <label class="form-label">Time</label>
        <input class="form-input" type="date" bind:value={date} />
        <input type="time" class="form-input mt-1 mb-1" bind:value={time} />
      </div>
    </div>
    <div class="modal-footer">
      <button class="btn btn-primary" on:click={submitQuestion}>Post in ~{timeUntilPost} hours</button>
    </div>
  </div>
</div>

{#if !questions}
  <div class="loading loading-lg"></div>
{:else if questions.length === 0}
  <div class="empty">
    <div class="empty-title h4">No questions!</div>
  </div>
{:else}
  <table class="table">
    <thead>
      <tr>
        <th>Content</th>
        <th>Posted At</th>
      </tr>
    </thead>
    <tbody>
      {#each questions as question}
        <tr>
          <td>{question.content}</td>
          <td>{format(parseISO(question.inserted_at), 'do \'of\' MMMM, yyyy / hh:mm a \'(UTC)\'')}</td>
        </tr>
      {/each}
    </tbody>
  </table>
{/if}
