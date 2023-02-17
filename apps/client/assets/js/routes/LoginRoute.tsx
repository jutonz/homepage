import React, { useState, useEffect } from "react";
import { useNavigate } from "react-router-dom";
import { LoginForm } from "./../components/LoginForm";
import { BgGrid } from "./../BgGrid";
import gql from "graphql-tag";
import { useQuery } from "urql";

const CHECK_SESSION_QUERY = gql`
  {
    check_session {
      authenticated
    }
  }
`;

export function LoginRoute() {
  const navigate = useNavigate();
  const [_bgGrid, setBgGrid] = useState(null);
  const [{ data, fetching, error }] = useQuery({ query: CHECK_SESSION_QUERY });

  if (fetching) return null;
  if (error) return <div>An error occurred: {error.message}</div>;

  const isLoggedIn = data.check_session.authenticated;

  useEffect(() => {
    if (isLoggedIn) {
      navigate("/");
    } else {
      const newGrid = new BgGrid();
      newGrid.init();
      newGrid.start();
      setBgGrid(newGrid);
    }
  }, []);

  const onLogin = () => {
    // TODO: Look for a `to` query param or something to redirect
    // Also maybe look into using location.state somehow?
    // TODO: Update urql cache?
    // @ts-ignore
    window.location = "/";
  };

  return (
    <div>
      <canvas id="gl-canvas">
        Your browser doesn't appear to support the
        <code>&lt;canvas&gt;</code> element.
      </canvas>

      {/* @ts-ignore */}
      <LoginForm onLogin={onLogin} />
    </div>
  );
}
