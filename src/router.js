import Vue from 'vue'
import VueRouter from 'vue-router'
import Home from './components/Home.vue'
import Register from './components/Register.vue'
import Login from './components/Login.vue'
import GetStatus from './components/GetStatus.vue'
import NewStatus from './components/NewStatus.vue'

Vue.use(VueRouter)

export default new VueRouter({
  mode: 'history',
  routes: [
    { path: '/', component: Home },
    { path: '/register', component: Register },
    { path: '/login', component: Login },
    { path: '/status/new', component: NewStatus },
    { path: '/status/:id', component: GetStatus }
  ]
})
