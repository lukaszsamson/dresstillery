const webpack = require('webpack');
const CopyWebpackPlugin = require('copy-webpack-plugin');
const MiniCssExtractPlugin = require('mini-css-extract-plugin');
const OptimizeCssAssetsPlugin = require('optimize-css-assets-webpack-plugin');
const TerserPlugin = require('terser-webpack-plugin');
const path = require('path');

const elmSource = __dirname + '/src';

module.exports = {
  bail: true,
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
      'process.env.NODE_ENV': JSON.stringify('production'),
      'process.env.FB_APP_ID': JSON.stringify('191715151387019'),
      'process.env.BACKEND_URL': JSON.stringify('/api')
    }),
    new CopyWebpackPlugin([{
      from: './static/',
      to: '..'
    }]),
    new MiniCssExtractPlugin({
      filename: `../css/[name].css`
    }),
    new OptimizeCssAssetsPlugin({
      assetNameRegExp: /\.css$/g,
      cssProcessor: require('cssnano'),
      cssProcessorOptions: {
        discardComments: {
          removeAll: true
        }
      },
      canPrint: true
    }),
    new TerserPlugin({
      terserOptions: {
        ecma: 6,
      }
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
        use: [{
          loader: "raw-loader"
        }]
      },
      {
        test: /\.elm$/,
        exclude: [/elm-stuff/, /node_modules/],
        use: [{
          loader: "elm-webpack-loader",
          options: {
            debug: false,
            warn: true
          }
        }]
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
