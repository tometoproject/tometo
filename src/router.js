import Vue from 'vue'
import VueRouter from 'vue-router'

import Home from './components/pages/HomePage.vue'
import Register from './components/pages/RegisterPage.vue'
import Login from './components/pages/LoginPage.vue'
import CreateStatus from './components/pages/CreateStatusPage.vue'
import GetStatus from './components/pages/GetStatusPage.vue'
import CreateAvatar from './components/pages/CreateAvatarPage.vue'
import EditAvatar from './components/pages/EditAvatarPage.vue'

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
