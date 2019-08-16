const path = require("path");

const getEnv = () => {
  switch (process.env.MIX_ENV) {
    case "prod": return "production";
    default: return "development"
  }
}

const env = getEnv();
const isProd = env === "production";
const isDev = env === "development";

const postcssPlugins = () => {
  let p = [
    require("tailwindcss"),
    require("autoprefixer"),
  ];

  if (isProd) {
    p.push(require("cssnano"));
  }

  return p;
};

const config = {
  mode: env,
  entry: "./static-js/index.js",
  output: {
    path: path.resolve(__dirname, "../priv/static"),
    filename: "js/app.js"
  },

  module: {
    rules: [
      {
        test: /\.scss/,
        include: [path.resolve(__dirname, "static-css")],
        use: [
          {
            loader: "style-loader",
            options: { sourceMap: true }
          },
          {
            loader: "css-loader",
            options: {
              importLoaders: 1
            }
          },
          {
            loader: "postcss-loader",
            options: {
              ident: "postcss-loader",
              plugins: postcssPlugins()
            }
          },
          {
            loader: "sass-loader"
          }
        ]
      }
    ]
  }
};

module.exports = config;
