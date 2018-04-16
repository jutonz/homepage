import { all } from "redux-saga/effects";

import teams from "./teams";
import users from "./users";
import flash from "./flash";
import ijust from "./ijust";

export function* rootSaga() {
  yield all([teams(), users(), flash(), ijust()]);
}
