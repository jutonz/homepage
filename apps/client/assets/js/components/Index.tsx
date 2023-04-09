import React from "react";
import gql from "graphql-tag";
import { useQuery } from "urql";
import { App } from "./../components/App";

const GET_CURRENT_USER = gql`
  query GetCurrentUser {
    getCurrentUser {
      id
      email
    }
  }
`;

export function Index() {
  const [{ fetching, error }] = useQuery({ query: GET_CURRENT_USER });

  if (error) return <div>An error occurred: {error.message}</div>;
  if (fetching) return <div>Loading...</div>;

  return <App />;
}
