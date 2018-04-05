import { fromJS, Record } from "immutable";

////////////////////////////////////////////////////////////////////////////////
// Action creators
////////////////////////////////////////////////////////////////////////////////

export const showFlash = (message, tone: "info", duration = 3000) => {
  return { type: "SHOW_FLASH", message, tone, duration };
};

const Flash = Record({
  message: null,
  tone: null,
  duration: null
});

////////////////////////////////////////////////////////////////////////////////
// Action reducer
////////////////////////////////////////////////////////////////////////////////

const initialState = fromJS({ messages: {} });

export const flash = (state = initialState, action) => {
  switch (action.type) {
    case "FLASH_ADD": {
      const { message, tone, id } = action;
      const newMessage = new Flash({ message, tone, id });
      return state.setIn(["messages", id], newMessage);
    }

    case "FLASH_REMOVE": {
      const { id } = action;
      return state.removeIn(["messages", id]);
    }
    default:
      return state;
  }
};
