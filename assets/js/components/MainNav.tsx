import * as React from 'react';
import { Menu, MenuItemProps } from 'semantic-ui-react';
import { ErrorResponse } from './../declarations';

interface Props {
  activeItem: string;
  csrfToken: string;
}

interface State {
  activeItem: string;
  csrfToken: string;
}

class MainNav extends React.Component<Props, State> {
  constructor(props: Props) {
    super(props);
    this.state = props;
  }

  public render() {
    const { activeItem } = this.state;

    return (
      <Menu>
        <Menu.Menu position="left">
          <Menu.Item
            name="home"
            active={activeItem === "home"}
            onClick={this.clickedMenuItem}
          />
          <Menu.Item
            name="ijust"
            active={activeItem === "ijust"}
            onClick={this.clickedMenuItem}
          />
        </Menu.Menu>

        <Menu.Menu position="right">
          <Menu.Item
            name="logout"
            active={activeItem === "logout"}
            onClick={this.logout}
          />
        </Menu.Menu>
      </Menu>
    );
  }

  private clickedMenuItem = (_event: React.MouseEvent<HTMLAnchorElement>, item: MenuItemProps) => {
    this.setState({ activeItem: item.name })
  }

  private logout = () => {
    fetch("/logout", {
      method: "POST",
      credentials: "same-origin",
      headers: new Headers({ "x-csrf-token": this.props.csrfToken })
    }).then((response: Response) => {
      if (response.ok) {
        window.location.pathname = "/login";
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

export default MainNav;
