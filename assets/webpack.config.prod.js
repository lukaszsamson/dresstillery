const webpack = require('webpack');
const CopyWebpackPlugin = require('copy-webpack-plugin');
const ExtractTextPlugin = require("extract-text-webpack-plugin");
const path = require('path');

const elmSource = __dirname + '/src';

module.exports = {
  bail: true,
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
      'process.env.NODE_ENV': JSON.stringify('production')
    }),
    new webpack.EnvironmentPlugin(["BACKEND_URL"]),
    new CopyWebpackPlugin([{ from: './static/', to: '..' }]),
    new ExtractTextPlugin({
      // filename: '[name]-[hash].css',
      filename: '../css/[name].css',
      allChunks: true
    }),
    new webpack.optimize.ModuleConcatenationPlugin(),
    new webpack.optimize.UglifyJsPlugin({
      beautify: false,
      mangle: {
        screw_ie8: true,
        keep_fnames: true
      },
      compress: {
        warnings: false,
        screw_ie8: true
      },
      comments: false,
      ie8: false
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
        use: [
          {
            loader: "elm-webpack-loader",
            options: {
              debug: false,
              warn: true
            }
          }
        ]
      },
      {
        test: /\.scss$/,
        exclude: [/elm-stuff/, /node_modules/],
        loaders: ["style-loader", "css-loader", "sass-loader"]
      },
      {
        test: /\.css$/,
        exclude: [/elm-stuff/],
        loaders: ["style-loader", "css-loader"]
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
