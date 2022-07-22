import gql from "graphql-tag";
import React from "react";
import type { RouteProps } from "react-router-dom";
import { Redirect, Route } from "react-router-dom";
import { useQuery } from 'urql';

const CHECK_SESSION_QUERY = gql`{ check_session }`

export function AuthenticatedRoute(props: RouteProps) {
  const [{ data, fetching, error }] = useQuery({ query: CHECK_SESSION_QUERY });

  if (fetching) return null;
  if (error) return <div>An error occurred: {error.message}</div>;

  const isLoggedIn = data.check_session;
  if (!isLoggedIn) {
    return <Redirect to="/login" />;
  }

  return <Route {...props} />;
}
