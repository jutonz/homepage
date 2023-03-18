import { all } from "redux-saga/effects";

import flash from "./flash";
import users from "./users";

export function* rootSaga() {
  yield all([users(), flash()]);
}
