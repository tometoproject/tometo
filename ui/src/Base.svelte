<script>
  import navaid from 'navaid'
  import { onMount } from 'svelte'
  import { cookiesAcknowledged, infoFlash, errorFlash } from './stores'
  import { poll } from './actions'
  import Header from './components/PageHeader.svelte'
  import Index from './pages/Index.svelte'
  import Login from './pages/Login.svelte'
  import Register from './pages/Register.svelte'
  import CreateAvatar from './pages/CreateAvatar.svelte'
  import CreateStatus from './pages/CreateStatus.svelte'
  import GetStatus from './pages/GetStatus.svelte'
  import Invitations from './pages/Invitations.svelte'
  import RedeemInvitation from './pages/RedeemInvitation.svelte'
  import AdminBase from './admin/AdminBase.svelte'

  export let router = navaid()
  let route
  let routeParams
  const version = process.version
  const prod = process.env.T_ENV === 'production'

  router
    .on('/', setRoute(Index))
    .on('/login', setRoute(Login))
    .on('/register/:code', setRoute(Register))
    .on('/avatar/new', setRoute(CreateAvatar))
    .on('/status/new', setRoute(CreateStatus))
    .on('/status/:id', setRoute(GetStatus))
    .on('/user/invitations', setRoute(Invitations))
    .on('/i/:code', setRoute(RedeemInvitation))

    .on('/admin', setRoute(AdminBase))

  router.listen()

  function setRoute (r) {
    return params => {
      route = r
      routeParams = params
    }
  }

  function turnOffCookieNotification () {
    cookiesAcknowledged.set(true)
    localStorage.setItem('cookiesAcknowledged', true)
  }

  onMount(async () => {
    await poll()
  })
</script>

<Header/>

<section class="page center">
  {#if !$cookiesAcknowledged}
    <div class="flash flash--info" on:click={turnOffCookieNotification}>
      We use cookies to keep you logged in, but for nothing else.<br>
      <i>Click anywhere on this notification to close it.</i>
    </div>
  {/if}
  {#if $infoFlash}
    <div class="flash">{$infoFlash}</div>
  {/if}
  {#if $errorFlash}
    <div class="flash flash--error">{$errorFlash}</div>
  {/if}
  <svelte:component this={route} bind:params={routeParams} />
</section>
<section class="footer">
  running Tometo {version}{#if !prod}-dev{/if}
  • <a href="https://git.tometo.org/source/tometo" class="footer__link">source</a>
</section>
