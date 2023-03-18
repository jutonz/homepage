import { combineReducers } from "redux";
import { flash } from "./reducers/flash";
import { users } from "./reducers/users";
import { ijust } from "./reducers/ijust";

export * from "./reducers/flash";
export * from "./reducers/ijust";

////////////////////////////////////////////////////////////////////////////////
// Reducers
////////////////////////////////////////////////////////////////////////////////

export const appStore = combineReducers({
  users,
  flash,
  ijust,
});
