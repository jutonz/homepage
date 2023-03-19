import { StyleSheet, css } from "aphrodite";
import * as React from "react";
import { gql } from "urql";
import { useParams } from "react-router-dom";

import { IjustContext } from "../components/ijust/IjustContext";
import { MainNav } from "../components/MainNav";
import { QueryLoader } from "./../utils/QueryLoader";
import type { IjustContextType } from "@types";

const style = StyleSheet.create({
  routeContainer: {
    margin: "30px auto",
    maxWidth: "700px",
  },
  errors: { color: "red" },
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
  getIjustContext: IjustContextType;
}

export const IjustContextRoute = () => {
  const { id } = useParams();

  return (
    <div>
      <MainNav activeItem={"ijust"} />
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

const renderContext = (context: any) => (
  <div>
    <div className={css(style.routeContainer)}>
      <IjustContext context={context} />
    </div>
  </div>
);
