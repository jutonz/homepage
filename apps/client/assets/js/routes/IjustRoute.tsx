import * as React from "react";
import gql from "graphql-tag";
import { Navigate } from "react-router-dom";

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

export const IjustRoute = () => {
  return (
    <div>
      <MainNav activeItem={"ijust"} />
      <QueryLoader
        query={QUERY}
        component={({ data }) => {
          const contextId = data.getIjustDefaultContext.id;
          return <Navigate to={`/ijust/contexts/${contextId}`} />;
        }}
      />
    </div>
  );
};
