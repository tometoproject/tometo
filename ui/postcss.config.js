module.exports = {
  plugins: {
    'postcss-import': {},
    'postcss-preset-env': {
      features: {
        'custom-media-queries': true
      }
    },
    cssnano: {}
  }
}
