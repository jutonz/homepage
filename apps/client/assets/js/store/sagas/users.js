import { put, takeEvery } from "redux-saga/effects";
import { fetchUserQuery } from "@store/queries";
import collectGraphqlErrors from "@utils/collectGraphqlErrors";

function* fetchUser({ id }) {
  try {
    yield put({ type: "FETCH_USER_REQUEST", id });
    const response = yield fetchUserQuery({ id });
    yield put({ type: "STORE_USERS", users: [{ id, ...response }] });
    yield put({ type: "FETCH_USER_SUCCESS", id });
  } catch(error) {
    console.error(error);
    const errors = collectGraphqlErrors(error);
    yield put({ type: "FETCH_USER_FAILURE", id, errors });
  }

}

export default function*() {
  yield takeEvery("FETCH_USER", fetchUser);
}
