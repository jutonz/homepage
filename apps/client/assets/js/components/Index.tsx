import React from "react";
import gql from "graphql-tag";
import { useQuery } from 'urql'
import { App } from "./../components/App";

const CHECK_SESSION_QUERY = gql`{ check_session }`

export function Index() {
  const [{ fetching, error }] = useQuery({ query: CHECK_SESSION_QUERY });

  if (fetching) return <div>Loading...</div>;
  if (error) return <div>An error occurred: {error.message}</div>;

  return <App />;
}
