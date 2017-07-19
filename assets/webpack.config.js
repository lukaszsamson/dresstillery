const webpack = require('webpack');
const path = require('path');

const elmSource = __dirname + '/src';

module.exports = {
  entry: './src/index.js',

  output: {
    path: path.join(__dirname, "dist"),
    filename: 'index.js'
  },

  resolve: {
    modules: [
      path.join(__dirname, "src"),
      path.join(__dirname, "txt"),
      "node_modules"
    ],
    extensions: ['.js', '.elm', '.scss', '.css', '.md']
  },
  plugins: [
    new webpack.NamedModulesPlugin(),
    new webpack.NoEmitOnErrorsPlugin(),
    new webpack.EnvironmentPlugin(["BACKEND_URL"])
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
        test: /\.woff(2)?(\?v=[0-9]\.[0-9]\.[0-9])?$/,
        exclude: [/elm-stuff/, /node_modules/],
        loader: "url-loader",
        options: {
          limit: 10000,
          mimetype: "application/font-woff"
        }
      },
      {
        test: /\.(ttf|eot|svg)(\?v=[0-9]\.[0-9]\.[0-9])?$/,
        exclude: [/elm-stuff/, /node_modules/],
        loader: "file-loader"
      }
    ]
  },

  devServer: {
    proxy: {
      [process.env.BACKEND_URL]: {
        target: `http://localhost:${process.env.API_PORT}`,
        pathRewrite: {[`^${process.env.BACKEND_URL}`] : ''}
      }
    },
    inline: true,
    stats: 'errors-only',
    historyApiFallback: true,
    // needed to serve external requests without external host set
    disableHostCheck: true
  }
};
