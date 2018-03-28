import { combineReducers } from "redux";
import { coffeemaker } from "./reducers/coffeemaker";
import { flash } from "./reducers/flash";
import { accounts } from "./reducers/accounts";
import { session } from "./reducers/session";
import { users } from "./reducers/users";

export * from "./reducers/coffeemaker";
export * from "./reducers/accounts";
export * from "./reducers/flash";
export * from "./reducers/session";

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
  accounts,
  coffeemaker,
  count,
  session,
  flash
});
