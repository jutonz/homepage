import React from "react";
import { MainNav } from "./../components/MainNav";
import { Coffeemaker } from "./../components/Coffeemaker";

export const CoffeemakerRoute = () => (
  <div>
    <MainNav activeItem={"coffeemaker"} />
    <Coffeemaker />
  </div>
);
