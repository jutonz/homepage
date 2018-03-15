import { Action, ActionType, FetchStatus } from './../Actions';
import { StoreState } from "./../../Store";
import { Dispatch } from "redux";
import gql from "graphql-tag";
import {
  AccountsCreateAccountStoreState,
  createAccountReducer
} from "./accounts/create-account";
import {
  AccountsViewAccountStoreState,
  viewAccountReducer
} from "./accounts/view-account";

export * from "./accounts/create-account";
export * from "./accounts/view-account";

////////////////////////////////////////////////////////////////////////////////
// Store state
////////////////////////////////////////////////////////////////////////////////

export interface AccountStoreState {
  fetchingAccount?: boolean;
  account?: Account;
  accountFetchErrorMessage?: string;

  loadingAccounts?: boolean;
  accounts?: Array<Account>;
  accountsFetchError?: string;

  createAccount?: AccountsCreateAccountStoreState;
  viewAccount?: AccountsViewAccountStoreState;
}

export const initialState: AccountStoreState = {
  accounts: []
};

export interface Account {
  name: string;
  id: string;
}

////////////////////////////////////////////////////////////////////////////////
// Action definitions
////////////////////////////////////////////////////////////////////////////////

export interface AccountFetchAction extends Action {
  status: FetchStatus
  account?: Account;
  errorMessage?: string;
}

export interface AccountsRequestAction extends Action {
}

export interface AccountsReceiveAction extends Action {
  status: string;
  accounts?: Array<Account>
  error?: string;
}

export interface StoreAccountAction extends Action {
  account: Account
}

////////////////////////////////////////////////////////////////////////////////
// Public action creators
////////////////////////////////////////////////////////////////////////////////

export const fetchAccount = (id: string): any => {
  return (dispatch: Dispatch<{}>, getState: Function): Promise<Action> => {
    const state: StoreState = getState();
    const existing = (state.accounts.accounts || []).filter(existing => {
      return existing.id === id;
    })[0];

    if (existing) {
      return Promise.resolve(dispatch(accountFetchAction(FetchStatus.Success, existing, null)));
    } else {
      dispatch(accountFetchAction(FetchStatus.InProgress));

      const query = gql`{
        getAccount(id: ${id}) { name id }
      }`;

      return window.grapqlClient.query({ query }).then((response: any) => {
        const rawAccount = response.data.getAccount;
        const { name, id } = rawAccount;
        const account = { name, id };
        return dispatch(accountFetchAction(FetchStatus.Success, account, null));
      }).catch((error: any) => {
        console.error(error);
        const message = error.message.replace("GraphQL error: ", "");
        return dispatch(accountFetchAction(FetchStatus.Failure, null, message));
      });
    }
  };
};

export const fetchAccounts = (): any => {
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

export const storeAccount = (account: Account): any => ({
  type: ActionType.StoreAccount,
  account
})

////////////////////////////////////////////////////////////////////////////////
// Private action creators
////////////////////////////////////////////////////////////////////////////////

const accountFetchAction = (
  status: FetchStatus,
  account?: Account,
  errorMessage?: string
): AccountFetchAction => ({
  type: ActionType.AccountFetch,
  status,
  account,
  errorMessage
});

const requestAccounts = (): AccountsRequestAction => ({
  type: ActionType.AccountsRequest
});

const receiveAccountsSuccess = (
  accounts: Array<Account>
): AccountsReceiveAction => ({
  type: ActionType.AccountsReceive,
  status: "success",
  accounts
});

const receiveAccountsError = (error: string): AccountsReceiveAction => ({
  type: ActionType.AccountsReceive,
  status: "error",
  error
});

////////////////////////////////////////////////////////////////////////////////
// Action reducer
////////////////////////////////////////////////////////////////////////////////

export const accounts = (
  state: AccountStoreState = initialState,
  action: Action
): AccountStoreState => {
  let newState: Partial<AccountStoreState>;

  switch(action.type) {
    case ActionType.AccountFetch:
      newState = handleAccountFetchAction(state, action as AccountFetchAction);
      break;
    case ActionType.AccountsRequest:
      newState = { loadingAccounts: true };
      break;
    case ActionType.AccountsReceive: {
      const receiveAction = (action as AccountsReceiveAction);
      if (receiveAction.status === "success") {
        const { accounts } = receiveAction;
        newState = { loadingAccounts: false, accounts };
      } else {
        const { error } = receiveAction;
        newState = { loadingAccounts: false, accountsFetchError: error };
      }
      break;
    }
    case ActionType.StoreAccount: {
      const account = (action as StoreAccountAction).account;
      newState = { accounts: [ ...state.accounts, account ] };
      break;
    }
    default:
      newState = {};
      break;
  }

  // Handle child reducers
  state.createAccount = createAccountReducer(state.createAccount, action);
  state.viewAccount = viewAccountReducer(state.viewAccount, action);

  return { ...state, ...newState };
};

////////////////////////////////////////////////////////////////////////////////
// Helpers
////////////////////////////////////////////////////////////////////////////////

const handleAccountFetchAction = (state: AccountStoreState, action: AccountFetchAction) => {
  let newState: Partial<AccountStoreState> = {};

  switch(action.status) {
    case FetchStatus.InProgress:
      newState = {
        fetchingAccount: true,
        accountFetchErrorMessage: ""
      };
      break;
    case FetchStatus.Success:
      newState = {
        fetchingAccount: false,
        accounts: [ ...state.accounts, action.account ]
      };
      break;
    case FetchStatus.Failure:
      newState = {
        fetchingAccount: false,
        accountFetchErrorMessage: action.errorMessage
      };
      break;
    default:
      newState = {
        fetchingAccount: false,
        accountFetchErrorMessage: `Unhandled FetchStatus ${action.status}`
      };
      break;
  }

  return newState;
}
