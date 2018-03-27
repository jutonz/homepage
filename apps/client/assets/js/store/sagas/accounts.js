import { put, takeEvery } from "redux-saga/effects";
import collectGraphqlErrors from "@utils/collectGraphqlErrors";
import { deleteAccountMutation, renameAccountMutation } from "@store/mutations";
import { Action, showFlash } from "@store";

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

export default function* acountsSaga() {
  yield takeEvery("DELETE_ACCOUNT", deleteAccount);
  yield takeEvery("RENAME_ACCOUNT", renameAccount);
}
