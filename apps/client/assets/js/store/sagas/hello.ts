import { delay } from "redux-saga";
import { put, takeEvery } from "redux-saga/effects";

function* hello() {
  console.warn("hey");
  yield true;
}

function* helloAsync() {
  yield delay(1000);
  yield put({ type: "HELLO" });
}

export default function* helloSaga() {
  yield takeEvery("HELLO", hello);
  yield takeEvery("HELLO_ASYNC", helloAsync);
}
