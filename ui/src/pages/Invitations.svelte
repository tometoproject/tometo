<script>
  import { getInvitations, createInvitation } from '../actions'
  import { errorFlash } from '../stores'
  import { redirect } from '../utils'

  let invitations = []
  let limit = 0
  $: quota = invitations.length * (100 / limit)

  getInvitations().then(res => {
    invitations = res.data
    limit = res.limit
  }).catch(err => {
    errorFlash.set(`Unable to load invitations: ${err.message}`)
    redirect('/')
  })

  async function addInvitation () {
    try {
      const invitation = await createInvitation()
      invitations = [invitation.data, ...invitations]
    } catch (e) {
      errorFlash.set(`Error when trying to create an invitation: ${e}`)
    }
  }
</script>

<h1>Invitations</h1>

<div class="container">
  <div class="bar">
    <div
      class="bar-item"
      role="progressbar"
      style="width:{quota}%"
      aria-valuenow={quota}
      aria-valuemin=0
      aria-valuemax=100>
      Used: {invitations.length}/{limit}
    </div>
  </div>
  <div class="btn-group btn-group-block">
  <button class="btn btn-primary" on:click|preventDefault={addInvitation}>
    New invitation
  </button>
  </div>
</div>

<div class="container">
  <h2>Your invitations</h2>

  <table class="table table-striped">
    <thead>
      <th><strong>Link</strong></th>
      <th><strong>Status</strong></th>
      <th><strong>Used By</strong></th>
    </thead>
    <tbody>
      {#each invitations as inv, key}
        <tr key={key}>
          <td><a href={`${process.env.T_FRONTEND_URL}/i/${inv.code}`}>{inv.code}</a></td>
          <td>{#if inv.used_by}Used{:else}Unused{/if}</td>
          {#if inv.used_by}<td>{inv.used_by.username}</td>{/if}
        </tr>
      {/each}
    </tbody>
  </table>
</div>
