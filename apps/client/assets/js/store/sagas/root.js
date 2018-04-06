import { all } from "redux-saga/effects";

import accounts from "./accounts";
import teams from "./teams";
import flash from "./flash";
import ijust from "./ijust";

export function* rootSaga() {
  yield all([teams(), users(), flash(), ijust()]);
}
