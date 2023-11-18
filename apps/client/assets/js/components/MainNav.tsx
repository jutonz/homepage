import AppBar from "@mui/material/AppBar";
import Menu from "@mui/material/Menu";
import MenuItem from "@mui/material/MenuItem";
import Toolbar from "@mui/material/Toolbar";
import React, { useState } from "react";
import type { NavLinkProps } from "react-router-dom";
import { NavLink, useNavigate } from "react-router-dom";
import { useClient, useQuery } from "urql";

import { graphql } from "../gql";
import { clearTokens } from "js/utils/auth";

const GET_CURRENT_USER = graphql(`
  query GetCurrentUser {
    getCurrentUser {
      id
      email
    }
  }
`);

export function MainNav() {
  const [{ data, fetching, error }] = useQuery({
    query: GET_CURRENT_USER,
    requestPolicy: "cache-only",
  });

  if (fetching) return <div>Loading...</div>;
  if (error) return <div>An error occurred: {error.message}</div>;

  const isLoggedIn = !!data?.getCurrentUser;

  return (
    <AppBar position="static" className="mb-5">
      <Toolbar disableGutters className="flex justify-between px-5">
        <div>
          <StyledNavLink to="/" className="p-5">
            Home
          </StyledNavLink>

          <StyledNavLink to="/ijust" className="p-5">
            Ijust
          </StyledNavLink>

          <StyledNavLink to="/twitch" className="p-5">
            Twitch
          </StyledNavLink>
          <LogsSubnav />
        </div>
        <div>
          <StyledNavLink to="/settings" className="p-5">
            Settings
          </StyledNavLink>
          {renderLoginOrLogout(isLoggedIn)}
        </div>
      </Toolbar>
    </AppBar>
  );
}

type InitialNavLinkProps = NavLinkProps &
  React.RefAttributes<HTMLAnchorElement>;

interface StyledNavLinkProps extends Omit<InitialNavLinkProps, "className"> {
  children: React.ReactNode;
  className?: string;
  isActive?: boolean;
}

function StyledNavLink({
  children,
  className,
  isActive: isActiveOverride,
  ...props
}: StyledNavLinkProps) {
  className = className ?? "";

  const activeClassName = ({ isActive }): string => {
    const active = isActiveOverride ?? isActive;
    if (active) {
      return className + " text-purple-500";
    } else {
      return className as string;
    }
  };

  return (
    <NavLink {...props} className={activeClassName}>
      {children}
    </NavLink>
  );
}

function LogsSubnav() {
  const [menuAnchor, setMenuAnchor] = useState<undefined | HTMLElement>();
  const menuOpen = Boolean(menuAnchor);
  return (
    <>
      <StyledNavLink
        id="logs-menu"
        to="#"
        isActive={false}
        onClick={(ev) => setMenuAnchor(ev.currentTarget)}
        className="p-4"
      >
        Logs
      </StyledNavLink>
      <Menu
        anchorEl={menuAnchor}
        open={menuOpen}
        onClose={() => setMenuAnchor(undefined)}
        MenuListProps={{
          "aria-labelledby": "logs-menu",
        }}
      >
        <MenuItem>
          <StaticLink pathname="/water-logs">Water Logs</StaticLink>
        </MenuItem>
        <MenuItem>
          <StaticLink pathname="/food-logs">Food Logs</StaticLink>
        </MenuItem>
        <MenuItem>
          <StaticLink pathname="/soap">Soap</StaticLink>
        </MenuItem>
        <MenuItem>
          <StaticLink pathname="/train-logs">Trains</StaticLink>
        </MenuItem>
        <MenuItem>
          <StaticLink pathname="/storage">Storage</StaticLink>
        </MenuItem>
      </Menu>
    </>
  );
}

function renderLoginOrLogout(isLoggedIn: boolean) {
  const navigate = useNavigate();
  const client = useClient();

  const logout = async () => {
    clearTokens();

    await fetch("/api/logout", {
      method: "POST",
      credentials: "same-origin",
    });

    // bust cache by re-running check_session with network-only requestPolicy
    await client
      .query(GET_CURRENT_USER, {}, { requestPolicy: "network-only" })
      .toPromise();

    navigate("/login");
  };

  const login = () => navigate("/");

  if (isLoggedIn) {
    return (
      <StyledNavLink to="#" onClick={logout} isActive={false}>
        Logout
      </StyledNavLink>
    );
  } else {
    return (
      <StyledNavLink to="#" onClick={login} isActive={false}>
        Login
      </StyledNavLink>
    );
  }
}

type StaticLinkProps = {
  children: React.ReactNode;
  pathname: string;
};

function StaticLink({ children, pathname }: StaticLinkProps) {
  return <a href={pathname}>{children}</a>;
}
