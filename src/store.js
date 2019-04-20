import Vue from 'vue'
import Vuex from 'vuex'

Vue.use(Vuex)

export default new Vuex.Store({
  state: {
    message: 'Hello'
  },
  mutations: {
    changeMessage (state, msg) {
      state.message = msg
    }
  }
})