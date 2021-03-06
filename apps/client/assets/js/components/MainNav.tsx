import * as React from "react";
import { forwardRef } from "react";
import { Dropdown, Menu } from "semantic-ui-react";
import { Link, RouteComponentProps } from "react-router-dom";
import { connect } from "react-redux";
import { compose } from "redux";

interface _Props {
  activeItem: String;
  destroySession?: () => void;
  sessionAuthenticated?: Boolean;
  csrfToken?: String;
}

type Props = _Props & Partial<RouteComponentProps<any>>;

interface State {
  activeItem: String;
}

class _MainNav extends React.Component<Props, State> {
  constructor(props: Props) {
    super(props);
    this.state = { activeItem: props.activeItem };
  }

  render() {
    const { activeItem } = this.state;

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
          {this.renderLoginOrLogout()}
        </Menu.Menu>
      </Menu>
    );
  }

  renderLoginOrLogout = () => {
    const { activeItem } = this.state;

    if (this.props.sessionAuthenticated) {
      return (
        <Menu.Item
          name={"logout"}
          active={activeItem === "logout"}
          onClick={this.logout}
        />
      );
    } else {
      return <Menu.Item name={"login"} active={false} onClick={this.login} />;
    }
  };

  logout = () => {
    fetch("/api/logout", {
      method: "POST",
      credentials: "same-origin",
    })
      .then((response) => {
        if (response.ok) {
          this.props.destroySession();
          this.props.history.push("/login");
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

  login = () => {
    this.props.history.push("/");
  };
}

const renderLogsSubnav = (activeItem: String) => (
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
    </Dropdown.Menu>
  </Dropdown>
);

const renderLegacySubnav = (activeItem: String) => (
  <Dropdown item text="Legacy">
    <Dropdown.Menu>
      <Link to="/coffeemaker">
        <Dropdown.Item active={activeItem === "coffeemaker"}>
          Coffeemaker
        </Dropdown.Item>
      </Link>

      <Link to="/resume">
        <Dropdown.Item active={activeItem === "resume"}>Resume</Dropdown.Item>
      </Link>
    </Dropdown.Menu>
  </Dropdown>
);

const StaticLink = forwardRef((props: any, ref) => {
  const href = props.href.replace("#/", "");

  return (
    <a ref={ref as React.RefObject<HTMLAnchorElement>} href={href}>
      {props.children}
    </a>
  );
});

const mapStateToProps = (state) => ({
  csrfToken: state.csrfToken,
  sessionAuthenticated: state.session.established,
});

const mapDispatchToProps = (dispatch) => ({
  destroySession: () =>
    dispatch({ type: "SET_SESSION_ESTABLISHED", established: false }),
});

export const MainNav = compose(connect(mapStateToProps, mapDispatchToProps))(
  _MainNav
);
