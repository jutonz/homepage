import * as React from "react";
import { Redirect } from "react-router-dom";
import gql from "graphql-tag";

import { MainNav } from "@components/MainNav";
import { QueryLoader } from "@utils/QueryLoader";

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
  <>
    <MainNav activeItem={"ijust"} />
    <QueryLoader
      query={QUERY}
      variables={{}}
      component={({ data }) => {
        console.log(data);
        const contextId = data.getIjustDefaultContext.id;
        return (
          <Redirect
            to={{
              pathname: `ijust/contexts/${contextId}`
            }}
          />
        );
      }}
    />
  </>
);
