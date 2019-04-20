import VueRouter from 'vue-router'
import Home from './components/Home.vue'

export const router = new VueRouter({
  mode: 'history',
  base: __dirname,
  routes: [
    { path: '/', component: Home }
  ]
})
