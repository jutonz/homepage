import * as React from "react";
import gql from "graphql-tag";
import { Navigate } from "react-router-dom";

import { MainNav } from "./../components/MainNav";
import { QueryLoader } from "./../utils/QueryLoader";
import type { IjustContext } from "@types";

const QUERY = gql`
  query GetIjustDefaultContextQuery {
    getIjustDefaultContext {
      id
      name
      userId
    }
  }
`;

interface GetContextType {
  getIjustDefaultContext: IjustContext;
}

export const IjustRoute = () => {
  return (
    <div>
      <MainNav activeItem={"ijust"} />
      <QueryLoader<GetContextType>
        query={QUERY}
        component={({ data }) => {
          const contextId = data.getIjustDefaultContext.id;
          return <Navigate to={`/ijust/contexts/${contextId}`} />;
        }}
      />
    </div>
  );
};
