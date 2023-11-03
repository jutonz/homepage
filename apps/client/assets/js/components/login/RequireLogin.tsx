import React, { useEffect } from "react";
import { useLocation, useNavigate } from "react-router-dom";
import { useQuery } from "urql";
import { graphql } from "../../gql";

const GET_CURRENT_USER = graphql(`
  query GetCurrentUser {
    getCurrentUser {
      id
      email
    }
  }
`);

interface Props {
  children: React.ReactNode;
}

export function RequireLogin({ children }: Props) {
  const [{ data, fetching, error }] = useQuery({
    query: GET_CURRENT_USER,
  });

  const navigate = useNavigate();
  const location = useLocation();

  useEffect(() => {
    const isLoggedIn = !!data?.getCurrentUser;
    if (!isLoggedIn) {
      navigate("/login", { replace: true, state: { from: location } });
    }
  }, [data?.getCurrentUser]);

  if (fetching) return null;
  if (error) return <div>An error occurred: {error.message}</div>;

  return children;
}
