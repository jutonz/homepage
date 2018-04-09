import { put, takeEvery } from "redux-saga/effects";
import collectGraphqlErrors from "@utils/collectGraphqlErrors";
import { showFlash } from "@store";
import {
  deleteTeamMutation,
  renameTeamMutation,
  joinTeamMutation,
  leaveTeamMutation
} from "@store/mutations";
import { fetchTeamUsersQuery } from "@store/queries";

function* deleteTeam({ id, resolve, reject }) {
  try {
    yield put({ type: "DELETE_TEAM_REQUEST", id });
    const response = yield deleteTeamMutation({ id });
    yield put({ type: "DELETE_TEAM_SUCCESS", id, response });
    yield put({ type: "UNSTORE_TEAM", id });
    if (resolve) {
      resolve(response);
    }
  } catch (error) {
    console.error(error);
    const errors = collectGraphqlErrors(error);
    yield put({ type: "DELETE_TEAM_FAILURE", id, errors });
    if (reject) {
      reject(errors);
    }
  }
}

function* renameTeam({ id, name, flash = true }) {
  try {
    yield put({ type: "TEAM_RENAME_REQUEST", id });
    const response = yield renameTeamMutation({ id, name });
    yield put({ type: "TEAM_RENAME_SUCCESS", id, ...response });
    if (flash) {
      yield put(showFlash("Team rename successful", "success"));
    }
  } catch (error) {
    console.error(error);
    const errors = collectGraphqlErrors(error);
    yield put({ type: "TEAM_RENAME_FAILURE", id, errors });
  }
}

function* fetchTeamUsers({ id }) {
  try {
    yield put({ type: "FETCH_TEAM_USERS_REQUEST", id });
    const users = yield fetchTeamUsersQuery({ id });
    yield put({ type: "STORE_USERS", users });
    const userIds = users.map(user => user.id);
    yield put({ type: "FETCH_TEAM_USERS_SUCCESS", id, userIds });
  } catch (error) {
    console.error(error);
    const errors = collectGraphqlErrors(error);
    yield put({ type: "FETCH_TEAM_USERS_FAILURE", id, errors });
  }
}

function* joinTeam({ name, history }) {
  try {
    yield put({ type: "JOIN_TEAM_REQUEST" });
    const team = yield joinTeamMutation({ name });
    yield put({ type: "STORE_TEAM", team });
    yield put({ type: "JOIN_TEAM_SUCCESS", team });
    history.push(`/teams/${team.id}`);
    yield put(showFlash("Successfully joined team", "success"));
  } catch (error) {
    console.error(error);
    const errors = collectGraphqlErrors(error);
    yield put({ type: "JOIN_TEAM_FAILURE", errors });
  }
}

function* leaveTeam({ id, history }) {
  try {
    yield put({ type: "LEAVE_TEAM_REQUEST" });
    yield leaveTeamMutation({ id });
    yield put({ type: "UNSTORE_TEAM", id });
    yield put({ type: "LEAVE_TEAM_SUCCESS", id });
    history.push("/settings");
    yield put(showFlash("Successfully left team", "success"));
  } catch (errors) {
    yield put({ type: "LEAVE_TEAM_FAILURE", errors });
  }
}

export default function* acountsSaga() {
  yield takeEvery("DELETE_TEAM", deleteTeam);
  yield takeEvery("RENAME_TEAM", renameTeam);
  yield takeEvery("FETCH_TEAM_USERS", fetchTeamUsers);
  yield takeEvery("JOIN_TEAM", joinTeam);
  yield takeEvery("LEAVE_TEAM", leaveTeam);
}
