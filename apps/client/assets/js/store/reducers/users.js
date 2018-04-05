import { fromJS, Record } from "immutable";

const User = Record({
  id: null,
  email: null,
  insertedAt: null,
  updatedAt: null,

  isFetching: false,
  fetchErrors: null
});

const initialState = fromJS({ users: {} });

export const users = (state = initialState, action) => {
  switch (action.type) {
    case "STORE_USERS": {
      const { users: usersToAdd } = action;
      const users = state.get("users").withMutations(users => {
        usersToAdd.forEach(user => users.set(user.id, user));
      });

      return state.set("users", users);
    }

    case "FETCH_ACCOUNT_USER_REQUEST": {
      const { userId } = action;
      const user = getUserFromState(state, userId).set("isFetching", true);
      return state.setIn(["users", user.get("id")], user);
    }

    case "FETCH_ACCOUNT_USER_SUCCESS": {
      const { userId } = action;
      const user = getUserFromState(state, userId).delete("isFetching");
      return state.setIn(["users", user.get("id")], user);
    }

    case "FETCH_ACCOUNT_USER_FAILURE": {
      const { userId, errors } = action;
      const user = getUserFromState(state, userId).withMutations(user => {
        user.delete("isFetching").set("fetchErrors", errors);
      });
      state = state.setIn(["users", user.get("id")], user);
      return state;
    }

    default:
      return state;
  }
};

const getUserFromState = (state, id) => {
  const user = state.get("users", id) || { id };
  return new User(user);
};
