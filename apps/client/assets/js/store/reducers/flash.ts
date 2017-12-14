import { Action, ActionType } from './../Actions';
import { Dispatch } from 'react-redux';

////////////////////////////////////////////////////////////////////////////////
// Store state
////////////////////////////////////////////////////////////////////////////////

export enum FlashTone {
  Info,
  Warning,
  Error,
  Success
}

export interface FlashMessage {
  message: string;
  tone: FlashTone;
  id: string;
}

export interface FlashStoreState {
  messages?: Array<FlashMessage>;
}

////////////////////////////////////////////////////////////////////////////////
// Action definitions
////////////////////////////////////////////////////////////////////////////////

interface FlashAddAction extends Action {
  message: string;
  tone: FlashTone;
  id: string;
}

interface FlashRemoveAction extends Action {
  id: string;
}

////////////////////////////////////////////////////////////////////////////////
// Action creators
////////////////////////////////////////////////////////////////////////////////

const _addFlash = (
  message: string,
  tone: FlashTone,
  id: string
): FlashAddAction => ({
  type: ActionType.FlashAdd,
  message,
  tone,
  id
});

const _removeFlash = (id: string): FlashRemoveAction => ({
  type: ActionType.FlashRemove,
  id
});

export const showFlash = (
  message: string,
  tone: FlashTone = FlashTone.Info,
  duration = 3000
) => {
  return (dispatch: Dispatch<{}>) => {
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

export const flash = (
  state: FlashStoreState = { messages: [] },
  action: Action
) => {
  let newState: Partial<FlashStoreState>;

  switch(action.type) {
    case (ActionType.FlashAdd): {
      const { message, tone, id } = action as FlashAddAction;
      const newMessage: FlashMessage = { message, tone, id };
      newState = {
        messages: [ ...state.messages, newMessage ]
      }
      break;
    }

    case (ActionType.FlashRemove): {
      const { id } = action as FlashRemoveAction;
      newState = {
        messages: state.messages.filter(msg => msg.id !== id)
      }
      break;
    }

    default: {
      newState = {};
    }
  }

  return { ...state, ...newState };
}
