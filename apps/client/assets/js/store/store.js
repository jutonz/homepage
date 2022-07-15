import { combineReducers } from "redux";
import { flash } from "./reducers/flash";
import { teams } from "./reducers/teams";
import { users } from "./reducers/users";
import { ijust } from "./reducers/ijust";

export * from "./reducers/teams";
export * from "./reducers/flash";
export * from "./reducers/ijust";

////////////////////////////////////////////////////////////////////////////////
// Reducers
////////////////////////////////////////////////////////////////////////////////

export const appStore = combineReducers({
  users,
  teams,
  flash,
  ijust,
});
