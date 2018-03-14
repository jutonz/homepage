import { Account, storeAccount } from "./../accounts";
import { Action, ActionType } from "./../../Actions";
import { Dispatch } from "redux";
import gql from "graphql-tag";

////////////////////////////////////////////////////////////////////////////////
// Store state
////////////////////////////////////////////////////////////////////////////////


export interface AccountsCreateAccountStoreState {
  creating?: boolean;
  error?: string;
  newAccountName?: string;
  newAccountNameIsValid?: boolean;
}

const initialState: AccountsCreateAccountStoreState = {
  newAccountName: ""
}

////////////////////////////////////////////////////////////////////////////////
// Action definitions
////////////////////////////////////////////////////////////////////////////////

interface CreateAccountRequest extends Action {
}

interface CreateAccountReceive extends Action {
  status: string;
  error?: string;
  account?: Account;
}

export interface SetNewAccountNameAction extends Action {
  newName: string;
}

////////////////////////////////////////////////////////////////////////////////
// Public action creators
////////////////////////////////////////////////////////////////////////////////

export const setNewAccountName = (
  newName: string
): SetNewAccountNameAction => ({
  type: ActionType.SetNewAccountName,
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
      const account = { name, id };
      dispatch(createAccountSuccess(account));
      dispatch(storeAccount(account));
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

export const createAccountReducer = (
  state: AccountsCreateAccountStoreState = initialState,
  action: Action
): AccountsCreateAccountStoreState  => {
  let newState: Partial<AccountsCreateAccountStoreState>;

  switch(action.type) {
    case ActionType.SetNewAccountName: {
      const newName = (action as SetNewAccountNameAction).newName;
      const isValid = isNewAccountNameValid(newName);
      newState = { newAccountName: newName, newAccountNameIsValid: isValid };
      break;
    }
    case ActionType.CreateAccountRequest: {
      newState = { creating: true, error: null }
      break;
    }
    case ActionType.CreateAccountReceive: {
      const receiveAction = (action as CreateAccountReceive);
      if (receiveAction.status === "success") {
        newState = { creating: false, newAccountName: "" };
      } else {
        const { error } = receiveAction;
        newState = { creating: false, error: error };
      }
      break;
    }
    default:
      newState = {};
      break;
  }

  return { ...state, ...newState };
}

////////////////////////////////////////////////////////////////////////////////
// Helpers
////////////////////////////////////////////////////////////////////////////////

const isNewAccountNameValid = (newName: string): boolean => (
  newName && newName !== ""
);
