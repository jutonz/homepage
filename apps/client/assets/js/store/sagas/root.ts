import { all } from "redux-saga/effects";

import users from "./users";

export function* rootSaga() {
  yield all([users()]);
}
