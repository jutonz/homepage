const path = require("path");
const ExtractTextPlugin = require("extract-text-webpack-plugin");

const webpackConfig = {
  entry: "./../assets/js/app.ts",
  output: {
    filename: "js/app.js",
    path: path.resolve(__dirname, "../priv/static")
  },

  module: {
    rules: [
      // Handle ts and tsx
      // See assets/.babelrc for additional babel-preset-env config
      {
        test: /\.(ts|tsx)$/,
        use: [
          {
            loader: "babel-loader",
          },
          "ts-loader"
        ],
        include: path.resolve(__dirname, "js")
      },
      // Handle semantic-ui images
      {
        test: /\.jpe?g$|\.gif$|\.png$|\.ttf$|\.eot$|\.svg$/,
        use: 'file-loader?name=[name].[ext]?[hash]',
        include: [
          path.resolve(__dirname, "node_modules/semantic-ui-less")
        ]
      },
      // Handle semantic-ui fonts
      {
        test: /\.woff(2)?(\?v=[0-9]\.[0-9]\.[0-9])?$/,
        loader: 'url-loader?limit=10000&mimetype=application/fontwoff',
        include: [
          path.resolve(__dirname, "node_modules/semantic-ui-less")
        ]
      },
      // Handle less (semantic-ui + ours)
      {
        test: /\.less$/,
        use: ExtractTextPlugin.extract({
          use: ["css-loader", "less-loader"]
        }),
        include: [
          path.resolve(__dirname, "css"),
          path.resolve(__dirname, "node_modules/semantic-ui-less")
        ]
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
    },
    extensions: ['.ts', '.tsx', '.js']
  },
};

module.exports = webpackConfig;
