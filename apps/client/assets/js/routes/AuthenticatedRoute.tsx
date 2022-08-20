import gql from "graphql-tag";
import React from "react";
import type { RouteProps } from "react-router-dom";
import { useNavigate, Route } from "react-router-dom";
import { useQuery } from "urql";

const CHECK_SESSION_QUERY = gql`
  {
    check_session
  }
`;

export function AuthenticatedRoute(props: RouteProps) {
  const navigate = useNavigate();
  const [{ data, fetching, error }] = useQuery({ query: CHECK_SESSION_QUERY });

  if (fetching) return null;
  if (error) return <div>An error occurred: {error.message}</div>;

  const isLoggedIn = data.check_session;
  if (!isLoggedIn) {
    navigate('/login');
    return null;
  }

  return <Route {...props} />;
}
