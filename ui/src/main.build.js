// The SCSS file is for customizing our Spectre.css build. The CSS file is
// our custom CSS that goes on top of that.
import './css/custom.scss'
import './css/main.css'

import Base from './Base.svelte'

const base = new Base({
  target: document.body
})

export default base
