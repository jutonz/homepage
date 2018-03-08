import { Action, ActionType } from './../Actions';
import { Dispatch } from "redux";

////////////////////////////////////////////////////////////////////////////////
// Store state
////////////////////////////////////////////////////////////////////////////////

export interface AccountStoreState {
  loadingAccounts?: boolean;
  accounts?: Array<Account>;
  accountsFetchError?: string;
}

export const initialState: AccountStoreState = {};

export interface Account {
  name: string;
  id: string;
}

////////////////////////////////////////////////////////////////////////////////
// Action definitions
////////////////////////////////////////////////////////////////////////////////

export interface AccountsRequestAction extends Action {
}

export interface AccountsReceiveAction extends Action {
  status: string;
  accounts?: Array<Account>
  error?: string;
}

////////////////////////////////////////////////////////////////////////////////
// Action creators
////////////////////////////////////////////////////////////////////////////////

export const fetchAccounts = (): any =>  {
  return (dispatch: Dispatch<{}>) => {
    dispatch(requestAccounts());

    return setTimeout(() => {
      //const accounts: Array<Account> = [
        //{ name: "Account 1", id: "123" },
        //{ name: "Account 2", id: "456" }
      //]
      //dispatch(receiveAccounts(accounts, "success"));
      dispatch(receiveAccountsError("Failed to fetch accounts"));
    }, 2000);
  };
}

export const requestAccounts = (): AccountsRequestAction => ({
  type: ActionType.AccountsRequest
});

export const receiveAccountsSuccess = (accounts: Array<Account>): AccountsReceiveAction => ({
  type: ActionType.AccountsReceive,
  status: "success",
  accounts
});

export const receiveAccountsError = (error: string): AccountsReceiveAction => ({
  type: ActionType.AccountsReceive,
  status: "error",
  error
});

////////////////////////////////////////////////////////////////////////////////
// Action reducer
////////////////////////////////////////////////////////////////////////////////

export const accounts = (state: AccountStoreState = initialState, action: Action) => {
  let newState: Partial<AccountStoreState>;

  switch(action.type) {
    case ActionType.AccountsRequest: {
      newState = { loadingAccounts: true };
      return { ...state, ...newState };
    }
    case ActionType.AccountsReceive: {
      const receiveAction = (action as AccountsReceiveAction);

      if (receiveAction.status === "success") {
        const { accounts } = receiveAction;
        newState = { loadingAccounts: false, accounts };
      } else {
        const { error } = receiveAction;
        newState = { loadingAccounts: false, accountsFetchError: error };
      }
      return { ...state, ...newState };
    }
    default: return state;
  }
};

////////////////////////////////////////////////////////////////////////////////
// Helpers
////////////////////////////////////////////////////////////////////////////////
