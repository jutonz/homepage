import * as React from "react";
import { Account } from "./../Store";

interface Props {
  account: Account;
}

const _AccountName = (props: Props) => <div>{props.account.name}</div>;

export const AccountName = _AccountName;
