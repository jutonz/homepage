import { all } from "redux-saga/effects";
import accountsSaga from "./accounts";

export function* rootSaga() {
  yield all([
    accountsSaga()
  ]);
}
