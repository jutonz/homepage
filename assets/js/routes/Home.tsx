import * as React from 'react';
import { MainNav, ActiveItem } from './../components/MainNav';

export default class Home extends React.Component {
  public render() {
    return (
      <div>
        <MainNav activeItem={ActiveItem.Home} />
        hey
      </div>
    );
  }
}
