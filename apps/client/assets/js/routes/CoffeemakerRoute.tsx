import * as React from "react";
import { MainNav, ActiveItem } from "./../components/MainNav";
import { Coffeemaker } from "./../components/Coffeemaker";

export const CoffeemakerRoute = () => (
  <div>
    <MainNav activeItem={ActiveItem.Coffeemaker} />
    <Coffeemaker />
  </div>
);
