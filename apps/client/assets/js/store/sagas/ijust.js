import { put, takeEvery } from "redux-saga/effects";
import { getIjustContextQuery } from "@store/queries";

function* fetchContext() {
  try {
    yield put({ type: "FETCH_IJUST_CONTEXT_REQUEST" });
    const context = yield getIjustContextQuery();
    yield put({ type: "FETCH_IJUST_CONTEXT_SUCCESS", context });
  } catch(errors) {
    yield put({ type: "FETCH_IJUST_CONTEXT_FAILURE", errors });
  }
}

export default function*() {
  yield takeEvery("FETCH_IJUST_CONTEXT", fetchContext);
}
