import { StyleSheet, css } from "aphrodite";
import * as React from "react";
import gql from "graphql-tag";
import { Link } from "react-router-dom";

import { MainNav } from "./../components/MainNav";
import { IjustBreadcrumbs } from "./../components/ijust/IjustBreadcrumbs";
import { QueryLoader } from "./../utils/QueryLoader";

const style = StyleSheet.create({
  routeContainer: {
    margin: "30px auto",
    maxWidth: "700px",
  },
  errors: { color: "red" },
  context: {
    marginTop: "10px",
    marginBottom: "10px",
  },
});

const QUERY = gql`
  query GetIjustContextsQuery {
    getIjustContexts {
      id
      name
    }
  }
`;

export const IjustContextsRoute = () => {
  return (
    <div>
      <MainNav />
      <div className={css(style.routeContainer)}>
        <IjustBreadcrumbs viewing={"contexts"} />
        <p>
          Contexts are groups of events. You can create priviate contexts for
          your personal items and shared contexts for things you want to track
          with your friends.
        </p>
        <QueryLoader
          query={QUERY}
          component={({ data }) => {
            return renderContexts(data.getIjustContexts);
          }}
        />
      </div>
    </div>
  );
};

const renderContexts = (contexts) => (
  <div>
    {contexts.map((context) => (
      <div key={context.id} className={css(style.context)}>
        <Link to={`/ijust/contexts/${context.id}`}>{context.name}</Link>
      </div>
    ))}
  </div>
);
