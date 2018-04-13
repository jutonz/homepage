import "semantic-ui-less/semantic.less";

import "./../css/app.less";

import { ApolloClient } from "apollo-client";
import { ApolloProvider } from "react-apollo";
import { Provider } from "react-redux";
import { createStore, applyMiddleware } from "redux";
import { routerMiddleware } from "react-router-redux";
import React from "react";
import ReactDOM from "react-dom";
import createHistory from "history/createBrowserHistory";
import createSagaMiddleware from "redux-saga";
import thunk from "redux-thunk";

import { HttpLink } from "apollo-link-http";
import { InMemoryCache } from "apollo-cache-inmemory";
import { Index } from "@components/Index";
import { appStore } from "@store";
import { createLogger } from "redux-logger";
import { rootSaga } from "@store/sagas/root";
import isValidEmail from "@utils/isValidEmail";
import isValidPassword from "@utils/isValidPassword";

import BgGrid from "./BgGrid";

window.Utils = {
  BgGrid,
  isValidEmail,
  isValidPassword
};

let graphqlEndpoint;
if (window.location.port === "4000") {
  // dev
  graphqlEndpoint = "http://localhost:4000/graphql";
} else {
  graphqlEndpoint = `${window.location.origin}/graphql`;
}
window.grapqlClient = new ApolloClient({
  link: new HttpLink({
    uri: graphqlEndpoint,
    credentials: "include" // TODO use same-origin in dev
    //credentials: "same-origin"
  }),
  cache: new InMemoryCache()
});

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

ReactDOM.render(
  <Provider store={store}>
    <ApolloProvider client={window.grapqlClient}>
      <Index />
    </ApolloProvider>
  </Provider>,
  document.getElementById("wee")
);
