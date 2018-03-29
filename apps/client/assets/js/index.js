import "semantic-ui-less/semantic.less";
import React from "react";
import { createStore, applyMiddleware } from "redux";
import thunk from "redux-thunk";
import createHistory from "history/createBrowserHistory";
import { routerMiddleware } from "react-router-redux";
import { ApolloClient } from "apollo-client";
import { HttpLink } from "apollo-link-http";
import { InMemoryCache, NormalizedCacheObject } from "apollo-cache-inmemory";
import { createLogger } from "redux-logger";
import createSagaMiddleware from "redux-saga";
import ReactDOM from "react-dom";
import { Provider } from "react-redux";

import { Index } from "@components/Index";
import { appStore, setSessionAction } from "@store";
import { rootSaga } from "@store/sagas/root";
import "./../css/app.less";

// Utility functions
import BgGrid from "./BgGrid";
import isValidEmail from "@utils/isValidEmail";
import isValidPassword from "@utils/isValidPassword";

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
    <Index />
  </Provider>,
  document.getElementById("wee")
);
