const webpack = require('webpack');
const CopyWebpackPlugin = require('copy-webpack-plugin');
const ExtractTextPlugin = require("extract-text-webpack-plugin");
const path = require('path');

const elmSource = __dirname + '/src';

module.exports = {
  devtool: 'cheap-module-source-map',
  entry: {
    app: './src/app.js',
    backend: './backend/js/backend.js',
  },

  output: {
    path: path.join(__dirname, "../priv/static/js"),
    filename: '[name].js',
  },

  resolve: {
    modules: [
      path.join(__dirname, "src"),
      path.join(__dirname, "txt"),
      path.join(__dirname, "backend"),
      "node_modules"
    ],
    extensions: ['.js', '.elm', '.scss', '.css', '.md']
  },
  plugins: [
    new webpack.DefinePlugin({
      'process.env.NODE_ENV': JSON.stringify('development'),
      'process.env.FB_APP_ID': JSON.stringify('129842534345154'),
      'process.env.BACKEND_URL': JSON.stringify('/api')
    }),
    new webpack.NamedModulesPlugin(),
    new webpack.NoEmitOnErrorsPlugin(),
    new CopyWebpackPlugin([{ from: './static/', to: '..' }]),
    new ExtractTextPlugin({
      // filename: '[name]-[hash].css',
      filename: '../css/[name].css',
      allChunks: true
    }),
  ],
  module: {
    rules: [{
        test: /\.html$/,
        exclude: /node_modules/,
        loader: 'file-loader?name=[name].[ext]'
      },
      {
        test: /\.md$/,
        use: [
          {
            loader: "raw-loader"
          }
        ]
      },
      {
        test: /\.elm$/,
        exclude: [/elm-stuff/, /node_modules/],
        use: [{
            loader: "elm-hot-loader"
          },
          {
            loader: "elm-webpack-loader",
            options: {
              debug: true,
              warn: true
            }
          }
        ]
      },
      {
        test: /\.scss$/,
        exclude: [/elm-stuff/, /node_modules/],
        // loaders: ["style-loader", "css-loader", "sass-loader"]
        use: ExtractTextPlugin.extract({
          fallback: 'style-loader',
          //resolve-url-loader may be chained before sass-loader if necessary
          use: ['css-loader', "sass-loader"]
        })
      },
      {
        test: /\.css$/,
        exclude: [/elm-stuff/],
        // loaders: ["style-loader", "css-loader"]
        use: ExtractTextPlugin.extract({
          fallback: 'style-loader',
          //resolve-url-loader may be chained before sass-loader if necessary
          use: ['css-loader']
        })
      },
      {
        test: /\.(jpg|png|gif|svg|ico)$/,
        exclude: [/elm-stuff/, /node_modules/],
        loaders: ["url-loader"]
      },
      {
        test: /\.woff2?(\?v=[0-9]\.[0-9]\.[0-9])?$/,
        // Limiting the size of the woff fonts breaks font-awesome ONLY for the extract text plugin
        // loader: "url?limit=10000"
        use: "url-loader"
      },
      {
        test: /\.(ttf|eot|svg)(\?[\s\S]+)?$/,
        use: 'file-loader'
      },
    ]
  }
};
