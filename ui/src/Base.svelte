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
  import GetAnswer from './pages/GetAnswer.svelte'
  import Invitations from './pages/Invitations.svelte'
  import RedeemInvitation from './pages/RedeemInvitation.svelte'
  import Inbox from './pages/Inbox.svelte'

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
    .on('/answer/:id', setRoute(GetAnswer))
    .on('/user/invitations', setRoute(Invitations))
    .on('/i/:code', setRoute(RedeemInvitation))
    .on('/inbox', setRoute(Inbox))

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

<section class="container columns">
  <div class="column col-3 col-xl-2 hide-md"></div>
  <div class="column col-6 col-xl-8 col-md-12">
    {#if !$cookiesAcknowledged}
      <div class="toast" on:click={turnOffCookieNotification}>
        We use cookies to keep you logged in, but for nothing else.<br>
        <i>Click anywhere on this notification to close it.</i>
      </div>
    {/if}
    {#if $infoFlash}
      <div class="toast">{$infoFlash}</div>
    {/if}
    {#if $errorFlash}
      <div class="toast toast-error">{$errorFlash}</div>
    {/if}
    <main>
      <svelte:component this={route} bind:params={routeParams} />
    </main>
  </div>
  <div class="column col-3 col-xl-2 hide-md"></div>
</section>
<footer class="gray text-center">
  running Tometo {version}{#if !prod}-dev{/if}
  • <a href="https://git.tometo.org/source/tometo" class="text-underline gray">source</a>
</footer>
