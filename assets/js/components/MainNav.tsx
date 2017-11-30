import * as React from 'react';
import { Menu } from 'semantic-ui-react';
import { ErrorResponse } from './../declarations';
import { Link, withRouter, RouteComponentProps } from 'react-router-dom';

export enum ActiveItem {
  Home = 'home',
  Settings = 'settings',
  Logout = 'logout'
};

type Props = RouteComponentProps<{}> & {
  activeItem: ActiveItem;
}

type State = {
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
        </Menu.Menu>

        <Menu.Menu position="right">
          <Link to="/settings">
            <Menu.Item
              name={ActiveItem.Settings}
              active={activeItem === ActiveItem.Settings}
            />
          </Link>
          <Menu.Item
            name={ActiveItem.Logout}
            active={activeItem === ActiveItem.Logout}
            onClick={this.logout}
          />
        </Menu.Menu>
      </Menu>
    );
  }

  private logout = () => {
    fetch("/logout", {
      method: "POST",
      credentials: "same-origin",
    }).then((response: Response) => {
      if (response.ok) {
        this.props.history.push("/login");
      } else {
        return response.json();
      }
    }).then((response: ErrorResponse) => {
      if (response && response.messages) {
        console.error(response.messages);
      }
    });
  }
}

export const MainNav = withRouter<Props>(_MainNav);
