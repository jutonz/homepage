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

  resolve: {
    extensions: [".mjs", ".js", ".jsx", ".ts", ".tsx"],
    modules: ["./", "./node_modules/"],
  },
};

module.exports = webpackConfig;
