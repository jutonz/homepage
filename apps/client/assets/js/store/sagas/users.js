import { put, takeEvery } from "redux-saga/effects";
import { fetchUserQuery } from "./../queries";
import collectGraphqlErrors from "./../../utils/collectGraphqlErrors";

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

function* storeUser({ user }) {
  yield put({ type: "STORE_USERS", users: [user] });
}

export default function* () {
  yield takeEvery("FETCH_USER", fetchUser);
  yield takeEvery("STORE_USER", storeUser);
}
