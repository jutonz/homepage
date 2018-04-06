import { fromJS } from "immutable";

const initialState = fromJS({});
export const ijust = (state = initialState, action) => {
  switch(action.type) {
    case "FETCH_IJUST_CONTEXT_REQUEST": {
      return state.set("fetchingContext", true);
    }
    case "FETCH_IJUST_CONTEXT_SUCCESS": {
      const { context } = action;
      return state.withMutations(state => {
        state.delete("fetchingContext").set("context", context);
      });
    }
    case "FETCH_IJUST_CONTEXT_FAILURE": {
      const { errors } = action;
      return state.withMutations(state => {
        state.delete("fetchingContext").set("fetchErrors", errors);
      });
    }
    default:
      return state;
  }
}
