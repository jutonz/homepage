import gql from "graphql-tag";
export * from "./accounts/create-account";
import { createAccountReducer } from "./accounts/create-account";
import { Map } from "immutable";

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
      const { account } = action;
      const withFetchStatus = { ...account, fetchStatus: "success" };
      const normal = normalizeAccount(withFetchStatus);
      newState = { accounts: { ...state.accounts, ...normal } };
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
    case "SET_ACCOUNT_RENAME_NAME": {
      const { name, id } = action;
      const account = state.accounts[parseInt(id)];
      const withRenameName = { ...account, renameName: name };
      const normal = normalizeAccount(withRenameName);
      newState = { accounts: { ...state.accounts, ...normal } };
      break;
    }
    case "ACCOUNT_RENAME_REQUEST": {
      const { id } = action;
      const account = state.accounts[parseInt(id)];
      const { renameErrors, ...withoutErrors } = account;
      const withLoading = { ...withoutErrors, isRenaming: true };
      const normal = normalizeAccount(withLoading);
      newState = { accounts: { ...state.accounts, ...normal } };
      break;
    }
    case "ACCOUNT_RENAME_SUCCESS": {
      const { id, name } = action;
      const account = state.accounts[parseInt(id)];
      const { isRenaming, renameName, ...withoutLoading } = account;
      const withNewName = { ...withoutLoading, name };
      const normal = normalizeAccount(withNewName);
      newState = { accounts: { ...state.accounts, ...normal } };
      break;
    }
    case "ACCOUNT_RENAME_FAILURE": {
      const { id, errors } = action;
      const account = state.accounts[parseInt(id)];
      const { isRenaming, ...withoutLoading } = account;
      const withErrors = { ...withoutLoading, renameErrors: errors };
      const normal = normalizeAccount(withErrors);
      newState = { accounts: { ...state.accounts, ...normal } };
      break;
    }
    case "FETCH_ACCOUNT_USERS_REQUEST": {
      const { id } = action;
      const account = state.accounts[parseInt(id)];
      const withLoading = { ...account, isLoadingUsers: true };
      const normal = normalizeAccount(withLoading);
      newState = { accounts: { ...state.accounts, ...normal } };
      break;
    }
    case "FETCH_ACCOUNT_USERS_SUCCESS": {
      const { id, userIds } = action;
      const account = state.accounts[parseInt(id)];
      const { isLoadingUsers, ...withoutLoading } = account;
      const withUserIds = { ...withoutLoading, userIds };
      const normal = normalizeAccount(withUserIds);
      newState = { accounts: { ...state.accounts, ...normal } };
      break;
    }
    case "FETCH_ACCOUNT_USERS_FAILURE": {
      const { id, errors } = action;
      const account = state.accounts[parseInt(id)];
      const { isLoadingUsers, ...withoutLoading } = account;
      const withErrors = { ...withoutLoading, loadUsersErrors: errors };
      const normal = normalizeAccount(withErrors);
      newState = { accounts: { ...state.accounts, ...normal } };
      break;
    }
    case "SET_JOIN_ACCOUNT_NAME": {
      const { name } = action;
      newState = { ...state, joinAccountName: name };
      break;
    }
    case "JOIN_ACCOUNT_REQUEST": {
      const { joinAccountErrors, ...withoutErrors } = state;
      newState = { ...withoutErrors, joiningAccount: true };
      break;
    }
    case "JOIN_ACCOUNT_SUCCESS": {
      newState = { joiningAccount: false, joinAccountName: null };
      break;
    }
    case "JOIN_ACCOUNT_FAILURE": {
      const { errors } = action;
      newState = { joiningAccount: false, joinAccountErrors: errors };
      break;
    }
    case "LEAVE_ACCOUNT_REQUEST": {
      newState = { leavingAccount: true, leavingAccountErrors: null };
      break;
    }
    case "LEAVE_ACCOUNT_SUCCESS": {
      newState = { leavingAccount: false };
      break;
    }
    case "LEAVE_ACCOUNT_FAILURE": {
      const { errors } = action;
      newState = { leavingAccount: false, leavingAccountErrors: errors };
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
