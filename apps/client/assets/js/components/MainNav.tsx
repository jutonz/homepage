import React, { forwardRef } from "react";
import { Dropdown, Menu } from "semantic-ui-react";
import { Link, useHistory } from "react-router-dom";
import gql from "graphql-tag";
import { useQuery } from "urql";

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
        <Link to="/water-logs" component={StaticLink}>
          <Dropdown.Item name={"waterLogs"} active={activeItem === "waterLogs"}>
            Water Logs
          </Dropdown.Item>
        </Link>

        <Link to="/food-logs" component={StaticLink}>
          <Dropdown.Item name={"foodLogs"} active={activeItem === "foodLogs"}>
            Food Logs
          </Dropdown.Item>
        </Link>

        <Link to="/soap" component={StaticLink}>
          <Dropdown.Item name={"soap"} active={activeItem === "soap"}>
            Soap
          </Dropdown.Item>
        </Link>

        <Link to="/train-logs" component={StaticLink}>
          <Dropdown.Item name={"trainLogs"} active={activeItem === "trainLogs"}>
            Trains
          </Dropdown.Item>
        </Link>

        <Link to="/storage" component={StaticLink}>
          <Dropdown.Item name={"storage"} active={activeItem === "storage"}>
            Storage
          </Dropdown.Item>
        </Link>
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

const StaticLink = forwardRef((props: any, ref) => {
  const href = props.href.replace("#/", "");

  return (
    <a ref={ref as React.RefObject<HTMLAnchorElement>} href={href}>
      {props.children}
    </a>
  );
});
