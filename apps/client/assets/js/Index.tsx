import "semantic-ui-less/semantic.less";
import "phoenix_html";
import "react-phoenix";
import * as React from "react";
import { createStore, applyMiddleware } from "redux";
import thunk from "redux-thunk";
import { Provider } from "react-redux";
import { App } from "./components/App";
import { ApolloClient } from "apollo-client";
import { HttpLink } from "apollo-link-http";
import { InMemoryCache, NormalizedCacheObject } from "apollo-cache-inmemory";
import gql from "graphql-tag";

import { appStore, addCsrfTokenAction, setSessionAction } from "./Store";
import "./../css/app.less";

// Utility functions
import BgGrid from "./BgGrid";
import isValidEmail from "./utils/isValidEmail";
import isValidPassword from "./utils/isValidPassword";

window.Utils = {
  BgGrid,
  isValidEmail,
  isValidPassword
};

declare global {
  interface Window {
    Utils: any;
    Index: any;
    grapqlClient: ApolloClient<NormalizedCacheObject>;
  }
}

window.grapqlClient = new ApolloClient({
  link: new HttpLink({
    uri: `${window.location.origin}/graphql`,
    credentials: "same-origin"
  }),
  cache: new InMemoryCache()
});

const store = createStore(appStore, applyMiddleware(thunk));

interface IndexProps {
  csrfToken: string;
}

interface IndexState {
  checkedSession: boolean;
}

export class Index extends React.Component<IndexProps, IndexState> {
  public constructor(props: IndexProps) {
    super(props);
    this.state = {
      checkedSession: false
    };
  }

  public componentWillMount() {
    store.dispatch(addCsrfTokenAction(this.props.csrfToken));
    this.checkSession();
  }

  public render() {
    if (!this.state.checkedSession) {
      return <div />;
    }

    return (
      <Provider store={store}>
        <App />
      </Provider>
    );
  }

  private checkSession(): void {
    window.grapqlClient
      .query({
        query: gql`
          {
            check_session
          }
        `
      })
      .then((response: any) => {
        const established = response.data.check_session || false;
        store.dispatch(setSessionAction(established));
        this.setState({ checkedSession: true });
      });
  }
}

window.Index = Index;
