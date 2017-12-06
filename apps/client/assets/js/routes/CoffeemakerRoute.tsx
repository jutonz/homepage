import * as React from 'react';
import { MainNav, ActiveItem } from './../components/MainNav';
import { Coffeemaker } from './../components/Coffemaker';

export const CoffeemakerRoute = () => (
  <div>
    <MainNav activeItem={ActiveItem.Coffeemaker} />
    <Coffeemaker />
  </div>
);
