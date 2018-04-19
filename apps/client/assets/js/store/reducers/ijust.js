import { fromJS, List, Record } from "immutable";

const Context = Record({
  name: null,
  id: null,
  eventIds: List(),
  recentEventIds: List()
});

const initialState = fromJS({});
export const ijust = (state = initialState, action) => {
  switch (action.type) {
    case "IJUST_STORE_CONTEXT": {
      const { context } = action;
      return state.setIn(["contexts", context.id], new Context(context));
    }

    case "IJUST_FETCH_DEFAULT_CONTEXT_REQUEST": {
      return state.withMutations(state => {
        state
          .delete("fetchDefualtContextErrors")
          .set("isFetchingDefaultContext", true);
      });
    }

    case "IJUST_FETCH_DEFAULT_CONTEXT_SUCCESS": {
      const { context } = action;
      return state.withMutations(state => {
        state
          .delete("isFetchingDefaultContext")
          .set("defaultContextId", context.id);
      });
    }

    case "IJUST_FETCH_DEFAULT_CONTEXT_FAILURE": {
      const { errors } = action;
      return state.withMutations(state => {
        state
          .delete("isFetchingDefaultContext")
          .set("fetchDefaultContextErrors", errors);
      });
    }

    case "IJUST_FETCH_CONTEXT_REQUEST": {
      const { contextId } = action;
      return state.setIn(["contexts", contextId, "isFetching"], true);
    }

    case "IJUST_FETCH_CONTEXT_SUCCESS": {
      const { context } = action;
      return state.withMutations(state => {
        state.deleteIn(["contexts", context.id, "isFetching"]);
        //state.delete("fetchingContext").set("context", context);
      });
    }

    case "IJUST_FETCH_CONTEXT_FAILURE": {
      const { errors, id } = action;
      return state.withMutations(state => {
        state
          .deleteIn(["contexts", id, "isFetching"])
          .setIn(["contexts", id, "fetchErrors"], errors);
      });
    }

    case "SET_IJUST_NEW_EVENT_NAME": {
      const { name } = action;
      return state.set("newEventName", name);
    }

    case "IJUST_STORE_EVENTS": {
      const { events } = action;
      return state.withMutations(state => {
        events.forEach(ev => {
          state.setIn(["events", ev.id], ev);

          const contextId = ev.ijustContextId;
          let eventIds = state.getIn(["contexts", contextId, "eventIds"]);
          eventIds = (eventIds || List()).push(ev.id);
          state.setIn(["contexts", contextId, "eventIds"], eventIds);
        });
      });
    }

    case "IJUST_CREATE_EVENT_REQUEST": {
      return state.withMutations(state => {
        state.set("creatingEvent", true).delete("createErrors");
      });
    }

    case "IJUST_CREATE_EVENT_SUCCESS": {
      return state.withMutations(state => {
        state.delete("creatingEvent");
      });
    }

    case "IJUST_CREATE_EVENT_FAILURE": {
      const { errors } = action;
      return state.withMutations(state => {
        state.delete("creatingEvent").set("createErrors", errors);
      });
    }

    case "IJUST_FETCH_RECENT_EVENTS_REQUEST": {
      const { contextId } = action;
      return state.withMutations(state => {
        state
          .delete("loadRecentEventsErrors")
          .deleteIn(["contexts", contextId, "recentEventIds"])
          .set("isLoadingRecentEvents", true);
      });
    }

    case "IJUST_FETCH_RECENT_EVENTS_SUCCESS": {
      const { contextId, eventIds } = action;
      return state.withMutations(state => {
        state
          .delete("isLoadingRecentEvents")
          .setIn(["contexts", contextId, "recentEventIds"], eventIds);
      });
    }

    case "IJUST_FETCH_RECENT_EVENTS_FAILURE": {
      const { errors } = action;
      return state.withMutations(state => {
        state
          .delete("isLoadingRecentEvents")
          .set("loadRecentEventsErrors", errors);
      });
    }

    default:
      return state;
  }
};
