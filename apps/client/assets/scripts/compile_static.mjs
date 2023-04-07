#!/usr/bin/env node

import { build, context } from "esbuild";
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

const esbuildOpts = {
  entryPoints: ["./js/index.jsx", "./static-js/index.js", "./css/index.css"],
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
  outdir: "./../priv/static/",
  target: ["chrome90", "firefox90", "safari14"],
  logLevel: "debug",
};

(async function compile() {
  try {
    await createStaticDir();

    if (isProd) {
      await build(esbuildOpts);
    } else {
      const mainContext = await context(esbuildOpts);
      await mainContext.watch();
    }
  } catch (e) {
    console.error(e);
    process.exit(1);
  }
})();
