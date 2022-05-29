import * as React from "react";
import { Route, Redirect } from "react-router-dom";
import gql from "graphql-tag";

import { MainNav } from "./../components/MainNav";
import { QueryLoader } from "./../utils/QueryLoader";

const QUERY = gql`
  query GetIjustDefaultContextQuery {
    getIjustDefaultContext {
      id
      name
      userId
    }
  }
`;

export const IjustRoute = () => (
  <div>
    <MainNav activeItem={"ijust"} />
    <QueryLoader
      query={QUERY}
      component={({ data }) => {
        const contextId = data.getIjustDefaultContext.id;
        return (
          <Route
            render={() => (
              <Redirect to={{ pathname: `ijust/contexts/${contextId}` }} />
            )}
          />
        );
      }}
    />
  </div>
);
