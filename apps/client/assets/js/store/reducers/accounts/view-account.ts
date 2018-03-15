import { Account, StoreState, fetchAccount } from "./../../../Store";
import { Action, ActionType } from "./../../Actions";
import { Dispatch } from "redux";

////////////////////////////////////////////////////////////////////////////////
// Store state
////////////////////////////////////////////////////////////////////////////////

export interface AccountsViewAccountStoreState {
  loading?: boolean;
  errorMessage?: string;
  account?: Account
}

const initialState: AccountsViewAccountStoreState = {};

////////////////////////////////////////////////////////////////////////////////
// Action definitions
////////////////////////////////////////////////////////////////////////////////

export interface ViewAccountAction extends Action {
  account: Account;
}

interface ViewAccountLoadingAction extends Action {}

////////////////////////////////////////////////////////////////////////////////
// Public action creators
////////////////////////////////////////////////////////////////////////////////

export const viewAccount = (account: Account): ViewAccountAction => ({
  type: ActionType.ViewAccount,
  account
});

export const fetchAndViewAccount = (accountId: string): any => {
  return (dispatch: Dispatch<{}>, getState: Function) => {
    dispatch(fetchAccount(accountId)).then(() => {
      dispatch(viewAccountLoading());
      const state: StoreState = getState();
      const loadedAccount = (state.accounts.accounts || []).filter(loaded => {
        return loaded.id === accountId;
      })[0];
      dispatch(viewAccount(loadedAccount));
    });
  }
};

////////////////////////////////////////////////////////////////////////////////
// Private action creators
////////////////////////////////////////////////////////////////////////////////

const viewAccountLoading = (): ViewAccountLoadingAction => ({
  type: ActionType.ViewAccountLoading
});

////////////////////////////////////////////////////////////////////////////////
// Action reducer
////////////////////////////////////////////////////////////////////////////////

export const viewAccountReducer = (
  state: AccountsViewAccountStoreState = initialState,
  action: Action
): AccountsViewAccountStoreState => {
  let newState: Partial<AccountsViewAccountStoreState>;

  switch (action.type) {
    case ActionType.ViewAccountLoading:
      newState = { loading: true }
      break;
    case ActionType.ViewAccount:
      newState = {
        account: (action as ViewAccountAction).account,
        loading: true
      }
      break;
    default:
      newState = {};
      break;
  }

  return { ...state, ...newState };
};
