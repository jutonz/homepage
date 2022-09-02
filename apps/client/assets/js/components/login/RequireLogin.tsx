import React, { useEffect } from "react";
import { useLocation, useNavigate } from "react-router-dom";
import { gql, useQuery } from "urql";

const CHECK_SESSION_QUERY = gql`
  {
    check_session
  }
`;

interface Props {
  children: React.ReactNode;
}

export function RequireLogin({ children }: Props) {
  const [{ data, fetching, error }] = useQuery({ query: CHECK_SESSION_QUERY });
  const navigate = useNavigate();
  const location = useLocation();

  useEffect(() => {
    const isLoggedIn = data.check_session;
    if (!isLoggedIn) {
      navigate("/login", { replace: true, state: { from: location } });
    }
  }, [data.check_session]);

  if (fetching) return null;
  if (error) return <div>An error occurred: {error.message}</div>;

  return children;
}
