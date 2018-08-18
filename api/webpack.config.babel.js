import path from 'path'
import webpack from 'webpack'
import zip from 'zip-webpack-plugin'

export default {
  entry: path.resolve(__dirname),
  output: {
    path: path.join(__dirname, '..', 'build'),
    filename: 'index.js',
    library: 'index',
    libraryTarget: 'umd',
  },
  target: 'node',
  module: {
    rules: [
      {
        test: /\.js$/,
        include: path.resolve(__dirname, '..'),
        exclude: path.resolve(__dirname, '..', 'node_modules'),
        loader: 'babel-loader',
      },
      {
        test: /\.graphql$/,
        include: path.resolve(__dirname, '..'),
        exclude: path.resolve(__dirname, '..', 'node_modules'),
        loader: 'graphql-tag/loader',
      },
    ],
  },

  plugins: [
    new webpack.ProvidePlugin({
      XMLHttpRequest: ['xmlhttprequest', 'XMLHttpRequest'],
    }),
    new zip({
      filename: 'graphql.zip',
    }),
  ],
}
