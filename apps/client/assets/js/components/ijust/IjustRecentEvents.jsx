import { Header, Loader, Table } from "semantic-ui-react";
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
      {renderRecentEvents(recentEvents)}
    </div>
  );
};

const renderRecentEvents = recentEvents => {
  if (!recentEvents) {
    return;
  }

  return (
    <Table basic="very">
      <Table.Header>
        <Table.Row>
          <Table.HeaderCell>Event</Table.HeaderCell>
          <Table.HeaderCell>Count</Table.HeaderCell>
          <Table.HeaderCell>Last occurrence</Table.HeaderCell>
        </Table.Row>
      </Table.Header>

      <Table.Body>{recentEvents.map(renderRecentEvent)}</Table.Body>
    </Table>
  );
};

const renderRecentEvent = event => (
  <Table.Row key={event.id}>
    <Table.Cell>{event.name}</Table.Cell>
    <Table.Cell>{event.count}</Table.Cell>
    <Table.Cell>{event.updatedAt}</Table.Cell>
  </Table.Row>
);

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
