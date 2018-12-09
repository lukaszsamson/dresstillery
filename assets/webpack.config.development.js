const webpack = require('webpack');
const CopyWebpackPlugin = require('copy-webpack-plugin');
const MiniCssExtractPlugin = require('mini-css-extract-plugin');
const path = require('path');

const elmSource = __dirname + '/src';

module.exports = {
  entry: {
    app: './src/app.js',
    backend: './backend/js/backend.js'
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
    new CopyWebpackPlugin([{
      from: './static/',
      to: '..'
    }]),
    new MiniCssExtractPlugin({
      filename: `../css/[name].css`
    })
  ],
  module: {
    rules: [{
        test: /\.html$/,
        exclude: /node_modules/,
        loader: 'file-loader?name=[name].[ext]'
      },
      {
        test: /\.md$/,
        use: [{
          loader: "raw-loader"
        }]
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
        loaders: [MiniCssExtractPlugin.loader, "css-loader", "sass-loader"]
      },
      {
        test: /\.css$/,
        exclude: [/elm-stuff/, /node_modules/],
        loaders: [MiniCssExtractPlugin.loader, "css-loader"]
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
