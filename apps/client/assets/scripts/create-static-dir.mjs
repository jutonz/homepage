import path from "path";
import fs from "fs";

const PATH = path.resolve("./../priv/static");

export const createStaticDir = async () => {
  await fs.promises.mkdir(PATH, { recursive: true });
};
