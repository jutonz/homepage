////////////////////////////////////////////////////////////////////////////////
// Action creators
////////////////////////////////////////////////////////////////////////////////

const _addFlash = (message, tone, id) => ({
  type: "FLASH_ADD",
  message,
  tone,
  id
});

const _removeFlash = id => ({ type: "FLASH_REMOVE", id });

export const showFlash = (message, tone: "info", duration = 3000) => {
  return dispatch => {
    const id = Math.random().toString();
    dispatch(_addFlash(message, tone, id));

    setTimeout(() => {
      dispatch(_removeFlash(id));
    }, duration);
  };
};

////////////////////////////////////////////////////////////////////////////////
// Action reducer
////////////////////////////////////////////////////////////////////////////////

const initialState = { messages: [] };

export const flash = (state = initialState, action) => {
  let newState;

  switch (action.type) {
    case "FLASH_ADD": {
      const { message, tone, id } = action;
      const newMessage = { message, tone, id };
      newState = {
        messages: [...state.messages, newMessage]
      };
      break;
    }

    case "FLASH_REMOVE": {
      const { id } = action;
      newState = {
        messages: state.messages.filter(msg => msg.id !== id)
      };
      break;
    }

    default: {
      newState = {};
    }
  }

  return { ...state, ...newState };
};
