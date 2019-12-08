<template>
  <div id="app">
    <app-header />
    <section class="page center">
      <div>
        <div
          v-if="!cookiesAcknowledged"
          class="flash flash--info"
          @click="hideCookies"
        >
          We use cookies to keep you logged in, but nothing else.<br>
          <i>Click anywhere on this notification to close it.</i>
        </div>
        <div
          v-if="infoFlashMessage"
          class="flash"
        >
          {{ infoFlashMessage }}
        </div>
        <div
          v-if="errorFlashMessage"
          class="flash flash--error"
        >
          {{ errorFlashMessage }}
        </div>
        <router-view />
      </div>
    </section>
    <section class="footer">
      running tometo
      <span v-if="isDevelopment">off {{ branch }}</span>
      <span v-else-if="isStaging">{{ gitVersion }} off {{ branch }}</span>
      <span v-else>{{ version }}</span>
      • <a
        class="footer__link"
        href="https://github.com/tometoproject/tometo"
      >github</a>
    </section>
  </div>
</template>

<script>
import TheHeader from './components/TheHeader.vue'
import { version } from '../../package.json'

export default {
  name: 'App',
  components: {
    'app-header': TheHeader
  },
  data () {
    return {
      version,
      gitVersion: VERSION,
      branch: BRANCH
    }
  },
  computed: {
    errorFlashMessage () {
      return this.$store.state.flash.error
    },
    infoFlashMessage () {
      return this.$store.state.flash.info
    },
    cookiesAcknowledged () {
      return this.$store.state.cookiesAcknowledged
    },
    isStaging () {
      return process.env.TOMETO_ENV === 'staging'
    },
    isDevelopment () {
      return process.env.TOMETO_ENV === 'development'
    }
  },
  methods: {
    hideCookies () {
      this.$store.commit('setCookies')
    }
  }
}
</script>
