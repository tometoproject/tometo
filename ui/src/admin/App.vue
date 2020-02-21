<template>
  <div class="container">
    <header class="navbar mt-2">
      <section class="navbar-section">
        <a href="/admin" class="navbar-brand text-bold">Tometo Admin</a>
      </section>
    </header>
    <main class="container columns">
      <div class="col-2">

      </div>
      <div class="col-8"><router-view /></div>
      <div class="col-2">

      </div>
    </main>
  </div>
</template>

<script>
  export default {
    name: 'App'
  }
</script>
