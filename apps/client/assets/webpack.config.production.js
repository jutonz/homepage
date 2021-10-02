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
      // Handle static files
      {
        test: /\.(pdf|docx)$/,
        loader: "file-loader",
        options: {
          name: "[name].[ext]?[hash]",
        },
        include: path.resolve(__dirname, "static/files"),
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
    alias: {
      "@store$": path.resolve(__dirname, "js/store/store"),
      "@store": path.resolve(__dirname, "js/store/"),
      "@utils": path.resolve(__dirname, "js/utils/"),
      "@components": path.resolve(__dirname, "js/components/"),
      "@routes": path.resolve(__dirname, "js/routes/"),
      "@static": path.resolve(__dirname, "static/"),
      "@app": path.resolve(__dirname, "js/"),
    },
    extensions: [".mjs", ".js", ".jsx", ".ts", ".tsx"],
    modules: ["./", "./node_modules/"],
  },
};

module.exports = webpackConfig;
