import Vue from 'vue'
import VueRouter from 'vue-router'

// TODO: Figure out why using import() here isn't working, even with the Babel plugin
const Home = () => System.import(/* webpackChunkName: "home" */ './components/Home.vue')
const Register = () => System.import(/* webpackChunkName: "register" */ './components/Register.vue')
const Login = () => System.import(/* webpackChunkName: "login" */ './components/Login.vue')
const GetStatus = () => System.import(/* webpackChunkName: "getstatus" */ './components/GetStatus.vue')
const NewStatus = () => System.import(/* webpackChunkName: "newstatus" */ './components/NewStatus.vue')

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
