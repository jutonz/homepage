import { Action, ActionType, SetCoffeemakerAction } from './../Actions';

export interface CoffeemakerStoreState {
  grounds?: number;
  errorMessage?: string;
}

export const initialState: CoffeemakerStoreState = {};

const groundsForWater = (floz: number): number => {
  const FLOZ_PER_CUP = 6.0;
  const GRAMS_PER_CUP = 10.0;

  const cups = floz / FLOZ_PER_CUP;
  const grams = cups * GRAMS_PER_CUP;

  const rounded = Math.round(grams * 100) / 100;

  return rounded;
};

export const coffeemaker = (state: CoffeemakerStoreState = initialState, action: Action) => {
  let newState: CoffeemakerStoreState;

  switch(action.type) {
    case (ActionType.SetCoffemaker): {
      const floz = (action as SetCoffeemakerAction).floz;
      const grounds = groundsForWater(floz);

      if (isNaN(grounds)) {
        newState = { grounds: null, errorMessage: "Not a number" }
      } else {
        newState = { grounds: grounds, errorMessage: null }
      }

      return { ...state, ...newState };
    }
    default: return state;
  }
};
