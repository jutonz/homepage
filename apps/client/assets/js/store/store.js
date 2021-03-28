import { combineReducers } from "redux";
import { flash } from "./reducers/flash";
import { teams } from "./reducers/teams";
import { session } from "./reducers/session";
import { users } from "./reducers/users";
import { ijust } from "./reducers/ijust";

export * from "./reducers/teams";
export * from "./reducers/flash";
export * from "./reducers/session";
export * from "./reducers/ijust";

////////////////////////////////////////////////////////////////////////////////
// Reducers
////////////////////////////////////////////////////////////////////////////////

export const appStore = combineReducers({
  users,
  teams,
  session,
  flash,
  ijust,
});
