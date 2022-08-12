import gql from "graphql-tag";
export * from "./teams/create-team";
import { createTeamReducer } from "./teams/create-team";
import { urqlClient } from "../../index.jsx";

////////////////////////////////////////////////////////////////////////////////
// Public action creators
////////////////////////////////////////////////////////////////////////////////

export const fetchTeam = (id) => {
  return (dispatch, getState) => {
    const state = getState();
    const existing = state.teams.teams[id];

    if (existing) {
      const fetchAction = teamFetchAction("success", existing);
      return Promise.resolve(dispatch(fetchAction));
    } else {
      const team = { id, fetchStatus: "in_progress" };
      dispatch(teamFetchAction("in_progress", team));

      const query = gql`
        query GetTeam($id: ID!) {
          getTeam(id: $id) {
            name
            id
          }
        }
      `;
      const variables = { id };

      return urqlClient
        .query(query, variables)
        .toPromise()
        .then((response) => {
          const team = {
            ...response.data.getTeam,
            ...{ fetchStatus: "success" },
          };
          return dispatch(teamFetchAction("success", team));
        })
        .catch((error) => {
          console.error(error);
          const graphQLErrors = error.graphQLErrors;
          const errors = graphQLErrors.map((error) => error.message);
          const team = {
            id,
            errors,
            fetchStatus: "failure",
          };
          return dispatch(teamFetchAction("failure", team));
        });
    }
  };
};

export const fetchTeams = () => {
  return (dispatch) => {
    dispatch(requestTeams());

    const query = gql`
      query GetTeams {
        getTeams {
          name
          id
        }
      }
    `;

    urqlClient
      .query(query)
      .toPromise()
      .then((response) => {
        const rawTeams = response.data.getTeams;
        const teams = {};
        rawTeams.forEach((raw) => {
          const { id, name } = raw;
          const team = { id, name, fetchStatus: "success" };
          teams[id] = team;
        });
        dispatch(receiveTeamsSuccess(teams));
      })
      .catch((error) => {
        console.error(error);
        const message = error.message.replace("GraphQL error: ", "");
        dispatch(receiveTeamsError(message));
      });
  };
};

export const storeTeam = (team) => ({
  type: "STORE_TEAM",
  team,
});

////////////////////////////////////////////////////////////////////////////////
// Private action creators
////////////////////////////////////////////////////////////////////////////////

const teamFetchAction = (status, team) => ({
  type: "TEAM_FETCH",
  status,
  team,
});

const requestTeams = () => ({
  type: "TEAMS_REQUEST",
});

const receiveTeamsSuccess = (teams) => ({
  type: "TEAMS_RECEIVE",
  status: "success",
  teams,
});

const receiveTeamsError = (error) => ({
  type: "TEAMS_RECEIVE",
  status: "error",
  error,
});

////////////////////////////////////////////////////////////////////////////////
// Action reducer
////////////////////////////////////////////////////////////////////////////////

