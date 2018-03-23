const path = require("path");
const ExtractTextPlugin = require("extract-text-webpack-plugin");

const webpackConfig = {
  entry: "./../assets/js/Index.tsx",
  output: {
    filename: "js/index.js",
    path: path.resolve(__dirname, "../priv/static")
  },

  module: {
    rules: [
      // Handle ts and tsx
      {
        test: /\.(ts|tsx)$/,
        use: [
          "babel-loader",
          "ts-loader"
        ],
        include: path.resolve(__dirname, "js")
      },
      // Handle semantic-ui images
      {
        test: /\.jpe?g$|\.gif$|\.png$|\.ttf$|\.eot$|\.svg$/,
        loader: "file-loader",
        options: {
          name: "[name].[ext]?[hash]",
          outputPath: "fonts/",
          publicPath: "../"
        },
        include: [
          path.resolve(__dirname, "node_modules/semantic-ui-less")
        ]
      },
      // Handle semantic-ui fonts
      {
        test: /|\.woff$|\.woff2/,
        loader: "file-loader",
        options: {
          name: "[name].[ext]?[hash]",
          outputPath: "fonts/",
          publicPath: "../"
        },
        include: [
          path.resolve(__dirname, "node_modules/semantic-ui-less/themes/default/assets/fonts")
        ]
      },
      // Handle static files
      {
        test: /\.(pdf|docx)$/,
        loader: "file-loader",
        options: {
          name: "[name].[ext]?[hash]",
          outputPath: "files/",
          publicPath: "../"
        },
        include: path.resolve(__dirname, "static/files")
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
    extensions: ['.ts', '.tsx', '.js'],
    modules: [
      './',
      './node_modules/'
    ]
  },
};

module.exports = webpackConfig;
