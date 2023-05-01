import { Socket } from "phoenix";
import { LiveSocket } from "phoenix_live_view";
import React from "react";
import { createRoot } from "react-dom/client";
import { createClient, Provider as UrqlProvider, fetchExchange } from "urql";
import { ThemeProvider } from "@mui/material/styles";
import { SnackbarProvider } from "notistack";

import { Index } from "./components/Index";
import isValidEmail from "./utils/isValidEmail";
import isValidPassword from "./utils/isValidPassword";
import theme from "./utils/theme";
import { homepageCacheExchange } from "./utils/cacheExchange";
import { mapExchange, CombinedError } from "urql";

const container = document.querySelector("main[role=main]");
const isHttps = container.getAttribute("data-https");
if (isHttps == "true" && window.location.protocol === "http:") {
  const httpsUrl = window.location.href.replace("http:", "https:");
  window.location.replace(httpsUrl);
}

const csrfToken = document
  .querySelector("meta[name='csrf-token']")
  .getAttribute("content");
const socketOpts = {
  params: { _csrf_token: csrfToken },
};
const liveSocket = new LiveSocket("/live", Socket, socketOpts);
liveSocket.connect();

window.Utils = {
  isValidEmail,
  isValidPassword,
};

let graphqlEndpoint;
if (window.location.port === "4000") {
  // dev
  graphqlEndpoint = "http://localhost:4000/graphql";
} else {
  graphqlEndpoint = `${window.location.origin}/graphql`;
}

export const urqlClient = createClient({
  url: graphqlEndpoint,
  fetchOptions: {
    credentials: "include",
    headers: {
      "x-beam-metadata": window.beamMetadata,
    },
  },
  exchanges: [
    mapExchange({
      onResult(result) {
        const errors = Object.entries(result.data).flatMap(([_operation, response]) => {
          return response?.messages;
        }).filter((e) => !!e);
        console.log("result is", result);
        console.log("errors are", errors);
        if (errors.length > 0) {
          result.error = new CombinedError({ graphQLErrors: errors, response: result.data });
        }
      }
    }),
    homepageCacheExchange,
    fetchExchange
  ],
});

const root = createRoot(container);

root.render(
  <UrqlProvider value={urqlClient}>
    <ThemeProvider theme={theme}>
      <SnackbarProvider>
        <Index />
      </SnackbarProvider>
    </ThemeProvider>
  </UrqlProvider>
);
