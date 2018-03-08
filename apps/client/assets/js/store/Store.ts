import { combineReducers } from "redux";

import {
  Action,
  ActionType,
  AddCsrfTokenAction,
  SetSessionAction
} from "./Actions";

import { CoffeemakerStoreState, coffeemaker } from "./reducers/coffeemaker";
import { FlashStoreState, flash } from "./reducers/flash";
import { AccountStoreState, accounts } from "./reducers/accounts";

export interface StoreState {
  csrfToken?: string;
  count: number;
  sessionAuthenticated?: boolean;
  coffeemaker: CoffeemakerStoreState;
  flash: FlashStoreState;
  accounts: AccountStoreState;
}

const count = (state: number = 0, action: Action): number => {
  switch (action.type) {
    case ActionType.Inc:
      return state + 1;
    case ActionType.Dec:
      return Math.max(state - 1, 0);
    default:
      return state;
  }
};

const csrfToken = (state: string = null, action: Action): string => {
  switch (action.type) {
    case ActionType.AddCsrfToken:
      return (action as AddCsrfTokenAction).token;
    default:
      return state;
  }
};

const sessionAuthenticated = (
  state: boolean = false,
  action: Action
): boolean => {
  switch (action.type) {
    case ActionType.SetSession:
      return (action as SetSessionAction).established;
    default:
      return state;
  }
};

export const appStore = combineReducers({
  coffeemaker,
  count,
  csrfToken,
  sessionAuthenticated,
  flash,
  accounts
});
