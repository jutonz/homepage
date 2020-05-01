import { put, takeEvery } from "redux-saga/effects";
import { fetchUserQuery, fetchTeamUserQuery } from "@store/queries";
import collectGraphqlErrors from "@utils/collectGraphqlErrors";

function* fetchUser({ id }) {
  try {
    yield put({ type: "FETCH_USER_REQUEST", id });
    const user = yield fetchUserQuery({ id });
    yield put({ type: "STORE_USER", user });
    yield put({ type: "FETCH_USER_SUCCESS", id });
  } catch (error) {
    console.error(error);
    const errors = collectGraphqlErrors(error);
    yield put({ type: "FETCH_USER_FAILURE", id, errors });
  }
}

function* fetchTeamUser({ teamId, userId }) {
  try {
    yield put({ type: "FETCH_TEAM_USER_REQUEST", userId });
    const user = yield fetchTeamUserQuery({ teamId, userId });
    yield put({ type: "STORE_USER", user });
    yield put({ type: "FETCH_TEAM_USER_SUCCESS", userId });
  } catch (error) {
    console.error(error);
    const errors = collectGraphqlErrors(error);
    yield put({ type: "FETCH_TEAM_USER_FAILURE", userId, errors });
  }
}

function* storeUser({ user }) {
  yield put({ type: "STORE_USERS", users: [user] });
}

export default function* () {
  yield takeEvery("FETCH_USER", fetchUser);
  yield takeEvery("STORE_USER", storeUser);
  yield takeEvery("FETCH_TEAM_USER", fetchTeamUser);
}
