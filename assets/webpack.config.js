const path = require("path");
const ExtractTextPlugin = require("extract-text-webpack-plugin");

const webpackConfig = {
  entry: "./../assets/js/app.js",
  output: {
    filename: "js/app.js",
    path: path.resolve(__dirname, "../priv/static")
  },

  module: {
    rules: [
      // Handle js and jsx
      // See assets/.babelrc for additional babel-preset-env config
      {
        use: [{
          loader: "babel-loader",
          options: {
            presets: ["env", "react"]
          }
        }],
        test: /\.(js|jsx)$/,
        exclude: /node_modules/
      },
      // Handle less
      {
        use: ExtractTextPlugin.extract({
          use: ["css-loader", "less-loader"]
        }),
        test: /\.less$/
      },
      // Handle images
      {
        test: /\.jpe?g$|\.gif$|\.png$|\.ttf$|\.eot$|\.svg$/,
        use: 'file-loader?name=[name].[ext]?[hash]'
      },
      // Handle fonts
      {
        test: /\.woff(2)?(\?v=[0-9]\.[0-9]\.[0-9])?$/,
        loader: 'url-loader?limit=10000&mimetype=application/fontwoff'
      }
    ]
  },

  plugins: [
    // Handles bundled css output
    new ExtractTextPlugin({
      filename: "css/app.css"
    })
  ],

  resolve: {
    alias: {
      '../../theme.config$': path.join(__dirname, 'semantic-theme/theme.config')
    }
  },
};

module.exports = webpackConfig;
