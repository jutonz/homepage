const path = require("path");
const MiniCssExtractPlugin = require("mini-css-extract-plugin");

const getMode = () => {
  switch (process.env.MIX_ENV) {
    case "prod": return "production";
    default: return "development"
  }
}

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
        use: ["style-loader", "css-loader"],
        include: [
          path.resolve(__dirname, "static-css")
        ]
      }
    ]
  },

  plugins: [
    new MiniCssExtractPlugin({
      filename: "css/app.css",
      chunkFilename: "[id].css"
    }),
  ]
};

module.exports = config;
