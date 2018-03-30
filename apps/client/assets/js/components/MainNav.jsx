import React from "react";
import { Menu } from "semantic-ui-react";
import { Link, withRouter } from "react-router-dom";
import { connect, Dispatch } from "react-redux";
import { compose } from "redux";
import { setSessionAction } from "@store";
class _MainNav extends React.Component {
  constructor(props) {
    super(props);
    this.state = { activeItem: props.activeItem };
  }

  render() {
    const { activeItem } = this.state;

    return (
      <Menu>
        <Menu.Menu position="left">
          <Link to="/">
            <Menu.Item name={"home"} active={activeItem === "home"} />
          </Link>

          <Link to="/coffeemaker">
            <Menu.Item
              name={"coffeemaker"}
              active={activeItem === "coffeemaker"}
            />
          </Link>

          <Link to="/resume">
            <Menu.Item name={"resume"} active={activeItem === "resume"} />
          </Link>
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
      credentials: "same-origin"
    })
      .then(response => {
        if (response.ok) {
          this.props.destroySession();
          this.props.history.push("/login");
        } else {
          return response.json();
        }
      })
      .then(response => {
        if (response && response.messages) {
          console.error(response.messages);
        }
      });
  };

  login = () => {
    this.props.history.push("/");
  };
}

const mapStateToProps = state => ({
  csrfToken: state.csrfToken,
  sessionAuthenticated: state.session.established
});

const mapDispatchToProps = dispatch => ({
  destroySession: () =>
    dispatch({ type: "SET_SESSION_ESTABLISHED", established: false })
});

export const MainNav = compose(
  withRouter,
  connect(mapStateToProps, mapDispatchToProps)
)(_MainNav);
