import React from "react";
import { Header } from "semantic-ui-react";

export const AccountName = props => (
  <div>
    <Header>Account {props.account.name}</Header>
  </div>
);
