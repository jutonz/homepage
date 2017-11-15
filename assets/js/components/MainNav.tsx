import * as React from 'react';
import * as ReactDOM from 'react-dom';
import { Menu, MenuItemProps } from 'semantic-ui-react';

interface Props {
  activeItem: string;
  user: any;
}

interface State {
  activeItem: string;
  user: any;
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
      </Menu>
    );
  }

  private clickedMenuItem = (event: React.MouseEvent<HTMLAnchorElement>, item: MenuItemProps) => {
    this.setState({ activeItem: item.name })
  }
}

export default MainNav;
