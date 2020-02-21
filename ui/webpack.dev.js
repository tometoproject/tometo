const webpackConfig = require('./webpack.common')
const path = require('path')

const options = {
  mode: 'development',
  devtool: 'inline-source-map',
  devServer: {
    contentBase: path.join(__dirname, '../dist'),
    port: 1234,
    compress: true,
    historyApiFallback: {
      rewrites: [
        { from: /^\/admin\/?.*/, to: '/admin.html' },
        { from: /./, to: '/index.html' }
      ]
    }
  }
}

module.exports = [
  {
    ...options,
    ...webpackConfig[0]
  },
  {
    ...options,
    ...webpackConfig[1]
  }
]
