import { IjustRecentEvent } from "@components/ijust/IjustRecentEvent";

import { Header, Loader } from "semantic-ui-react";
import { connect } from "react-redux";
import React from "react";

const _IjustRecentEvents = ({
  context,
  fetchEvents,
  isLoading,
  errors,
  recentEvents
}) => {
  if (!recentEvents && !isLoading && !errors) {
    fetchEvents(context.id);
  }

  return (
    <div>
      <Header>Recent events</Header>
      {errors}
      <Loader active={isLoading} inline />
      {recentEvents &&
        recentEvents.map(ev => <IjustRecentEvent key={ev.id} event={ev} />)}
    </div>
  );
};

const extractRecentEvents = (state, contextId) => {
  const ids = state.ijust.getIn(["contexts", contextId, "recentEventIds"]);
  if (!ids || ids.size === 0) {
    return;
  }
  return ids.map(id => {
    return state.ijust.getIn(["events", id]);
  });
};

export const IjustRecentEvents = connect(
  (state, props) => ({
    recentEvents: extractRecentEvents(state, props.context.id),
    isLoading: state.ijust.get("isLoadingRecentEvents"),
    errors: state.ijust.get("loadRecentEventsErrors")
  }),
  dispatch => ({
    fetchEvents: contextId =>
      dispatch({ type: "IJUST_FETCH_RECENT_EVENTS", contextId })
  })
)(_IjustRecentEvents);
