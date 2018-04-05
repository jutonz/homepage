import { fromJS, Record, Map } from "immutable";

const User = Record({
  id: null,
  email: null,
  insertedAt: null,
  updatedAt: null
});

const initialState = { users: {} };
export const users = (state = initialState, action) => {
  let newState;

  switch (action.type) {
    case "STORE_USERS": {
      const { users: usersToAdd } = action;
      state = fromJS(state);
      const users = state.get("users").withMutations(users => {
        usersToAdd.forEach(user => {
          const normal = normalizeUser(user);
          users.set(user.id, user);
        });
      });
      state = state.set("users", users);

      return state.toJS();
    }
    case "FETCH_USER_REQUEST": {
      const { id } = action;
      const user = getUserFromState(id, state);
      state = fromJS(state);
      user = user.withMutations(user => {
        user.delete("fetchErrors").set("isLoading", true);
      });
      user = normalizeUser(user);
      state = state.setIn(["users", id], user);
      return state.toJS();
      break;
    }
    case "FETCH_USER_SUCCESS": {
      const { id } = action;
      const user = getUserFromState(id, state);
      const { isFetching, ...withoutLoading } = user;
      const normal = normalizeUser(withoutLoading);
      newState = { users: { ...state.users, ...normal } };
      break;
    }
    case "FETCH_USER_FAILURE": {
      const { id, errors } = action;
      const user = getUserFromState(id, state);
      const { isFetching, ...withoutLoading } = user;
      const withErrors = { ...withoutLoading, fetchErrors: errors };
      const normal = normalizeUser(withErrors);
      newState = { users: { ...state.users, ...normal } };
      break;
    }
    case "FETCH_ACCOUNT_USER_REQUEST": {
      const { userId } = action;
      let user = getUserFromState(userId, state);
      state = fromJS(state);
      user = user.set("isFetching", true);
      const normal = normalizeUser(withLoading.toJS());
      state = state.setIn(["users", normal.id], normal);
      return state.toJS();
    }
    case "FETCH_ACCOUNT_USER_SUCCESS": {
      const { userId } = action;
      const user = getUserFromState(userId, state);
      const { isFetching, ...withoutLoading } = user;
      const normal = normalizeUser(withoutLoading);
      newState = { users: { ...state.users, ...normal } };
      break;
    }
    case "FETCH_ACCOUNT_USER_FAILURE": {
      const { userId, errors } = action;
      const user = getUserFromState(userId, state);
      const { isFetching, ...withoutLoading } = user;
      const withErrors = { ...withoutLoading, fetchErrors: errors };
      const normal = normalizeUser(withErrors);
      newState = { users: { ...state.users, ...normal } };
      break;
    }
    default:
      newState = {};
      break;
  }

  return { ...state, ...newState };
};

const getUserFromState = (id, state) => {
  let user = state.users[parseInt(id)];
  user = user || { id };
  return new User(user);
};

const normalizeUser = user => {
  let normalized = {};
  normalized[user.id] = user;
  return normalized;
};
