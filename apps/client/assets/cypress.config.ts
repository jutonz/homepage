import { defineConfig } from "cypress";

export default defineConfig({
  e2e: {
    setupNodeEvents(on, config) {
      // implement node event listeners here
    },
    baseUrl: "http://localhost:4002"
  },
  retries: {
    runMode: 2,
    openMode: 0,
  }
});
