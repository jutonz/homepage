const HtmlWebpackPlugin = require("html-webpack-plugin");
const MiniCssExtractPlugin = require("mini-css-extract-plugin");
const path = require("path");

const webpackConfig = {
  mode: "production",
  entry: "./../assets/js/index.js",
  output: {
    filename: "index.[hash].js",
    path: path.resolve(__dirname, "../priv/static"),
    publicPath: "/",
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
        title: "jutonz.com",
        isHttps: true,
      },
    }),
  ],

  resolve: {
    extensions: [".mjs", ".js", ".jsx", ".ts", ".tsx"],
    modules: ["./", "./node_modules/"],
  },
};

module.exports = webpackConfig;
