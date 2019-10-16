import Vue from 'vue'
import VueRouter from 'vue-router'

import Home from './components/Home.vue'
import Register from './components/Register.vue'
import Login from './components/Login.vue'
import CreateStatus from './components/CreateStatus.vue'
import GetStatus from './components/GetStatus.vue'
import CreateAvatar from './components/CreateAvatar.vue'
import EditAvatar from './components/EditAvatar.vue'

Vue.use(VueRouter)

export default new VueRouter({
	mode: 'history',
	routes: [
		{ path: '/', component: Home },
		{ path: '/register', component: Register },
		{ path: '/login', component: Login },
		{ path: '/status/new', component: CreateStatus },
		{ path: '/status/:id', component: GetStatus },
		{ path: '/avatar/new', component: CreateAvatar },
		{ path: '/avatar/edit/:id', component: EditAvatar }
	]
})
