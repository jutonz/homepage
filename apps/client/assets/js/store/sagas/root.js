import { all } from "redux-saga/effects";
import accountsSaga from "./accounts";
import usersSaga from "./users";

export function* rootSaga() {
  yield all([accountsSaga(), usersSaga()]);
}
