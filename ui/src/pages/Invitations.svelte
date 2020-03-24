<script>
  import { getInvitations, createInvitation } from '../actions'
  import { errorFlash } from '../stores'
  import { redirect } from '../utils'

  let invitations = []
  let limit = 0

  getInvitations().then(res => {
    invitations = res.data
    limit = res.limit
  }).catch(err => {
    errorFlash.set('Unable to load invitations!')
    redirect('/')
  })

  async function addInvitation () {
    try {
      const invitation = await createInvitation()
      invitations = [invitation, ...invitations]
    } catch (e) {
      errorFlash.set('Error when trying to create an invitation!')
    }
  }
</script>

<h1>Invitations</h1>

<div class="text--center">
  <p>You have <strong>{limit - invitations.length}</strong> invitations left.</p>
  <button on:click|preventDefault={addInvitation}>
    New invitation
  </button>
</div>

<h2>Your invitations</h2>

<div class="grid grid__outline grid--3-2-1-1">
  <p><strong>Link</strong></p>
  <p><strong>Status</strong></p>
  <p><strong>Used By</strong></p>
</div>

{#each invitations as inv, key}
  <div key={key} class="grid grid--3-2-1-1">
    <p><a href={`${process.env.T_FRONTEND_URL}/i/${inv.code}`}>{inv.code}</a></p>
    <p>{#if inv.used_by}USED{:else}UNUSED{/if}</p>
    {#if inv.used_by}<p>{inv.used_by.username}</p>{/if}
  </div>
{/each}
