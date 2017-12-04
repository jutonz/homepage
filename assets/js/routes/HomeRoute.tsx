import * as React from 'react';
import { MainNav, ActiveItem } from './../components/MainNav';
import { Incr } from './../components/Incr';

export const HomeRoute = () => (
  <div>
    <MainNav activeItem={ActiveItem.Home} />
    <Incr />
    <Incr />
    <Incr />
    <Incr />
  </div>
);
