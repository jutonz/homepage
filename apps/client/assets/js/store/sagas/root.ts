import { all } from "redux-saga/effects";

import flash from "./flash";
import ijust from "./ijust";
import teams from "./teams";
import users from "./users";

export function* rootSaga() {
  yield all([teams(), users(), flash(), ijust()]);
}
