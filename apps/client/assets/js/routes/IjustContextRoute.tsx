import { css, StyleSheet } from "aphrodite";
import * as React from "react";
import { useParams } from "react-router-dom";
import { gql } from "urql";

import type { IjustContext } from "@types";
import { IjustContextComponent } from "../components/ijust/IjustContextComponent";
import { MainNav } from "../components/MainNav";
import { QueryLoader } from "./../utils/QueryLoader";

const style = StyleSheet.create({
  routeContainer: {
    margin: "30px auto",
    maxWidth: "700px",
  },
});

const QUERY = gql`
  query GetIjustContext($id: ID!) {
    getIjustContext(id: $id) {
      id
      name
      userId
    }
  }
`;

interface GetIjustContextType {
  getIjustContext: IjustContext;
}

export const IjustContextRoute = () => {
  const { id } = useParams();

  return (
    <div>
      <MainNav />
      <QueryLoader<GetIjustContextType>
        query={QUERY}
        variables={{ id }}
        component={({ data }) => {
          return renderContext(data.getIjustContext);
        }}
      />
    </div>
  );
};

const renderContext = (context: IjustContext) => (
  <div>
    <div className={css(style.routeContainer)}>
      <IjustContextComponent context={context} />
    </div>
  </div>
);
