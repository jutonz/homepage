import { css, StyleSheet } from "aphrodite";
import * as React from "react";
import { useParams } from "react-router-dom";

import type { GetIjustContextQuery } from "@gql-types";

type IjustContextData = NonNullable<GetIjustContextQuery["getIjustContext"]>;
import { IjustContextComponent } from "../components/ijust/IjustContextComponent";
import { MainNav } from "../components/MainNav";
import { QueryLoader } from "./../utils/QueryLoader";
import { graphql } from "../gql";

const style = StyleSheet.create({
  routeContainer: {
    margin: "30px auto",
    maxWidth: "700px",
  },
});

const QUERY = graphql(`
  query GetIjustContext($id: ID!) {
    getIjustContext(id: $id) {
      id
      name
      userId
    }
  }
`);

export const IjustContextRoute = () => {
  const { id } = useParams();

  return (
    <div>
      <MainNav />
      <QueryLoader<GetIjustContextQuery>
        query={QUERY}
        variables={{ id }}
        component={({ data }) => {
          if (!data.getIjustContext) return null;
          return renderContext(data.getIjustContext);
        }}
      />
    </div>
  );
};

const renderContext = (context: IjustContextData) => (
  <div>
    <div className={css(style.routeContainer)}>
      <IjustContextComponent context={context} />
    </div>
  </div>
);
