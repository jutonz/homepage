import type { CodegenConfig } from "@graphql-codegen/cli";

const config: CodegenConfig = {
  schema: "http://0.0.0.0:4000/graphql",
  documents: ["js/**/*.tsx"],
  ignoreNoDocuments: true, // for better experience with the watcher
  generates: {
    "./js/gql/": {
      preset: "client",
      plugins: [],
    },
  },
};

export default config;
