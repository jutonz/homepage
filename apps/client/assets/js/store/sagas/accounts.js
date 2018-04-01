import { put, takeEvery } from "redux-saga/effects";
import collectGraphqlErrors from "@utils/collectGraphqlErrors";
import { showFlash } from "@store";
import {
  deleteAccountMutation,
  renameAccountMutation,
  joinAccountMutation
} from "@store/mutations";
import { fetchAccountUsersQuery } from "@store/queries";

function* deleteAccount({ id, resolve, reject }) {
  try {
    yield put({ type: "DELETE_ACCOUNT_REQUEST", id });
    const response = yield deleteAccountMutation({ id });
    yield put({ type: "DELETE_ACCOUNT_SUCCESS", id, response });
    yield put({ type: "UNSTORE_ACCOUNT", id });
    if (resolve) {
      resolve(response);
    }
  } catch (error) {
    console.error(error);
    const errors = collectGraphqlErrors(error);
    yield put({ type: "DELETE_ACCOUNT_FAILURE", id, errors });
    if (reject) {
      reject(errors);
    }
  }
}

function* renameAccount({ id, name, flash = true }) {
  try {
    yield put({ type: "ACCOUNT_RENAME_REQUEST", id });
    const response = yield renameAccountMutation({ id, name });
    yield put({ type: "ACCOUNT_RENAME_SUCCESS", id, ...response });
    if (flash) {
      yield put(showFlash("Account rename successful", "success"));
    }
  } catch (error) {
    console.error(error);
    const errors = collectGraphqlErrors(error);
    yield put({ type: "ACCOUNT_RENAME_FAILURE", id, errors });
  }
}

function* fetchAccountUsers({ id }) {
  try {
    yield put({ type: "FETCH_ACCOUNT_USERS_REQUEST", id });
    const users = yield fetchAccountUsersQuery({ id });
    yield put({ type: "STORE_USERS", users });
    const userIds = users.map(user => user.id);
    yield put({ type: "FETCH_ACCOUNT_USERS_SUCCESS", id, userIds });
  } catch (error) {
    console.error(error);
    const errors = collectGraphqlErrors(error);
    yield put({ type: "FETCH_ACCOUNT_USERS_FAILURE", id, errors });
  }
}

function* joinAccount({ name }) {
  try {
    yield put({ type: "JOIN_ACCOUNT_REQUEST" });
    const account = yield joinAccountMutation({ name });
    yield put({ type: "STORE_ACCOUNT", account });
    yield put({ type: "JOIN_ACCOUNT_SUCCESS", account });
    yield put(showFlash("Successfully joined account", "success"));
  } catch (error) {
    console.error(error);
    const errors = collectGraphqlErrors(error);
    yield put({ type: "JOIN_ACCOUNT_FAILURE", errors });
  }
}

export default function* acountsSaga() {
  yield takeEvery("DELETE_ACCOUNT", deleteAccount);
  yield takeEvery("RENAME_ACCOUNT", renameAccount);
  yield takeEvery("FETCH_ACCOUNT_USERS", fetchAccountUsers);
  yield takeEvery("JOIN_ACCOUNT", joinAccount);
}
