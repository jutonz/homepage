import * as React from 'react';
import { MainNav, ActiveItem } from './../components/MainNav';
import { Incr } from './../components/Incr';
import { asAuthenticatedRoute } from './asAuthenticatedRoute';

class _HomeRoute extends React.Component {
  public render() {
    return (
      <div>
        <MainNav activeItem={ActiveItem.Home} />
        <Incr />
        <Incr />
        <Incr />
        <Incr />
      </div>
    );
  }
}

export const HomeRoute = asAuthenticatedRoute(_HomeRoute);
