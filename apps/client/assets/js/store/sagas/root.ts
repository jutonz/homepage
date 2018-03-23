import { all } from "redux-saga/effects";
import helloSaga from "./hello";
import accountsSaga from "./accounts";

export function* rootSaga() {
  yield all([
    helloSaga(),
    accountsSaga()
  ]);
}
