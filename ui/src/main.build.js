import './css/variables.css'
import './css/base.css'
import './css/grid.css'
import './css/nav.css'
import './css/form.css'
import './css/button.css'
import './css/misc.css'

import Base from './Base.svelte'

const base = new Base({
  target: document.body
})

export default base
