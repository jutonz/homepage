import { Action, ActionType } from './../Actions';
import { Dispatch } from "redux";
import gql from "graphql-tag";

////////////////////////////////////////////////////////////////////////////////
// Store state
////////////////////////////////////////////////////////////////////////////////

export interface AccountStoreState {
  loadingAccounts?: boolean;
  accounts?: Array<Account>;
  accountsFetchError?: string;
  newAccountName?: string;
  newAccountNameIsValid?: boolean;
  creatingNewAccount?: boolean;
  createNewAccountError?: string
}

export const initialState: AccountStoreState = {
  newAccountName: ""
};

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

export interface SetNewAccountNameAction extends Action {
  newName: string;
}

export interface CreateAccountRequest extends Action {
}

export interface CreateAccountReceive extends Action {
  status: string;
  error?: string;
  account?: Account;
}

////////////////////////////////////////////////////////////////////////////////
// Public action creators
////////////////////////////////////////////////////////////////////////////////

export const fetchAccounts = (): any =>  {
  return (dispatch: Dispatch<{}>) => {
    dispatch(requestAccounts());

    const query = gql`{
      getAccounts { name id }
    }`;

    window.grapqlClient.query({ query }).then((response: any) => {
      const rawAccounts = response.data.getAccounts;
      const accounts: Array<Account> = rawAccounts.map((account: any) => {
        const { id, name } = account;
        return { id, name };
      });
      dispatch(receiveAccountsSuccess(accounts));
    }).catch((error: any) => {
      console.error(error);
      const message = error.message.replace("GraphQL error: ", "");
      dispatch(receiveAccountsError(message));
    });
  };
}

export const setNewAccountName = (newName: string): SetNewAccountNameAction => ({
  type: ActionType.SetNewAccountNameAction,
  newName
});

export const createAccount = (name: string): any => {
  return (dispatch: Dispatch<{}>) => {
    dispatch(createAccountRequest());

    const mutation = gql`mutation {
      createAccount(name: "${name}") { name id }
    }`;

    window.grapqlClient.mutate({ mutation }).then((response: any) => {
      const { name, id } = response.data.createAccount;
      dispatch(createAccountSuccess({ name, id }));
    }).catch((error: any) => {
      console.log(error);
      const message = error.message.replace("GraphQL error: ", "");
      dispatch(createAccountFailure(message));
    });
  };
};

////////////////////////////////////////////////////////////////////////////////
// Private action creators
////////////////////////////////////////////////////////////////////////////////

export const requestAccounts = (): AccountsRequestAction => ({
  type: ActionType.AccountsRequest
});

const receiveAccountsSuccess = (accounts: Array<Account>): AccountsReceiveAction => ({
  type: ActionType.AccountsReceive,
  status: "success",
  accounts
});

const receiveAccountsError = (error: string): AccountsReceiveAction => ({
  type: ActionType.AccountsReceive,
  status: "error",
  error
});

const createAccountRequest = (): CreateAccountRequest => ({
  type: ActionType.CreateAccountRequest
});

const createAccountSuccess = (account: Account): CreateAccountReceive => ({
  type: ActionType.CreateAccountReceive,
  status: "success",
  account
});

const createAccountFailure = (error: string): CreateAccountReceive => ({
  type: ActionType.CreateAccountReceive,
  status: "failure",
  error
});

////////////////////////////////////////////////////////////////////////////////
// Action reducer
////////////////////////////////////////////////////////////////////////////////

export const accounts = (
  state: AccountStoreState = initialState,
  action: Action
) => {
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
    case ActionType.SetNewAccountNameAction: {
      const newName = (action as SetNewAccountNameAction).newName;
      const isValid = isNewAccountNameValid(newName);
      newState = {
        newAccountName: newName,
        newAccountNameIsValid: isValid
      };
      return { ...state, ...newState };
    }
    case ActionType.CreateAccountRequest: {
      newState = { creatingNewAccount: true }
      return { ...state, ...newState };
    }
    case ActionType.CreateAccountReceive: {
      const receiveAction = (action as CreateAccountReceive);
      if (receiveAction.status === "success") {
        const account = receiveAction.account;
        newState = {
          creatingNewAccount: false,
          newAccountName: "",
          accounts: [...state.accounts, account]
        };
      } else {
        const { error } = receiveAction;
        newState = { creatingNewAccount: false, createNewAccountError: error };
      }
      return { ...state, ...newState };
    }
    default: return state;
  }
};

////////////////////////////////////////////////////////////////////////////////
// Helpers
////////////////////////////////////////////////////////////////////////////////

const isNewAccountNameValid = (newName: string): boolean => (
  newName && newName !== ""
);
