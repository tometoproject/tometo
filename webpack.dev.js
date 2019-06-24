const webpackConfig = require('./webpack.common')

module.exports = {
  mode: 'development',
  devtool: 'inline-source-map',
  devServer: {
    contentBase: './dist',
    port: 1234
  },
  ...webpackConfig
}
