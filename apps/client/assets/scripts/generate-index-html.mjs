import path from "path";
import fs from "fs";

const INDEX_TEMPLATE = path.resolve("./static/index.template.html");
const OUTPUT_PATH = path.resolve("./../priv/static/index.html");

export const generateIndexHtml = async (replacements) => {
  const contents = await fs.promises.readFile(INDEX_TEMPLATE, "utf8");

  const newContents = Object.keys(replacements).reduce((agg, key) => {
    const replacement = replacements[key];
    return agg.replace(key, replacement);
  }, contents);

  await fs.promises.writeFile(OUTPUT_PATH, newContents, "utf8");
};
