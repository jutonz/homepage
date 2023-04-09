import React from "react";
import { useQuery } from "urql";

import { App } from "./../components/App";
import { graphql } from "./../gql";

const GET_CURRENT_USER = graphql(`
  query currentUserDocument {
    getCurrentUser {
      id
      email
    }
  }
`);

export function Index() {
  const [{ fetching, error }] = useQuery({ query: GET_CURRENT_USER });

  if (error) return <div>An error occurred: {error.message}</div>;
  if (fetching) return <div>Loading...</div>;

  return <App />;
}
