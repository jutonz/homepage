import { Action, ActionType, FetchStatus } from './../Actions';
import { StoreState } from "./../../Store";
import { Dictionary } from "./../../Types";
import { Dispatch } from "redux";
import gql from "graphql-tag";
import { GetAccountQuery, GetAccountQueryVariables } from "./../../Schema";
import {
  AccountsCreateAccountStoreState,
  createAccountReducer
} from "./accounts/create-account";
import { ApolloQueryResult } from "apollo-client"
import { GraphQLError } from "graphql";

export * from "./accounts/create-account";

////////////////////////////////////////////////////////////////////////////////
// Store state
////////////////////////////////////////////////////////////////////////////////

export interface AccountStoreState {
  accounts?: Dictionary<Account>;

  loadingAllAccounts?: boolean;
  accountsFetchError?: string;

  createAccount?: AccountsCreateAccountStoreState;
}

export const initialState: AccountStoreState = {
  accounts: {}
};

export interface Account {
  id: string;
  name?: string;
  errors?: Array<string>;
  fetchStatus: FetchStatus;
}

////////////////////////////////////////////////////////////////////////////////
// Action definitions
////////////////////////////////////////////////////////////////////////////////

export interface AccountFetchAction extends Action {
  status: FetchStatus
  account?: Account;
}

export interface AccountsRequestAction extends Action {
}

export interface AccountsReceiveAction extends Action {
  status: string;
  accounts?: Dictionary<Account>;
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
    const existing = state.accounts.accounts[id];

    if (existing) {
      const fetchAction = accountFetchAction(FetchStatus.Success, existing);
      return Promise.resolve(dispatch(fetchAction));
    } else {
      const account = {
        id,
        fetchStatus: FetchStatus.InProgress
      };
      dispatch(accountFetchAction(FetchStatus.InProgress, account));

      const query = gql`query GetAccount($id: ID!) {
        getAccount(id: $id) { name id }
      }`;
      const variables: GetAccountQueryVariables = { id };

      return window.grapqlClient.query({
        query,
        variables
      }).then((response: ApolloQueryResult<GetAccountQuery>) => {
        const account = {
          ...response.data.getAccount,
          ...{ fetchStatus: FetchStatus.Success }
        };
        return dispatch(accountFetchAction(FetchStatus.Success, account));
      }).catch((error: any) => {
        console.error(error);
        const graphQLErrors: Array<GraphQLError> = error.graphQLErrors;
        const errors = graphQLErrors.map(error => error.message);
        const account: Account = {
          id,
          errors,
          fetchStatus: FetchStatus.Failure
        };
        return dispatch(accountFetchAction(FetchStatus.Failure, account));
      });
    }
  };
};

export const fetchAccounts = (): any => {
  return (dispatch: Dispatch<{}>) => {
    dispatch(requestAccounts());

    const query = gql`query GetAccounts {
      getAccounts { name id }
    }`;

    window.grapqlClient.query({ query }).then((response: any) => {
      const rawAccounts = response.data.getAccounts;
      const accounts: Dictionary<Account> = {};
      rawAccounts.forEach((raw: any) => {
        const { id, name } = raw;
        const account: Account = { id, name, fetchStatus: FetchStatus.Success };
        accounts[id] = account;
      });
      dispatch(receiveAccountsSuccess(accounts));
    }).catch((error: any) => {
      //const errors: Array<GraphQLError> = error.graphQLErrors;
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
  account: Account
): AccountFetchAction => ({
  type: ActionType.AccountFetch,
  status,
  account
});

const requestAccounts = (): AccountsRequestAction => ({
  type: ActionType.AccountsRequest
});

const receiveAccountsSuccess = (
  accounts: Dictionary<Account>
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
      newState = { loadingAllAccounts: true };
      break;
    case ActionType.AccountsReceive: {
      const receiveAction = (action as AccountsReceiveAction);
      if (receiveAction.status === "success") {
        const { accounts } = receiveAction;
        newState = { loadingAllAccounts: false, accounts };
      } else {
        const { error } = receiveAction;
        newState = { loadingAllAccounts: false, accountsFetchError: error };
      }
      break;
    }
    case ActionType.StoreAccount: {
      const account = normalizeAccount((action as StoreAccountAction).account);
      newState = { accounts: { ...state.accounts, ...account } };
      break;
    }
    default:
      newState = {};
      break;
  }

  // Handle child reducers
  state.createAccount = createAccountReducer(state.createAccount, action);

  return { ...state, ...newState };
};

////////////////////////////////////////////////////////////////////////////////
// Helpers
////////////////////////////////////////////////////////////////////////////////

const handleAccountFetchAction = (state: AccountStoreState, action: AccountFetchAction) => {
  let newState: Partial<AccountStoreState> = {};

  switch(action.status) {
    case FetchStatus.InProgress: {
      const fetchStatus = FetchStatus.InProgress;
      const account = { ...action.account, ...{ errors: null, fetchStatus } };
      const normaliedAccount = normalizeAccount(account);
      newState = {
        accounts: { ...state.accounts, ...normaliedAccount }
      };
      break;
    }
    case FetchStatus.Success: {
      const fetchStatus = FetchStatus.Success;
      const newAccount = normalizeAccount({ ...action.account, ...{ fetchStatus } });
      const accounts = { ...state.accounts, ...newAccount };
      newState = {
        accounts,
      };
      break;
    }
    case FetchStatus.Failure: {
      const newAccount = normalizeAccount(action.account);
      const accounts = { ...state.accounts, ...newAccount };
      newState = {
        accounts
      };
      break;
    }
    default:
      const errors = { errors: [`Unhandled FetchStatus ${action.status}`] };
      const account = normalizeAccount({ ...action.account, ...errors });
      newState = {
        accounts: { ...state.accounts, ...account }
      };
      break;
  }

  return newState;
}

const normalizeAccount = (account: Account): Dictionary<Account> => {
  let normalized: Dictionary<Account> = {};
  normalized[account.id] = account;
  return normalized;
};
