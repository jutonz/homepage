const path = require("path");
const MiniCssExtractPlugin = require("mini-css-extract-plugin");
const HtmlWebpackPlugin = require("html-webpack-plugin");

const webpackConfig = {
  mode: "production",
  entry: "./../assets/js/index.js",
  output: {
    filename: "index.[hash].js",
    path: path.resolve(__dirname, "../priv/static"),
    publicPath: "/"
  },

  devtool: "source-map",

  module: {
    rules: [
      // Handle ts and tsx
      {
        test: /\.(js|jsx)$/,
        use: "babel-loader",
        include: path.resolve(__dirname, "js"),
        exclude: /node_modules/
      }, // Handle semantic-ui images
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
          name: "[name].[ext]?[hash]"
        },
        include: path.resolve(__dirname, "static/files")
      },
      // Handle less (semantic-ui + ours)
      {
        test: /\.less$/,
        use: [
          MiniCssExtractPlugin.loader,
          "css-loader",
          "less-loader"
        ],
        include: [
          path.resolve(__dirname, "css"),
          path.resolve(__dirname, "node_modules/semantic-ui-less")
        ]
      }
    ]
  },

  plugins: [
    // Handles bundled css output
    new MiniCssExtractPlugin({
      filename: "css/app.css",
      chunkFilename: "[id].css"
    }),
    new HtmlWebpackPlugin({
      template: "public/index.html"
      //favicon: 'public/favicon.ico'
    })
  ],

  resolve: {
    alias: {
      "../../theme.config$": path.join(__dirname, "semantic-theme/theme.config"),
      "@store$": path.resolve(__dirname, "js/store/store"),
      "@store": path.resolve(__dirname, "js/store/"),
      "@utils": path.resolve(__dirname, "js/utils/"),
      "@components": path.resolve(__dirname, "js/components/"),
      "@routes": path.resolve(__dirname, "js/routes/"),
      "@static": path.resolve(__dirname, "static/")
    },
    extensions: [".js", ".jsx"],
    modules: [
      "./",
      "./node_modules/"
    ]
  },
};

module.exports = webpackConfig;
