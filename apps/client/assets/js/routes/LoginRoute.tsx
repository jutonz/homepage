import React, { useState, useEffect } from "react";
import { useNavigate, useSearchParams } from "react-router-dom";
import { LoginForm } from "./../components/LoginForm";
import { BgGrid } from "./../BgGrid";
import { useQuery } from "urql";

import { graphql } from "../gql";
import { getAccessToken, getRefreshToken } from "js/utils/auth";

const GET_CURRENT_USER = graphql(`
  query GetCurrentUser {
    getCurrentUser {
      id
      email
    }
  }
`);

const handleSsoRedirect = (
  ssoRedirectUrl: string,
  accessToken: string,
  refreshToken: string,
) => {
  const url = new URL(ssoRedirectUrl);
  url.searchParams.set("access_token", accessToken);
  url.searchParams.set("refresh_token", refreshToken);
  // @ts-ignore
  window.location = url.toString();
};

export function LoginRoute() {
  const navigate = useNavigate();
  const [_bgGrid, setBgGrid] = useState<any>(null);
  const [searchParams, _setSearchParams] = useSearchParams();
  const [{ data, fetching, error }] = useQuery({
    query: GET_CURRENT_USER,
  });

  if (fetching) return null;
  if (error) return <div>An error occurred: {error.message}</div>;

  const isLoggedIn = !!data?.getCurrentUser;
  const ssoRedirect = searchParams.get("sso_redirect");

  useEffect(() => {
    const accessToken = getAccessToken();
    const refreshToken = getRefreshToken();
    console.log("isLoggedIn", isLoggedIn);
    console.log("accessToken", accessToken);
    console.log("refreshToken", refreshToken);
    console.log("ssoRedirect", ssoRedirect);

    if (isLoggedIn && accessToken && ssoRedirect && refreshToken) {
      handleSsoRedirect(ssoRedirect, accessToken, refreshToken);
    } else if (isLoggedIn) {
      navigate("/");
    } else if (searchParams.get("bg") !== "false") {
      const newGrid = new BgGrid();
      newGrid.init();
      newGrid.start();
      setBgGrid(newGrid);
    }
  }, []);

  const onLogin = ({ accessToken, refreshToken }) => {
    // TODO: Look for a `to` query param or something to redirect
    // Also maybe look into using location.state somehow?
    // TODO: Update urql cache?

    if (ssoRedirect) {
      handleSsoRedirect(ssoRedirect, accessToken, refreshToken);
    } else {
      // @ts-ignore
      window.location = "/";
    }
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
