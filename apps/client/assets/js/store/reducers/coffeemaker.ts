import { Action, ActionType } from './../Actions';

////////////////////////////////////////////////////////////////////////////////
// Store state
////////////////////////////////////////////////////////////////////////////////

export interface CoffeemakerStoreState {
  grams?: number;
  floz?: number;
  errorMessage?: string;
}

export const initialState: CoffeemakerStoreState = {};

////////////////////////////////////////////////////////////////////////////////
// Action definitions
////////////////////////////////////////////////////////////////////////////////

export interface SetCoffeemakerFlozAction extends Action {
  floz: number;
}

export interface SetCoffeemakerGramsAction extends Action {
  grams: number;
}

////////////////////////////////////////////////////////////////////////////////
// Action creators
////////////////////////////////////////////////////////////////////////////////

export const setCoffeemakerFlozAction = (floz: number): SetCoffeemakerFlozAction => ({
  type: ActionType.SetCoffemakerFloz,
  floz: floz
});

export const setCoffeemakerGramsAction = (g: number): SetCoffeemakerGramsAction => ({
  type: ActionType.SetCoffeemakerGrams,
  grams: g
});

////////////////////////////////////////////////////////////////////////////////
// Action reducer
////////////////////////////////////////////////////////////////////////////////

export const coffeemaker = (state: CoffeemakerStoreState = initialState, action: Action) => {
  let newState: CoffeemakerStoreState;

  switch(action.type) {
    case (ActionType.SetCoffemakerFloz): {
      const floz = (action as SetCoffeemakerFlozAction).floz;
      const grounds = groundsForWater(floz);

      if (isNaN(grounds)) {
        newState = { grams: null, errorMessage: "Floz is not a number" };
      } else {
        newState = { grams: grounds, errorMessage: null };
      }

      return { ...state, ...newState };
    }

    case (ActionType.SetCoffeemakerGrams): {
      const grams = (action as SetCoffeemakerGramsAction).grams;
      const floz = flozForGrams(grams);

      if (isNaN(floz)) {
        newState = { floz: null, errorMessage: "Grams is not a number" };
      } else {
        newState = { floz: floz, errorMessage: null };
      }

      return { ...state, ...newState };
    }

    default: return state;
  }
};

////////////////////////////////////////////////////////////////////////////////
// Helpers
////////////////////////////////////////////////////////////////////////////////

const FLOZ_PER_CUP = 6.0;
const GRAMS_PER_CUP = 10.0;

const round = (a: number) => Math.round(a * 100) / 100;

const groundsForWater = (floz: number): number => {
  const cups = floz / FLOZ_PER_CUP;
  const grams = cups * GRAMS_PER_CUP;
  return round(grams);
};

// grams = cups * GRAMS_PER_CUP
// grams = (floz / FLOZ_PER_CUP) * GRAMS_PER_CUP
// grams / GRAMS_PER_CUP = floz / FLOZ_PER_CUP
// (grams / GRAMS_PER_CUP) * FLOZ_PER_CUP = floz
// floz = (grams / GRAMS_PER_CUP) * FLOZ_PER_CUP

const flozForGrams = (grams: number) => {
  const floz = (grams / GRAMS_PER_CUP) * FLOZ_PER_CUP;
  return round(floz);
};
