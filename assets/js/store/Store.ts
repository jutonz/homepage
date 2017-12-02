import {
  Action,
  ActionType,
  AddCsrfTokenAction,
  SetSessionAction
} from './Actions';

export interface StoreState {
  csrfToken: string;
  count: number;
  sessionAuthenticated?: boolean;
}

const initialState: StoreState = {
  csrfToken: null,
  count: 0
};

export const appStore = (state: StoreState = initialState, action: Action): StoreState => {
  let newState: Partial<StoreState>;

  switch(action.type) {
    case ActionType.Inc: {
      newState = { count: state.count + 1 };
      return { ...state, ...newState };
    }

    case ActionType.Dec: {
      const newCount = state.count - 1;
      newState = { count: Math.max(newCount, 0) };
      return { ...state, ...newState };
    }

    case ActionType.AddCsrfToken: {
      newState = { csrfToken: (action as AddCsrfTokenAction).token };
      return { ...state, ...newState };
    }

    case ActionType.SetSession: {
      newState = { sessionAuthenticated: (action as SetSessionAction).established};
      return { ...state, ...newState };
    }

    default: return state;
  }
};
