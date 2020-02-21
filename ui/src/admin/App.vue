<template>
  <div class="container">
    <header class="navbar mt-2">
      <section class="navbar-section">
        <router-link
          to="/admin"
          class="navbar-brand text-bold"
        >
          Tometo Admin
        </router-link>
      </section>
    </header>
    <main class="container columns">
      <div class="col-2" />
      <div class="col-8">
        <router-view />
      </div>
      <div class="col-2" />
    </main>
  </div>
</template>

<script>
export default {
  name: 'App'
}
</script>
