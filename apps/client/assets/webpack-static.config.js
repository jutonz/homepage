const path = require("path");
//const MiniCssExtractPlugin = require("mini-css-extract-plugin");

const getMode = () => {
  switch (process.env.MIX_ENV) {
    case "prod": return "production";
    default: return "development"
  }
}

const mode = getMode();
const isProd = mode === "production";
const isDev = mode === "development";

const config = {
  mode: getMode(),
  entry: "./static-js/index.js",
  output: {
    path: path.resolve(__dirname, "../priv/static"),
    filename: "js/app.js"
  },

  module: {
    rules: [
      {
        test: /\.css$/,
        include: [path.resolve(__dirname, "static-css")],
        use: [
          {
            loader: "style-loader",
            options: { sourceMap: true }
          },
          //isDev ? "style-loader" : MiniCssExtractPlugin.loader,
          {
            loader: "css-loader",
            options: {
              importLoaders: 1
            }
          },
          {
            loader: "postcss-loader",
            options: {
              ident: "postcss-loader"
            }
          }
        ]
      }
    ]
  },

  //plugins: [
    //new MiniCssExtractPlugin({
      //filename: isDev ? '[name].css' : '[name].[hash].css'
    //})
  //]
};

if (isProd) {
  const TerserJSPlugin = require('terser-webpack-plugin');
  const OptimizeCSSAssetsPlugin = require('optimize-css-assets-webpack-plugin');

  config.optimization = {
    minimizer: [
      new TerserJSPlugin({}),
      new OptimizeCSSAssetsPlugin({})
    ]
  }
}

module.exports = config;
