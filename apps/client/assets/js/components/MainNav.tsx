import React, { forwardRef } from "react";
import { Dropdown, Menu } from "semantic-ui-react";
import { Link, useNavigate } from "react-router-dom";
import gql from "graphql-tag";
import { useQuery } from "urql";
import type { LinkProps } from 'react-router-dom';

interface Props {
  activeItem: string;
}

const CHECK_SESSION_QUERY = gql`
  {
    check_session
  }
`;

export function MainNav({ activeItem }: Props) {
  const [{ data, fetching, error }] = useQuery({
    query: CHECK_SESSION_QUERY,
    requestPolicy: "network-only",
  });

  if (fetching) return <div>Loading...</div>;
  if (error) return <div>An error occurred: {error.message}</div>;

  const isLoggedIn = data.check_session;

  return (
    <Menu stackable>
      <Menu.Menu position="left">
        <Link to="/">
          <Menu.Item name={"home"} active={activeItem === "home"} />
        </Link>

        <Link to="/ijust">
          <Menu.Item name={"ijust"} active={activeItem === "ijust"} />
        </Link>

        <Link to="/twitch">
          <Menu.Item name={"twitch"} active={activeItem === "twitch"} />
        </Link>

        {renderLogsSubnav(activeItem)}
        {renderLegacySubnav(activeItem)}
      </Menu.Menu>

      <Menu.Menu position="right">
        <Link to="/settings">
          <Menu.Item name={"settings"} active={activeItem === "settings"} />
        </Link>
        {renderLoginOrLogout(activeItem, isLoggedIn)}
      </Menu.Menu>
    </Menu>
  );
}

function renderLogsSubnav(activeItem: String) {
  return (
    <Dropdown item text="Logs">
      <Dropdown.Menu>
        <StaticLink to="/water-logs">
          <Dropdown.Item name={"waterLogs"} active={activeItem === "waterLogs"}>
            Water Logs
          </Dropdown.Item>
        </StaticLink>

        <StaticLink to="/food-logs">
          <Dropdown.Item name={"foodLogs"} active={activeItem === "foodLogs"}>
            Food Logs
          </Dropdown.Item>
        </StaticLink>

        <StaticLink to="/soap">
          <Dropdown.Item name={"soap"} active={activeItem === "soap"}>
            Soap
          </Dropdown.Item>
        </StaticLink>

        <StaticLink to="/train-logs">
          <Dropdown.Item name={"trainLogs"} active={activeItem === "trainLogs"}>
            Trains
          </Dropdown.Item>
        </StaticLink>

        <StaticLink to="/storage">
          <Dropdown.Item name={"storage"} active={activeItem === "storage"}>
            Storage
          </Dropdown.Item>
        </StaticLink>
      </Dropdown.Menu>
    </Dropdown>
  );
}

function renderLegacySubnav(activeItem: String) {
  return (
    <Dropdown item text="Legacy">
      <Dropdown.Menu>
        <Link to="/coffeemaker">
          <Dropdown.Item active={activeItem === "coffeemaker"}>
            Coffeemaker
          </Dropdown.Item>
        </Link>
      </Dropdown.Menu>
    </Dropdown>
  );
}

function renderLoginOrLogout(activeItem: string, isLoggedIn: boolean) {
  const navigate = useNavigate();

  const logout = () => {
    fetch("/api/logout", {
      method: "POST",
      credentials: "same-origin",
    })
      .then((response) => {
        if (response.ok) {
          //this.props.destroySession();
          navigate("/login");
        } else {
          return response.json();
        }
      })
      .then((response) => {
        if (response && response.messages) {
          console.error(response.messages);
        }
      });
  };

  const login = () => navigate("/");

  if (isLoggedIn) {
    return (
      <Menu.Item
        name={"logout"}
        active={activeItem === "logout"}
        onClick={logout}
      />
    );
  } else {
    return <Menu.Item name={"login"} active={false} onClick={login} />;
  }
}

function StaticLink({ children, ...props }: LinkProps) {
  const onClick = (args) => {
    debugger;
  }

  return (
    <a onClick={onClick} {...props}>
      {children}
    </a>
  );
}
