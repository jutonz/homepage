import gql from "graphql-tag";
import React from "react";
import type { RouteProps } from "react-router-dom";
import { Redirect, Route, useLocation } from "react-router-dom";
import { useQuery } from 'urql';

const CHECK_SESSION_QUERY = gql`{ check_session }`

export function AuthenticatedRoute(props: RouteProps) {
  const location = useLocation();
  const [{ data, fetching, error }] = useQuery({ query: CHECK_SESSION_QUERY });

  if (fetching) return null;
  if (error) return <div>An error occurred: {error.message}</div>;

  const isLoggedIn = data.check_session;
  if (!isLoggedIn) {
    return <Redirect to={{ pathname: "/login", state: location }} />;
  }

  return <Route {...props} />;
}
