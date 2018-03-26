import gql from "graphql-tag";
export * from "./accounts/create-account";
import { createAccountReducer } from "./accounts/create-account";

////////////////////////////////////////////////////////////////////////////////
// Public action creators
////////////////////////////////////////////////////////////////////////////////

export const fetchAccount = id => {
  return (dispatch, getState) => {
    const state: StoreState = getState();
    const existing = state.accounts.accounts[id];

    if (existing) {
      const fetchAction = accountFetchAction("success", existing);
      return Promise.resolve(dispatch(fetchAction));
    } else {
      const account = { id, fetchStatus: "in_progress" };
      dispatch(accountFetchAction("in_progress", account));

      const query = gql`
        query GetAccount($id: ID!) {
          getAccount(id: $id) {
            name
            id
          }
        }
      `;
      const variables = { id };

      return window.grapqlClient
        .query({
          query,
          variables
        })
        .then(response => {
          const account = {
            ...response.data.getAccount,
            ...{ fetchStatus: "success" }
          };
          return dispatch(accountFetchAction("success", account));
        })
        .catch(error => {
          console.error(error);
          const graphQLErrors = error.graphQLErrors;
          const errors = graphQLErrors.map(error => error.message);
          const account: Account = {
            id,
            errors,
            fetchStatus: "failure"
          };
          return dispatch(accountFetchAction("failure", account));
        });
    }
  };
};

export const fetchAccounts = () => {
  return dispatch => {
    dispatch(requestAccounts());

    const query = gql`
      query GetAccounts {
        getAccounts {
          name
          id
        }
      }
    `;

    window.grapqlClient
      .query({ query })
      .then(response => {
        const rawAccounts = response.data.getAccounts;
        const accounts = {};
        rawAccounts.forEach(raw => {
          const { id, name } = raw;
          const account = { id, name, fetchStatus: "success" };
          accounts[id] = account;
        });
        dispatch(receiveAccountsSuccess(accounts));
      })
      .catch(error => {
        console.error(error);
        const message = error.message.replace("GraphQL error: ", "");
        dispatch(receiveAccountsError(message));
      });
  };
};

export const storeAccount = account => ({
  type: "STORE_ACCOUNT",
  account
});

////////////////////////////////////////////////////////////////////////////////
// Private action creators
////////////////////////////////////////////////////////////////////////////////

const accountFetchAction = (status, account) => ({
  type: "ACCOUNT_FETCH",
  status,
  account
});

const requestAccounts = () => ({
  type: "ACCOUNTS_REQUEST"
});

const receiveAccountsSuccess = accounts => ({
  type: "ACCOUNTS_RECEIVE",
  status: "success",
  accounts
});

const receiveAccountsError = error => ({
  type: "ACCOUNTS_RECEIVE",
  status: "error",
  error
});

////////////////////////////////////////////////////////////////////////////////
// Action reducer
////////////////////////////////////////////////////////////////////////////////

const initialState = { accounts: {} };
export const accounts = (state = initialState, action) => {
  let newState;

  switch (action.type) {
    case "ACCOUNT_FETCH":
      newState = handleAccountFetchAction(state, action);
      break;
    case "ACCOUNTS_REQUEST":
      newState = { loadingAllAccounts: true };
      break;
    case "ACCOUNTS_RECEIVE": {
      if (action.status === "success") {
        const { accounts } = action;
        newState = { loadingAllAccounts: false, accounts };
      } else {
        const { error } = action;
        newState = { loadingAllAccounts: false, accountsFetchError: error };
      }
      break;
    }
    case "STORE_ACCOUNT": {
      const account = normalizeAccount(action.account);
      newState = { accounts: { ...state.accounts, ...account } };
      break;
    }
    case "UNSTORE_ACCOUNT": {
      const { [action.id]: _removed, ...accounts } = state.accounts;
      newState = { accounts };
      break;
    }
    case "DELETE_ACCOUNT_REQUEST": {
      const { id } = action;
      const original = state.accounts[parseInt(id)];
      const account = normalizeAccount({
        ...original,
        deleting: true,
        deleteErrors: undefined
      });
      newState = { accounts: { ...state.accounts, ...account } };
      break;
    }
    case "DELETE_ACCOUNT_SUCCESS": {
      const { id } = action;
      const original = state.accounts[parseInt(id)];
      const account = normalizeAccount({
        ...original,
        deleting: false
      });
      newState = { accounts: { ...state.accounts, ...account } };
      break;
    }
    case "DELETE_ACCOUNT_FAILURE": {
      const { errors, id } = action;
      const account = state.accounts[parseInt(id)];
      const withError = normalizeAccount({
        ...account,
        deleteErrors: errors,
        deleting: false
      });
      newState = { accounts: { ...state.accounts, ...withError } };
      break;
    }
  }

  // Handle child reducers
  state.createAccount = createAccountReducer(state.createAccount, action);

  return { ...state, ...newState };
};

////////////////////////////////////////////////////////////////////////////////
// Helpers
////////////////////////////////////////////////////////////////////////////////

const handleAccountFetchAction = (state, action) => {
  let newState = {};

  switch (action.status) {
    case "in_progress": {
      const fetchStatus = "in_progress";
      const account = { ...action.account, ...{ errors: null, fetchStatus } };
      const normaliedAccount = normalizeAccount(account);
      newState = {
        accounts: { ...state.accounts, ...normaliedAccount }
      };
      break;
    }
    case "success": {
      const fetchStatus = "success";
      const newAccount = normalizeAccount({
        ...action.account,
        ...{ fetchStatus }
      });
      const accounts = { ...state.accounts, ...newAccount };
      newState = { accounts };
      break;
    }
    case "failure": {
      const newAccount = normalizeAccount(action.account);
      const accounts = { ...state.accounts, ...newAccount };
      newState = { accounts };
      break;
    }
    default:
      const errors = { errors: [`Unhandled FetchStatus ${action.status}`] };
      const account = normalizeAccount({ ...action.account, ...errors });
      newState = { accounts: { ...state.accounts, ...account } };
      break;
  }

  return newState;
};

const normalizeAccount = account => {
  let normalized = {};
  normalized[account.id] = account;
  return normalized;
};
