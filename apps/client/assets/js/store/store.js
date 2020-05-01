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

const count = (state = { count: 0 }, action) => {
  let newState;

  switch (action.type) {
    case "INC":
      newState = { count: state.count + 1 };
      break;
    case "DEC":
      newState = { count: Math.max(state.count - 1, 0) };
      break;
    default:
      newState = {};
  }

  return { ...state, ...newState };
};

export const appStore = combineReducers({
  users,
  teams,
  count,
  session,
  flash,
  ijust,
});
