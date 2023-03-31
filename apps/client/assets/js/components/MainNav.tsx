import gql from "graphql-tag";
import React from "react";
import { Link, useNavigate } from "react-router-dom";
import { Dropdown, Menu } from "semantic-ui-react";
import { useQuery } from "urql";

interface Props {
  activeItem: string;
}

const CHECK_SESSION_QUERY = gql`
  {
    check_session {
      authenticated
    }
  }
`;

export function MainNav({ activeItem }: Props) {
  const [{ data, fetching, error }] = useQuery({
    query: CHECK_SESSION_QUERY,
    requestPolicy: "cache-only",
  });

  if (fetching) return <div>Loading...</div>;
  if (error) return <div>An error occurred: {error.message}</div>;

  const isLoggedIn = data.check_session.authenticated;

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
        <StaticLink pathname="/water-logs">
          <Dropdown.Item name={"waterLogs"} active={activeItem === "waterLogs"}>
            Water Logs
          </Dropdown.Item>
        </StaticLink>

        <StaticLink pathname="/food-logs">
          <Dropdown.Item name={"foodLogs"} active={activeItem === "foodLogs"}>
            Food Logs
          </Dropdown.Item>
        </StaticLink>

        <StaticLink pathname="/soap">
          <Dropdown.Item name={"soap"} active={activeItem === "soap"}>
            Soap
          </Dropdown.Item>
        </StaticLink>

        <StaticLink pathname="/train-logs">
          <Dropdown.Item name={"trainLogs"} active={activeItem === "trainLogs"}>
            Trains
          </Dropdown.Item>
        </StaticLink>

        <StaticLink pathname="/storage">
          <Dropdown.Item name={"storage"} active={activeItem === "storage"}>
            Storage
          </Dropdown.Item>
        </StaticLink>
      </Dropdown.Menu>
    </Dropdown>
  );
}

function renderLoginOrLogout(activeItem: string, isLoggedIn: boolean) {
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
      <Menu.Item
        href="#"
        name={"logout"}
        active={activeItem === "logout"}
        onClick={logout}
      />
    );
  } else {
    return <Menu.Item name={"login"} active={false} onClick={login} />;
  }
}

type StaticLinkProps = {
  children: React.ReactNode;
  pathname: string;
};

function StaticLink({ children, pathname }: StaticLinkProps) {
  return <a href={pathname}>{children}</a>;
}
