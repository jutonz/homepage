import React from "react";
import { Header } from "semantic-ui-react";

export const TeamName = props => (
  <div>
    <Header>Team {props.team.name}</Header>
  </div>
);
