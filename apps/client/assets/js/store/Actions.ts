export enum ActionType {
  Inc = "Inc",
  Dec = "Dec",
  AddCsrfToken = "AddCsrfToken",
  SetSession = "SetSession",
  SetCoffemakerFloz = "SetCoffemakerFloz",
  SetCoffeemakerGrams = "SetCoffeemakerGrams",
  FlashAdd = "FlashAdd",
  FlashRemove = "FlashRemove",
  AccountFetch = "AccountFetch",
  AccountsRequest = "AccountsRequest",
  AccountsReceive = "AccountsReceive",
  StoreAccount = "StoreAccount",
  SetNewAccountName = "SetNewAccountName",
  CreateAccountRequest = "CreateAccountRequest",
  CreateAccountReceive = "CreateAccountReceive",
  ViewAccount = "ViewAccount",
  ViewAccountLoading = "ViewAccountLoading"
}

export enum FetchStatus {
  Pending = "Pending",
  InProgress = "InProgress",
  Success = "Success",
  Failure = "Failure"
}

export interface Action {
  type: ActionType;
}

export interface AddCsrfTokenAction extends Action {
  token: string;
}

export interface SetSessionAction extends Action {
  established: boolean;
}

////////////////////////////////////////////////////////////////////////////////
// Action creators
////////////////////////////////////////////////////////////////////////////////

export const incAction = (): Action => ({
  type: ActionType.Inc
});

export const decAction = (): Action => ({
  type: ActionType.Dec
});

export const addCsrfTokenAction = (token: string): AddCsrfTokenAction => ({
  type: ActionType.AddCsrfToken,
  token: token
});

export const setSessionAction = (established: boolean): SetSessionAction => ({
  type: ActionType.SetSession,
  established: established
});

export {
  setCoffeemakerFlozAction,
  setCoffeemakerGramsAction,
  SetCoffeemakerFlozAction,
  SetCoffeemakerGramsAction
} from "./reducers/coffeemaker";

export * from "./reducers/accounts";
export * from "./reducers/flash";
