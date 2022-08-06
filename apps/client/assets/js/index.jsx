import { ApolloClient } from "apollo-client";
import { createBrowserHistory as createHistory } from "history";
import { Socket } from "phoenix";
import { LiveSocket } from "phoenix_live_view";
import React from "react";
import { ApolloProvider } from "react-apollo";
import ReactDOM from "react-dom";
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
import { InMemoryCache } from "apollo-cache-inmemory";
import { HttpLink } from "apollo-link-http";
import { createLogger } from "redux-logger";
import { cacheExchange } from "@urql/exchange-graphcache";

import { Index } from "./components/Index";
import { rootSaga } from "./store/sagas/root";
import { appStore } from "./store/store";
import isValidEmail from "./utils/isValidEmail";
import isValidPassword from "./utils/isValidPassword";

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
const graphqlClient = new ApolloClient({
  link: new HttpLink({
    uri: graphqlEndpoint,
    credentials: "include", // TODO use same-origin in dev
    //credentials: "same-origin"
  }),
  cache: new InMemoryCache(),
});
window.grapqlClient = graphqlClient;
export const GraphqlClient = graphqlClient;

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

const urqlClient = createClient({
  url: graphqlEndpoint,
  fetchOptions: {
    credentials: "include",
  },
  exchanges: [
    dedupExchange,
    cacheExchange({
      updates: {
        Mutation: {
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
        },
      },
    }),
    fetchExchange,
  ],
});

ReactDOM.render(
  <Provider store={store}>
    <ApolloProvider client={window.grapqlClient}>
      <UrqlProvider value={urqlClient}>
        <Index />
      </UrqlProvider>
    </ApolloProvider>
  </Provider>,
  container
);
