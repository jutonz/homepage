import * as React from "react";
import { Menu } from "semantic-ui-react";
import { ErrorResponse } from "./../declarations";
import { Link, withRouter, RouteComponentProps } from "react-router-dom";
import { Action, StoreState, setSessionAction } from "./../Store";
import { connect, Dispatch } from "react-redux";
import { compose } from "redux";

export enum ActiveItem {
  Home = "home",
  Settings = "settings",
  Logout = "logout",
  Coffeemaker = "coffeemaker",
  Resume = "resume",
  Login = "login",
  AccountView = "accounts/:id"
}

interface Props extends RouteComponentProps<{}> {
  activeItem: ActiveItem;
  csrfToken?: string;
  destroySession(): Action;
  sessionAuthenticated: boolean;
}

interface State {
  activeItem: ActiveItem;
}

class _MainNav extends React.Component<Props, State> {
  constructor(props: Props) {
    super(props);
    this.state = {
      activeItem: props.activeItem
    };
  }

  public render() {
    const { activeItem } = this.state;

    return (
      <Menu>
        <Menu.Menu position="left">
          <Link to="/">
            <Menu.Item
              name={ActiveItem.Home}
              active={activeItem === ActiveItem.Home}
            />
          </Link>

          <Link to="/coffeemaker">
            <Menu.Item
              name={ActiveItem.Coffeemaker}
              active={activeItem === ActiveItem.Coffeemaker}
            />
          </Link>

          <Link to="/resume">
            <Menu.Item
              name={ActiveItem.Resume}
              active={activeItem === ActiveItem.Resume}
            />
          </Link>
        </Menu.Menu>

        <Menu.Menu position="right">
          <Link to="/settings">
            <Menu.Item
              name={ActiveItem.Settings}
              active={activeItem === ActiveItem.Settings}
            />
          </Link>
          {this.renderLoginOrLogout()}
        </Menu.Menu>
      </Menu>
    );
  }

  private renderLoginOrLogout = () => {
    const { activeItem } = this.state;

    if (this.props.sessionAuthenticated) {
      return (
        <Menu.Item
          name={ActiveItem.Logout}
          active={activeItem === ActiveItem.Logout}
          onClick={this.logout}
        />
      );
    } else {
      return (
        <Menu.Item
          name={ActiveItem.Login}
          active={false}
          onClick={this.login}
        />
      );
    }
  };

  private logout = () => {
    fetch("/api/logout", {
      method: "POST",
      credentials: "same-origin",
      headers: new Headers({ "X-CSRF-Token": this.props.csrfToken })
    })
      .then((response: Response) => {
        if (response.ok) {
          this.props.destroySession();
          this.props.history.push("/login");
        } else {
          return response.json();
        }
      })
      .then((response: ErrorResponse) => {
        if (response && response.messages) {
          console.error(response.messages);
        }
      });
  };

  private login = () => {
    this.props.history.push("/");
  };
}

const mapStateToProps = (state: StoreState): Partial<Props> => ({
  csrfToken: state.csrfToken,
  sessionAuthenticated: state.sessionAuthenticated
});

const mapDispatchToProps = (dispatch: Dispatch<{}>): Partial<Props> => ({
  destroySession: () => dispatch(setSessionAction(false))
});

export const MainNav = compose(
  withRouter,
  connect(mapStateToProps, mapDispatchToProps)
)(_MainNav);