const initialState = { teams: {} };
export const teams = (state = initialState, action) => {
  let newState;

  switch (action.type) {
    case "TEAM_FETCH":
      newState = handleTeamFetchAction(state, action);
      break;
    case "TEAMS_REQUEST":
      newState = { loadingAllTeams: true };
      break;
    case "TEAMS_RECEIVE": {
      if (action.status === "success") {
        const { teams } = action;
        newState = { loadingAllTeams: false, teams };
      } else {
        const { error } = action;
        newState = { loadingAllTeams: false, teamsFetchError: error };
      }
      break;
    }
    case "STORE_TEAM": {
      const { team } = action;
      const withFetchStatus = { ...team, fetchStatus: "success" };
      const normal = normalizeTeam(withFetchStatus);
      newState = { teams: { ...state.teams, ...normal } };
      break;
    }
    case "UNSTORE_TEAM": {
      const { [action.id]: _removed, ...teams } = state.teams;
      newState = { teams };
      break;
    }
    case "DELETE_TEAM_REQUEST": {
      const { id } = action;
      const original = state.teams[parseInt(id)];
      const team = normalizeTeam({
        ...original,
        deleting: true,
        deleteErrors: undefined,
      });
      newState = { teams: { ...state.teams, ...team } };
      break;
    }
    case "DELETE_TEAM_SUCCESS": {
      const { id } = action;
      const original = state.teams[parseInt(id)];
      const team = normalizeTeam({
        ...original,
        deleting: false,
      });
      newState = { teams: { ...state.teams, ...team } };
      break;
    }
    case "DELETE_TEAM_FAILURE": {
      const { errors, id } = action;
      const team = state.teams[parseInt(id)];
      const withError = normalizeTeam({
        ...team,
        deleteErrors: errors,
        deleting: false,
      });
      newState = { teams: { ...state.teams, ...withError } };
      break;
    }
    case "SET_TEAM_RENAME_NAME": {
      const { name, id } = action;
      const team = state.teams[parseInt(id)];
      const withRenameName = { ...team, renameName: name };
      const normal = normalizeTeam(withRenameName);
      newState = { teams: { ...state.teams, ...normal } };
      break;
    }
    case "TEAM_RENAME_REQUEST": {
      const { id } = action;
      const team = state.teams[parseInt(id)];
      const { renameErrors, ...withoutErrors } = team;
      const withLoading = { ...withoutErrors, isRenaming: true };
      const normal = normalizeTeam(withLoading);
      newState = { teams: { ...state.teams, ...normal } };
      break;
    }
    case "TEAM_RENAME_SUCCESS": {
      const { id, name } = action;
      const team = state.teams[parseInt(id)];
      const { isRenaming, renameName, ...withoutLoading } = team;
      const withNewName = { ...withoutLoading, name };
      const normal = normalizeTeam(withNewName);
      newState = { teams: { ...state.teams, ...normal } };
      break;
    }
    case "TEAM_RENAME_FAILURE": {
      const { id, errors } = action;
      const team = state.teams[parseInt(id)];
      const { isRenaming, ...withoutLoading } = team;
      const withErrors = { ...withoutLoading, renameErrors: errors };
      const normal = normalizeTeam(withErrors);
      newState = { teams: { ...state.teams, ...normal } };
      break;
    }
    case "FETCH_TEAM_USERS_REQUEST": {
      const { id } = action;
      const team = state.teams[parseInt(id)];
      const withLoading = { ...team, isLoadingUsers: true };
      const normal = normalizeTeam(withLoading);
      newState = { teams: { ...state.teams, ...normal } };
      break;
    }
    case "FETCH_TEAM_USERS_SUCCESS": {
      const { id, userIds } = action;
      const team = state.teams[parseInt(id)];
      const { isLoadingUsers, ...withoutLoading } = team;
      const withUserIds = { ...withoutLoading, userIds };
      const normal = normalizeTeam(withUserIds);
      newState = { teams: { ...state.teams, ...normal } };
      break;
    }
    case "FETCH_TEAM_USERS_FAILURE": {
      const { id, errors } = action;
      const team = state.teams[parseInt(id)];
      const { isLoadingUsers, ...withoutLoading } = team;
      const withErrors = { ...withoutLoading, loadUsersErrors: errors };
      const normal = normalizeTeam(withErrors);
      newState = { teams: { ...state.teams, ...normal } };
      break;
    }
    case "SET_JOIN_TEAM_NAME": {
      const { name } = action;
      newState = { ...state, joinTeamName: name };
      break;
    }
    case "JOIN_TEAM_REQUEST": {
      const { joinTeamErrors, ...withoutErrors } = state;
      newState = { ...withoutErrors, joiningTeam: true };
      break;
    }
    case "JOIN_TEAM_SUCCESS": {
      newState = { joiningTeam: false, joinTeamName: null };
      break;
    }
    case "JOIN_TEAM_FAILURE": {
      const { errors } = action;
      newState = { joiningTeam: false, joinTeamErrors: errors };
      break;
    }
    case "LEAVE_TEAM_REQUEST": {
      newState = { leavingTeam: true, leavingTeamErrors: null };
      break;
    }
    case "LEAVE_TEAM_SUCCESS": {
      newState = { leavingTeam: false };
      break;
    }
    case "LEAVE_TEAM_FAILURE": {
      const { errors } = action;
      newState = { leavingTeam: false, leavingTeamErrors: errors };
      break;
    }
  }

  // Handle child reducers
  state.createTeam = createTeamReducer(state.createTeam, action);

  return { ...state, ...newState };
};

////////////////////////////////////////////////////////////////////////////////
// Helpers
////////////////////////////////////////////////////////////////////////////////

const handleTeamFetchAction = (state, action) => {
  let newState = {};

  switch (action.status) {
    case "in_progress": {
      const fetchStatus = "in_progress";
      const team = { ...action.team, ...{ errors: null, fetchStatus } };
      const normaliedTeam = normalizeTeam(team);
      newState = {
        teams: { ...state.teams, ...normaliedTeam },
      };
      break;
    }
    case "success": {
      const fetchStatus = "success";
      const newTeam = normalizeTeam({
        ...action.team,
        ...{ fetchStatus },
      });
      const teams = { ...state.teams, ...newTeam };
      newState = { teams };
      break;
    }
    case "failure": {
      const newTeam = normalizeTeam(action.team);
      const teams = { ...state.teams, ...newTeam };
      newState = { teams };
      break;
    }
    default:
      const errors = { errors: [`Unhandled FetchStatus ${action.status}`] };
      const team = normalizeTeam({ ...action.team, ...errors });
      newState = { teams: { ...state.teams, ...team } };
      break;
  }

  return newState;
};

const normalizeTeam = (team) => {
  let normalized = {};
  normalized[team.id] = team;
  return normalized;
};
