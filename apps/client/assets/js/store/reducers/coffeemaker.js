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
  let newState;

  switch(action.type) {
    case "SET_COFFEEMAKER_FLOZ": {
      const floz = action.floz;
      const grounds = groundsForWater(floz);

      if (isNaN(grounds)) {
        newState = { grams: null, errorMessage: "Floz is not a number" };
      } else {
        newState = { grams: grounds, errorMessage: null };
      }

      return { ...state, ...newState };
    }

    case "SET_COFFEEMAKER_GRAMS": {
      const grams = action.grams;
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
  const floz = (grams / GRAMS_PER_CUP) * FLOZ_PER_CUP;
  return round(floz);
};
