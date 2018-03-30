const initialState = { users: {} };
export const users = (state = initialState, action) => {
  let newState;

  switch (action.type) {
    case "STORE_USERS": {
      const { users } = action;
      let newUsers = {};
      users.forEach(user => {
        newUsers = { ...newUsers, ...normalizeUser(user) };
      });
      newState = { users: { ...state.users, ...newUsers } };
      break;
    }
    case "FETCH_USER_REQUEST": {
      const { id } = action;
      const user = getUserFromState(id, state);
      const { fetchErrors, ...withoutErrors } = user;
      const withLoading = { ...withoutErrors, id, isFetching: true };
      const normal = normalizeUser(withLoading);
      newState = { users: { ...state.users, ...normal } };
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
      const user = getUserFromState(userId, state);
      const withLoading = { ...user, isFetching: true };
      const normal = normalizeUser(withLoading);
      newState = { users: { ...state.users, ...normal } };
      break;
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
  const user = state.users[parseInt(id)];
  return user || { id };
};

const normalizeUser = user => {
  let normalized = {};
  normalized[user.id] = user;
  return normalized;
};
