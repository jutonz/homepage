#!/usr/bin/env node

const esbuild = require("esbuild");

const getEnv = () => {
  switch (process.env.MIX_ENV) {
    case "prod":
      return "prod";
    default:
      return "dev";
  }
};

const env = getEnv();
const isProd = env === "prod";

esbuild.build({
  entryPoints: [
    "./static-js/index.js",
  ],
  bundle: true,
  sourcemap: true,
  minify: isProd,
  watch: !isProd,
  outfile: "./../priv/static/static-js/index.js",
  target: [
    "chrome90",
    "firefox90",
    "safari14"
  ],
}).catch(() => process.exit(1))
