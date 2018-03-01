export enum ActionType {
  Inc,
  Dec,
  AddCsrfToken,
  SetSession,
  SetCoffemakerFloz,
  SetCoffeemakerGrams,
  FlashAdd,
  FlashRemove
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

export { FlashMessage, FlashTone, showFlash } from "./reducers/flash";
