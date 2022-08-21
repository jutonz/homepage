#!/usr/bin/env node

import { build } from "esbuild";
import { lessLoader } from "esbuild-plugin-less";
import { createStaticDir } from "./create-static-dir.mjs";

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

const lessOpts = {
  math: "always",
  paths: [
    "./semantic-theme/site/modules",
    "./node_modules/semantic-ui-less/themes",
  ],
};

const esbuildOpts = {
  entryPoints: ["./js/index.jsx", "./static-js/index.js", "./css/index.less"],
  plugins: [lessLoader(lessOpts)],
  loader: {
    ".eot": "dataurl",
    ".png": "dataurl",
    ".svg": "dataurl",
    ".ttf": "dataurl",
    ".woff": "dataurl",
    ".woff2": "dataurl",
  },
  bundle: true,
  sourcemap: true,
  minify: isProd,
  watch: !isProd,
  outdir: "./../priv/static/",
  target: ["chrome90", "firefox90", "safari14"],
  logLevel: "debug"
};

(async function compile() {
  try {
    await createStaticDir();
    await build(esbuildOpts);
  } catch (_e) {
    process.exit(1);
  }
})();
