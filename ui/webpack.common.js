const path = require('path')
const webpack = require('webpack')
const VueLoaderPlugin = require('vue-loader/lib/plugin')
const MiniCssExtractPlugin = require('mini-css-extract-plugin')
const GitRevisionPlugin = require('git-revision-webpack-plugin')
const Dotenv = require('dotenv-webpack')
const grp = new GitRevisionPlugin()

const commonModuleRules = [
  {
    test: /\.vue$/,
    loader: 'vue-loader'
  },
  {
    test: /\.js$/,
    loader: 'babel-loader',
    exclude: /node_modules/
  },
  {
    test: /\.css$/,
    exclude: /node_modules/,
    use: [
      MiniCssExtractPlugin.loader,
      { loader: 'css-loader', options: { url: false, sourceMap: true, importLoaders: 1 } },
      { loader: 'postcss-loader' }
    ]
  },
  {
    test: /\.toml$/,
    loader: 'raw-loader',
    exclude: /node_modules/
  }
]

module.exports = [{
  name: 'index',
  entry: './ui/src/index.js',
  output: {
    filename: 'index.js',
    chunkFilename: '[name].index.js',
    path: path.resolve(__dirname, '../dist')
  },
  module: {
    rules: commonModuleRules
  },
  plugins: [
    new VueLoaderPlugin(),
    new MiniCssExtractPlugin({
      filename: 'style.css'
    }),
    new webpack.DefinePlugin({
      'VERSION': JSON.stringify(grp.version()),
      'BRANCH': JSON.stringify(grp.branch())
    }),
    new Dotenv()
  ]
}, {
  name: 'admin',
  entry: './ui/src/admin.js',
  output: {
    filename: 'admin.js',
    chunkFilename: '[name].admin.js',
    path: path.resolve(__dirname, '../dist')
  },
  module: {
    rules: commonModuleRules
  },
  plugins: [
    new VueLoaderPlugin(),
    new Dotenv()
  ]
}]
