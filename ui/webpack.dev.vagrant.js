const webpackConfig = require('./webpack.common')
const path = require('path')

module.exports = {
  mode: 'development',
  devtool: 'inline-source-map',
  devServer: {
    contentBase: path.join(__dirname, '../dist'),
    port: 1234,
    compress: true,
    historyApiFallback: true,
    disableHostCheck: true,
    host: "0.0.0.0",
    useLocalIp: true
  },
  ...webpackConfig
}