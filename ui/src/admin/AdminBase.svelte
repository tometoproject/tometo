<script>
  import navaid from 'navaid'
  import { onMount } from 'svelte'
  import { user } from '../stores'
  import { poll } from '../actions'
  import { redirect } from '../utils'
  import Index from './pages/AdminIndex.svelte'
  import Questions from './pages/AdminQuestions.svelte'

  export let router = navaid()
  let route
  let routeParams

  router
    .on('/admin', setRoute(Index))
    .on('/admin/questions', setRoute(Questions))

  router.listen()

  function setRoute (r) {
    return params => {
      route = r
      routeParams = params
    }
  }

  onMount(async () => {
    await poll()
    if (!$user) {
      redirect('/login', { replace: true })
      window.location.reload()
    }
  })
</script>

<header class="navbar">
  <section class="navbar-section">
    <strong><a href="/admin" class="navbar-brand mr-2">tometo admin</a></strong>
    <a class="btn btn-link" href="/admin/questions">Questions</a>
  </section>

  <section class="navbar-section">
    <p class="pt-2">logged in as <strong>{$user && $user.username}</strong></p>
  </section>
</header>

<main>
  <div class="container columns">
    <div class="column col-2"></div>
    <div class="column col-8">
      <svelte:component this={route} bind:params={routeParams} />
    </div>
    <div class="column col-2"></div>
  </div>
</main>
