import { put, takeEvery } from "redux-saga/effects";
import collectGraphqlErrors from "@utils/collectGraphqlErrors";
import { deleteAccountMutation } from "@store/mutations";
import { Action } from "@store";

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

export default function* acountsSaga() {
  yield takeEvery("DELETE_ACCOUNT", deleteAccount);
}
