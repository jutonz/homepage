import { all } from "redux-saga/effects";
import accountsSaga from "./accounts";
import usersSaga from "./users";
import flashSaga from "./flash";

export function* rootSaga() {
  yield all([accountsSaga(), usersSaga(), flashSaga()]);
}
