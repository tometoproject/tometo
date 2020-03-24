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

<nav role="navigation" aria-label="main navigation">
  <span class="nav__subnav">
    <a href="/" class="link--no-underline">
      <img class="nav__brandimg img--vmid" width=50 src="https://tometo.org/img/tome.png" />
      <p class="nav__brand">
        tometo alpha
        {#if isDevelopment}<span class="nav__brand--small nav__brand--is-dev">(development)</span>{/if}
        {#if isStaging}<span class="nav__brand--small nav__brand--is-stage">(staging)</span>{/if}
      </p>
    </a>
    {#if $user && $hasAvatar}
      <a class="nav__item" href="/status/new">New Status</a>
    {/if}
    {#if $user && !$hasAvatar}
      <a class="nav__item" href="/avatar/new">Create Avatar</a>
    {/if}
  </span>
  <span class="nav__subnav">
    {#if !$user}
      {#if !hasInvitationsOn}
        <a class="nav__item" href="/register/fakeinvitation"><strong>Register</strong></a>
        &nbsp;|&nbsp;
      {/if}
      <a class="nav__item" href="/login"><strong>Log in</strong></a>
    {:else}
      Logged in as&nbsp; <strong>{$user.username}</strong>&nbsp;|&nbsp;
      <strong><a href="/user/invitations">Invitations</a></strong>&nbsp;|&nbsp;
      <strong><a class="link" on:click={doLogout}>Log out</a></strong>
    {/if}
  </span>
</nav>
