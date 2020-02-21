const webpackConfig = require('./webpack.common')
const TerserWebpackPlugin = require('terser-webpack-plugin')
const OptimizeCSSAssetsPlugin = require('optimize-css-assets-webpack-plugin')

const options = {
  mode: 'production',
  devtool: 'source-map',
  optimization: {
    minimizer: [new TerserWebpackPlugin({}), new OptimizeCSSAssetsPlugin({})]
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
