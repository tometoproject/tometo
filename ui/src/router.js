import Vue from 'vue'
import VueRouter from 'vue-router'

import Home from './components/pages/HomePage.vue'
import Register from './components/pages/RegisterPage.vue'
import Login from './components/pages/LoginPage.vue'
import CreateStatus from './components/pages/CreateStatusPage.vue'
import GetStatus from './components/pages/GetStatusPage.vue'
import CreateAvatar from './components/pages/CreateAvatarPage.vue'
import EditAvatar from './components/pages/EditAvatarPage.vue'
import InvitationPage from './components/pages/InvitationPage.vue'
import RedeemInvitationPage from './components/pages/RedeemInvitationPage.vue'

Vue.use(VueRouter)

let router = new VueRouter({
  mode: 'history',
  routes: [
    {
      path: '/',
      component: Home,
      meta: {
        title: 'Home - Tometo'
      }
    },
    {
      path: '/register/:code',
      component: Register,
      meta: {
        title: 'Register - Tometo'
      }
    },
    {
      path: '/login',
      component: Login,
      meta: {
        title: 'Login - Tometo'
      }
    },
    {
      path: '/status/new',
      component: CreateStatus,
      meta: {
        title: 'New Status - Tometo'
      }
    },
    {
      path: '/status/:id',
      component: GetStatus,
      meta: {
        title: 'Loading Status...'
      }
    },
    {
      path: '/avatar/new',
      component: CreateAvatar,
      meta: {
        title: 'New Avatar - Tometo'
      }
    },
    {
      path: '/avatar/edit/:id',
      component: EditAvatar,
      meta: {
        title: 'Loading Avatar...'
      }
    },
    {
      path: '/user/invitations',
      component: InvitationPage,
      meta: {
        title: 'Your invitations - Tometo'
      }
    },
    {
      path: '/i/:code',
      component: RedeemInvitationPage,
      meta: {
        title: 'Redeem Invitation - Tometo'
      }
    }
  ]
})

router.beforeEach((to, from, next) => {
  // Find the closest URL segment that has a title specified, so when you have
  // /my/cool/route, and only /my/cool has a title, it'll pick that one.
  const nearestWithTitle = to.matched.slice().reverse().find(r => r.meta && r.meta.title)
  // Likewise with the meta tags.
  const nearestWithMeta = to.matched.slice().reverse().find(r => r.meta && r.meta.metaTags)

  // If we have a route with a title, set it.
  if (nearestWithTitle) {
    document.title = nearestWithTitle.meta.title
  }

  // Remove any outdated meta tags from the document.
  Array.from(document.querySelectorAll('[data-vue-router-controlled]')).map(el => el.parentNode.removeChild(el))

  // Skip rendering meta tags if there are none.
  if (!nearestWithMeta) {
    return next()
  }

  // Turn the meta tags into actual elements in the document head.
  nearestWithMeta.meta.metaTags.map(tag => {
    const t = document.createElement('meta')
    Object.keys(tag).forEach(key => {
      t.setAttribute(key, tag[key])
    })
    // Use this to differentiate dynamically set meta tags from the ones that
    // are defined in dist/index.html from the start.
    t.setAttribute('data-vue-router-controlled', '')
    return t
  }).forEach(tag => document.head.appendChild(tag))

  next()
})

export default router
