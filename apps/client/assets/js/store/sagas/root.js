import { all } from "redux-saga/effects";
import teamsSaga from "./teams";
import usersSaga from "./users";
import flashSaga from "./flash";

export function* rootSaga() {
  yield all([teamsSaga(), usersSaga(), flashSaga()]);
}
