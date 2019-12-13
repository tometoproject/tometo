const path = require('path')
const webpack = require('webpack')
const VueLoaderPlugin = require('vue-loader/lib/plugin')
const MiniCssExtractPlugin = require('mini-css-extract-plugin')
const GitRevisionPlugin = require('git-revision-webpack-plugin')
const Dotenv = require('dotenv-webpack')
const grp = new GitRevisionPlugin()

module.exports = {
  entry: ['babel-polyfill', './ui/src/index.js'],
  output: {
    filename: 'bundle.js',
    chunkFilename: '[name].bundle.js',
    path: path.resolve(__dirname, '../dist')
  },
  module: {
    rules: [
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
        test: /\.s[ac]ss$/,
        exclude: /node_modules/,
        use: [
          MiniCssExtractPlugin.loader,
          { loader: 'css-loader', options: { url: false, sourceMap: true } },
          {
            loader: 'sass-loader',
            options: {
              implementation: require('sass'),
              sourceMap: true
            }
          }
        ]
      },
      {
        test: /\.toml$/,
        loader: 'raw-loader',
        exclude: /node_modules/
      }
    ]
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
}
