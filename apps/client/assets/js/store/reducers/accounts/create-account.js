import { storeAccount } from "./../accounts";
import gql from "graphql-tag";

////////////////////////////////////////////////////////////////////////////////
// Public action creators
////////////////////////////////////////////////////////////////////////////////

export const setNewAccountName = (newName) => ({
  type: "SET_NEW_ACCOUNT_NAME",
  newName
});

export const createAccount = (name) => {
  return (dispatch) => {
    dispatch(createAccountRequest());

    const mutation = gql`mutation {
      createAccount(name: "${name}") { name id }
    }`;

    window.grapqlClient.mutate({ mutation }).then((response) => {
      const { name, id } = response.data.createAccount;
      const account = { name, id, fetchStatus: "success" };
      dispatch(createAccountSuccess(account));
      dispatch(storeAccount(account));
    }).catch((error) => {
      console.log(error);
      const message = error.message.replace("GraphQL error: ", "");
      dispatch(createAccountFailure(message));
    });
  };
};

////////////////////////////////////////////////////////////////////////////////
// Private action creators
////////////////////////////////////////////////////////////////////////////////

const createAccountRequest = () => ({
  type: "CREATE_ACCOUNT_REQUEST"
});

const createAccountSuccess = (account) => ({
  type: "CREATE_ACCOUNT_RECEIVE",
  status: "success",
  account
});

const createAccountFailure = (error) => ({
  type: "CREATE_ACCOUNT_RECEIVE",
  status: "failure",
  error
});

////////////////////////////////////////////////////////////////////////////////
// Action reducer
////////////////////////////////////////////////////////////////////////////////

const initialState = { newAccountName: "" };

export const createAccountReducer = (state = initialState, action) => {
  let newState;;

  switch(action.type) {
    case "SET_NEW_ACCOUNT_NAME": {
      const newName = action.newName;
      const isValid = isNewAccountNameValid(newName);
      newState = { newAccountName: newName, newAccountNameIsValid: isValid };
      break;
    }
    case "CREATE_ACCOUNT_REQUEST": {
      newState = { creating: true, error: null }
      break;
    }
    case "CREATE_ACCOUNT_RECEIVE": {
      if (action.status === "success") {
        newState = { creating: false, newAccountName: "" };
      } else {
        const { error } = action;
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

const isNewAccountNameValid = newName => (newName && newName !== "");
