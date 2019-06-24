const webpackConfig = require('./webpack.config')

module.exports = {
  mode: 'development',
  devtool: 'inline-source-map',
  devServer: {
    contentBase: './dist',
    port: 1234
  },
  ...webpackConfig
}
