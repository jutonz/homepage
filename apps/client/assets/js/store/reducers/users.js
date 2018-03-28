const initialState = {};
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
    default:
      newState = {};
      break;
  }

  return { ...state, ...newState };
};

const normalizeUser = user => {
  let normalized = {};
  normalized[user.id] = user;
  return normalized;
};
