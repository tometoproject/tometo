<script>
  import { user, hasAvatar } from '../stores'
  import { logout } from '../actions'

  const isStaging = process.env.T_ENV === 'staging'
  const isDevelopment = process.env.T_ENV === 'development'
  const hasInvitationsOn = process.env.T_REQUIRE_INVITATIONS

  function doLogout () {
    logout()
  }
</script>

{#if isStaging}
  <div class="banner">
    This is a <strong>staging environment!</strong> All content is reset every hour at zero minutes,
    including user accounts!
  </div>
{/if}

<nav role="navigation" aria-label="main navigation" class="navbar main-nav container">
  <section class="navbar-section">
    <a href="/" class="navbar-brand btn btn-link">
      <img
        class="v-mid"
        alt="Tometo logo"
        width=29
        src="https://tometo.org/img/tome.png"
      />
      <span class="text-bold v-mid">
        Tometo α
        {#if isDevelopment}<span class="color-dev">dev</span>{/if}
        {#if isStaging}<span class="color-stage">staging</span>{/if}
      </span>
    </a>
    {#if $user && $hasAvatar}
      <a class="btn btn-link" href="/status/new">New Status</a>
    {/if}
    {#if $user && !$hasAvatar}
      <a class="btn btn-link" href="/avatar/new">Create Avatar</a>
    {/if}
  </section>
  <section class="navbar-section">
    {#if !$user}
      {#if !hasInvitationsOn}
        <a class="btn btn-link" href="/register/fakeinvitation"><strong>Register</strong></a>
      {/if}
      <a class="btn btn-link" href="/login"><strong>Log in</strong></a>
    {:else}
      <span class="item">Logged in as <span class="text-bold">{$user.username}</span></span>
      <a class="btn btn-link text-bold" href="/user/invitations">Invitations</a>
      <a class="btn btn-link text-bold" href="/" on:click|preventDefault={doLogout}>Log out</a>
    {/if}
  </section>
</nav>
