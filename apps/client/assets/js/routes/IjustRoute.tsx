import * as React from "react";
import { Redirect } from "react-router-dom";
import gql from "graphql-tag";

import { MainNav } from "@components/MainNav";
//import { IjustNav } from "@components/ijust/IjustNav";
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

//export const IjustRoute = () => (
//<div>
//<MainNav activeItem="ijust" />
//<IjustNav />
//</div>
//);

export const IjustRoute = () => (
  <div>
    <MainNav activeItem={"ijust"} />
    <QueryLoader
      query={QUERY}
      component={({ data }) => {
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
  </div>
);
