////////////////////////////////////////////////////////////////////////////////
// Reducer
////////////////////////////////////////////////////////////////////////////////

const initialState = {};

export const session = (state = initialState, action) => {
  let newState;

  switch (action.type) {
    case "SET_SESSION_ESTABLISHED":
      newState = { established: action.established };
      break;
    default:
      newState = {};
      break;
  }

  return { ...state, ...newState };
};
