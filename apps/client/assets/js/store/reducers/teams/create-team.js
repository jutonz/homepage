import { storeTeam } from "./../teams";
import gql from "graphql-tag";

import { urqlClient } from "../../../index.jsx";

////////////////////////////////////////////////////////////////////////////////
// Public action creators
////////////////////////////////////////////////////////////////////////////////

export const setNewTeamName = (newName) => ({
  type: "SET_NEW_TEAM_NAME",
  newName,
});

export const createTeam = (name) => {
  return (dispatch) => {
    dispatch(createTeamRequest());

    const mutation = gql`mutation {
      createTeam(name: "${name}") { name id }
    }`;

    urqlClient
      .mutation(mutation)
      .toPromise()
      .then((response) => {
        const { name, id } = response.data.createTeam;
        const team = { name, id, fetchStatus: "success" };
        dispatch(createTeamSuccess(team));
        dispatch(storeTeam(team));
      })
      .catch((error) => {
        console.log(error);
        const message = error.message.replace("GraphQL error: ", "");
        dispatch(createTeamFailure(message));
      });
  };
};

////////////////////////////////////////////////////////////////////////////////
// Private action creators
////////////////////////////////////////////////////////////////////////////////

const createTeamRequest = () => ({
  type: "CREATE_TEAM_REQUEST",
});

const createTeamSuccess = (team) => ({
  type: "CREATE_TEAM_RECEIVE",
  status: "success",
  team,
});

const createTeamFailure = (error) => ({
  type: "CREATE_TEAM_RECEIVE",
  status: "failure",
  error,
});

////////////////////////////////////////////////////////////////////////////////
// Action reducer
////////////////////////////////////////////////////////////////////////////////

const initialState = { newTeamName: "" };

export const createTeamReducer = (state = initialState, action) => {
  let newState;

  switch (action.type) {
    case "SET_NEW_TEAM_NAME": {
      const newName = action.newName;
      const isValid = isNewTeamNameValid(newName);
      newState = { newTeamName: newName, newTeamNameIsValid: isValid };
      break;
    }
    case "CREATE_TEAM_REQUEST": {
      newState = { creating: true, error: null };
      break;
    }
    case "CREATE_TEAM_RECEIVE": {
      if (action.status === "success") {
        newState = { creating: false, newTeamName: "" };
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
};

////////////////////////////////////////////////////////////////////////////////
// Helpers
////////////////////////////////////////////////////////////////////////////////

const isNewTeamNameValid = (newName) => newName && newName !== "";
