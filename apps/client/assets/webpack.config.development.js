const HtmlWebpackPlugin = require("html-webpack-plugin");
const MiniCssExtractPlugin = require("mini-css-extract-plugin");
const path = require("path");

const port = process.env.PORT || 4001;

const webpackConfig = {
  mode: "development",
  entry: "./../assets/js/index.js",
  output: {
    filename: "js/index.js",
    path: path.resolve(__dirname, "../priv/static"),
  },

  devtool: "inline-source-map",
  devServer: {
    host: "localhost",
    port: port,
    historyApiFallback: true,
    open: false,
    proxy: {
      "/": {
        target: "http://localhost:4000",
        secure: false,
        changeOrigin: true,
      },
      "/twitchsocket": {
        target: "ws://localhost:4000",
        ws: true,
      },
    },
  },

  module: {
    rules: [
      // Handle ts and tsx
      {
        test: /\.(ts|tsx|js|jsx)$/,
        use: ["babel-loader", "ts-loader"],
        include: path.resolve(__dirname, "js"),
        exclude: /node_modules/,
      },
    ],
  },

  plugins: [
    // Handles bundled css output
    new MiniCssExtractPlugin({
      filename: "css/app.css",
      chunkFilename: "[id].css",
    }),
    new HtmlWebpackPlugin({
      template: "static/index.ejs",
      templateParameters: {
        title: "[dev] jutonz.com",
        isHttps: false,
      },
    }),
  ],

  resolve: {
    extensions: [".mjs", ".js", ".jsx", ".ts", ".tsx"],
    modules: ["./", "./node_modules/"],
  },
};

module.exports = webpackConfig;
