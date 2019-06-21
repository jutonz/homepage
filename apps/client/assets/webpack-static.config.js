const path = require("path");

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
  }
};

module.exports = config;
