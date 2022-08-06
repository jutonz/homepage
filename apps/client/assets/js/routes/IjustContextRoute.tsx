import { StyleSheet, css } from "aphrodite";
import * as React from "react";
import { gql } from "urql";

import { IjustContext } from "../components/ijust/IjustContext";
import { MainNav } from "../components/MainNav";
import { Context } from "./../store/reducers/ijust";
import { QueryLoader } from "./../utils/QueryLoader";

const style = StyleSheet.create({
  routeContainer: {
    margin: "30px auto",
    maxWidth: "700px",
  },
  errors: { color: "red" },
});

const QUERY = gql`
  query GetIjustContextQuery($id: ID!) {
    getIjustContext(id: $id) {
      id
      name
      userId
    }
  }
`;

export const IjustContextRoute = ({ match }) => (
  <div>
    <MainNav activeItem={"ijust"} />
    <QueryLoader
      query={QUERY}
      variables={{ id: match.params.id }}
      component={({ data }) => {
        const context = new Context(data.getIjustContext);
        return renderContext(context);
      }}
    />
  </div>
);

const renderContext = (context) => (
  <div>
    <div className={css(style.routeContainer)}>
      <IjustContext context={context} />
    </div>
  </div>
);
