import AppBar from "@mui/material/AppBar";
import Menu from "@mui/material/Menu";
import MenuItem from "@mui/material/MenuItem";
import Toolbar from "@mui/material/Toolbar";
import gql from "graphql-tag";
import React, { useState } from "react";
import type { NavLinkProps } from "react-router-dom";
import { NavLink, useNavigate } from "react-router-dom";
import { useQuery } from "urql";

const CHECK_SESSION_QUERY = gql`
  {
    check_session {
      authenticated
    }
  }
`;

export function MainNav() {
  const [{ data, fetching, error }] = useQuery({
    query: CHECK_SESSION_QUERY,
    requestPolicy: "cache-only",
  });

  if (fetching) return <div>Loading...</div>;
  if (error) return <div>An error occurred: {error.message}</div>;

  const isLoggedIn = data.check_session.authenticated;

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

  const activeClassName = ({ isActive }) => {
    const active = isActiveOverride ?? isActive;
    return active ? className + " text-purple-500" : className;
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
  const [_result, checkSession] = useQuery({
    query: CHECK_SESSION_QUERY,
    pause: true,
    requestPolicy: "network-only",
  });

  const logout = async () => {
    const response = await fetch("/api/logout", {
      method: "POST",
      credentials: "same-origin",
    });

    if (response.ok) {
      // bust cache by re-running check_session with network-only requestPolicy
      await checkSession();
      navigate("/");
      return;
    }

    const json: any = await response.json();
    if (json && json.messages) {
      console.error(json.messages);
    }
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
