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
  outdir: "./../priv/static/",
  target: [
    "chrome58",
    "firefox57",
    "safari11",
    "edge16"
  ],
}).catch(() => process.exit(1))
