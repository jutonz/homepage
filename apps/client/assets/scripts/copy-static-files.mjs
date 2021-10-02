import fs from "fs";
import path from "path";

const FROM_DIR = "./static/files";
const TO_DIR = "./../priv/static/files";

export const copyStaticFiles = async () => {
  await makeOutputDir();

  const files = await fs.promises.readdir(FROM_DIR);

  const promises = files.map((file) => {
    const fromPath = path.resolve(path.join(FROM_DIR, file));
    const toPath = path.resolve(path.join(TO_DIR, file));
    return fs.promises.copyFile(fromPath, toPath);
  });

  await Promise.all(promises);
};

const makeOutputDir = async () => {
  await fs.promises.mkdir(TO_DIR, { recursive: true });
};
