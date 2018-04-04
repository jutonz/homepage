import { put, takeEvery } from "redux-saga/effects";
import { delay } from "redux-saga";

function* showFlash({ message, tone, duration }) {
  const id = Math.random().toString();
  yield put({ type: "FLASH_ADD", message, tone, id });
  yield delay(duration);
  yield put({ type: "FLASH_REMOVE", id });
}

export default function*() {
  yield takeEvery("SHOW_FLASH", showFlash);
}
