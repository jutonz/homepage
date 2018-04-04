import { Map } from "immutable";

////////////////////////////////////////////////////////////////////////////////
// Action creators
////////////////////////////////////////////////////////////////////////////////

export const setCoffeemakerFlozAction = floz => ({
  type: "SET_COFFEEMAKER_FLOZ",
  floz: floz
});

export const setCoffeemakerGramsAction = grams => ({
  type: "SET_COFFEEMAKER_GRAMS",
  grams
});

////////////////////////////////////////////////////////////////////////////////
// Action reducer
////////////////////////////////////////////////////////////////////////////////

export const initialState = {};
export const coffeemaker = (state = initialState, action) => {
  state = Map(state);

  switch (action.type) {
    case "SET_COFFEEMAKER_FLOZ": {
      const { floz } = action;
      const grounds = groundsForWater(floz);

      if (isNaN(grounds)) {
        state = state
          .set("errorMessage", "Floz is not a number")
          .delete("grams");
      } else {
        state = state.set("grams", grounds).delete("errorMessage");
      }

      break;
    }

    case "SET_COFFEEMAKER_GRAMS": {
      const { grams } = action;
      const floz = flozForGrams(grams);

      if (isNaN(floz)) {
        state = state
          .set("errorMesssage", "Grams is not a number")
          .delete("floz");
      } else {
        state = state.set("floz", floz).delete("erroMessage");
      }

      break;
    }
  }

  return state;
};

////////////////////////////////////////////////////////////////////////////////
// Helpers
////////////////////////////////////////////////////////////////////////////////

const FLOZ_PER_CUP = 6.0;
const GRAMS_PER_CUP = 10.0;

const round = a => Math.round(a * 100) / 100;

const groundsForWater = floz => {
  const cups = floz / FLOZ_PER_CUP;
  const grams = cups * GRAMS_PER_CUP;
  return round(grams);
};

// grams = cups * GRAMS_PER_CUP
// grams = (floz / FLOZ_PER_CUP) * GRAMS_PER_CUP
// grams / GRAMS_PER_CUP = floz / FLOZ_PER_CUP
// (grams / GRAMS_PER_CUP) * FLOZ_PER_CUP = floz
// floz = (grams / GRAMS_PER_CUP) * FLOZ_PER_CUP

const flozForGrams = grams => {
  const floz = grams / GRAMS_PER_CUP * FLOZ_PER_CUP;
  return round(floz);
};
