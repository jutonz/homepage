#!/usr/bin/env node

import { build, context } from "esbuild";
import { writeFileSync } from "fs";
import { resolve } from "path";

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
  metafile: isProd,
  outdir: "./../priv/static/",
  target: ["chrome90", "firefox90", "safari14"],
  logLevel: "debug",
};

function writeMetafile(metaObject) {
  if (!metaObject) return;

  const metaFileLocaton = resolve("../../../esbuild-meta.json");
  writeFileSync(metaFileLocaton, JSON.stringify(metaObject));
  console.log("Wrote meta file to: ", metaFileLocaton);
}

(async function compile() {
  try {
    await createStaticDir();

    if (isProd) {
      const result = await build(esbuildOpts);
      writeMetafile(result.metafile);
    } else {
      const mainContext = await context(esbuildOpts);
      await mainContext.watch();
    }
  } catch (e) {
    console.error(e);
    process.exit(1);
  }
})();
