const webpackConfig = require('./webpack.common')
const TerserWebpackPlugin = require('terser-webpack-plugin')
const OptimizeCSSAssetsPlugin = require('optimize-css-assets-webpack-plugin')

module.exports = {
	mode: 'production',
	devtool: 'source-map',
	optimization: {
		minimizer: [new TerserWebpackPlugin({}), new OptimizeCSSAssetsPlugin({})]
	},
	...webpackConfig
}
