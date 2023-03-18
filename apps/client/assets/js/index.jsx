import { createBrowserHistory as createHistory } from "history";
import { Socket } from "phoenix";
import { LiveSocket } from "phoenix_live_view";
import React from "react";
import { createRoot } from "react-dom/client";
import { Provider } from "react-redux";
import { routerMiddleware } from "react-router-redux";
import { applyMiddleware, createStore } from "redux";
import createSagaMiddleware from "redux-saga";
import thunk from "redux-thunk";
import {
  createClient,
  gql,
  Provider as UrqlProvider,
  dedupExchange,
  fetchExchange,
} from "urql";
import { createLogger } from "redux-logger";
import { ThemeProvider } from "@mui/material/styles";
import { cacheExchange } from "@urql/exchange-graphcache";
import { SnackbarProvider } from "notistack";

import { Index } from "./components/Index";
import { rootSaga } from "./store/sagas/root";
import { appStore } from "./store/store";
import isValidEmail from "./utils/isValidEmail";
import isValidPassword from "./utils/isValidPassword";
import theme from "./utils/theme";

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

const reduxLogger = createLogger({}); // use default opts
const sagaMiddleware = createSagaMiddleware();
const middleware = applyMiddleware(
  thunk,
  routerMiddleware(createHistory()),
  sagaMiddleware,
  reduxLogger
);
const store = createStore(appStore, middleware);

sagaMiddleware.run(rootSaga);

export const urqlClient = createClient({
  url: graphqlEndpoint,
  fetchOptions: {
    credentials: "include",
    headers: {
      "x-beam-metadata": window.beamMetadata,
    },
  },
  exchanges: [
    dedupExchange,
    cacheExchange({
      keys: {
        CheckSessionResult: () => null,
      },
      updates: {
        Mutation: {
          createTeam(result, _args, cache, _info) {
            if (!result.createTeam) return;

            const query = gql`
              query {
                getTeams {
                  id
                  name
                }
              }
            `;

            cache.updateQuery({ query }, (data) => {
              data.getTeams.push(result.createTeam);
              return data;
            });
          },
          joinTeam(result, _args, cache, _info) {
            if (!result.joinTeam) return;

            const query = gql`
              query {
                getTeams {
                  id
                  name
                }
              }
            `;

            cache.updateQuery({ query }, (data) => {
              data.getTeams.push(result.joinTeam);
              return data;
            });
          },
          leaveTeam(result, _args, cache, _info) {
            if (!result.leaveTeam) return;

            const query = gql`
              query {
                getTeams {
                  id
                  name
                }
              }
            `;

            cache.updateQuery({ query }, (data) => {
              const getTeams = data.getTeams;
              data.getTeams = getTeams.filter(
                ({ id }) => id != result.leaveTeam.id
              );
              return data;
            });
          },
          deleteTeam(result, _args, cache, _info) {
            if (!result.deleteTeam) return;

            const query = gql`
              query {
                getTeams {
                  id
                  name
                }
              }
            `;

            cache.updateQuery({ query }, (data) => {
              const getTeams = data.getTeams;
              data.getTeams = getTeams.filter(
                ({ id }) => id != result.deleteTeam.id
              );
              return data;
            });
          },
          ijustAddOccurrenceToEvent(result, _args, cache, _info) {
            const query = gql`
              query ($contextId: ID!, $eventId: ID!) {
                getIjustContextEvent(contextId: $contextId, eventId: $eventId) {
                  id
                  ijustOccurrences {
                    id
                    insertedAt
                    updatedAt
                    isDeleted
                  }
                }
              }
            `;

            const event = result.ijustAddOccurrenceToEvent.ijustEvent;
            const variables = {
              eventId: event.id,
              contextId: event.ijustContextId,
            };

            cache.updateQuery({ query, variables }, (data) => {
              data.getIjustContextEvent.ijustOccurrences.push(
                result.ijustAddOccurrenceToEvent
              );
              return data;
            });
          },
          ijustDeleteOccurrence(result, args, cache, _info) {
            const query = gql`
              query ($contextId: ID!, $eventId: ID!) {
                getIjustContextEvent(contextId: $contextId, eventId: $eventId) {
                  id
                  ijustOccurrences {
                    id
                    insertedAt
                    updatedAt
                    isDeleted
                  }
                }
              }
            `;

            const eventId = result.ijustDeleteOccurrence.ijustEventId;
            const contextId = cache.resolve(
              { __typename: "IjustEvent", id: eventId },
              "ijustContextId"
            );
            const variables = { contextId, eventId };

            cache.updateQuery({ query, variables }, (data) => {
              let occurrences = data.getIjustContextEvent.ijustOccurrences;
              occurrences = occurrences.filter(
                (o) => o.id !== args.ijustOccurrenceId
              );
              data.getIjustContextEvent.ijustOccurrences = occurrences;
              return data;
            });
          },
          twitchChannelSubscribe(result, _args, cache, _info) {
            const query = gql`
              query {
                getTwitchChannels {
                  id
                }
              }
            `;

            cache.updateQuery({ query }, (data) => {
              data.getTwitchChannels.push(result.twitchChannelSubscribe);
              return data;
            });
          },
          twitchChannelUnsubscribe(_result, args, cache, _info) {
            const query = gql`
              query {
                getTwitchChannels {
                  name
                }
              }
            `;

            cache.updateQuery({ query }, (data) => {
              data.getTwitchChannels = data.getTwitchChannels.filter(
                (channel) => {
                  return channel.name !== args.name;
                }
              );
              return data;
            });
          },
          twitchRemoveIntegration(_result, _args, cache, _info) {
            const query = gql`
              query {
                getTwitchUser {
                  id
                }
              }
            `;

            cache.updateQuery({ query }, (data) => {
              data.getTwitchUser = null;
              return data;
            });
          },
        },
      },
    }),
    fetchExchange,
  ],
});

const root = createRoot(container);

root.render(
  <Provider store={store}>
    <UrqlProvider value={urqlClient}>
      <ThemeProvider theme={theme}>
        <SnackbarProvider>
          <Index />
        </SnackbarProvider>
      </ThemeProvider>
    </UrqlProvider>
  </Provider>
);
