import * as React from "react";
import { Header, Loader, Table } from "semantic-ui-react";
import { Link } from "react-router-dom";
import { StyleSheet, css } from "aphrodite";
import { connect } from "react-redux";
import { distanceInWordsToNow } from "date-fns";

import { StyleGlobals } from "@app/style-globals";
import { fetchRecentEvents } from "@store/sagas/ijust";

const styles = StyleSheet.create({
  recentEvent: {
    ":hover": {
      color: StyleGlobals.brandPrimary,
      cursor: "pointer"
    },
    ":hover a": {
      color: StyleGlobals.brandPrimary
    }
  },
  eventLink: { display: "flex" }
});

interface Props {
  context: any;
  fetchEvents(any): any;
  isLoading: boolean;
  errors: Array<string> | null;
  recentEvents: Array<any> | null;
}
const _IjustRecentEvents = ({
  context,
  fetchEvents,
  isLoading,
  errors,
  recentEvents
}: Props) => {
  if (!recentEvents && !isLoading && !errors) {
    fetchEvents(context.id);
  }

  return (
    <div>
      <Header>Recent events</Header>
      {errors}
      <Loader active={isLoading} inline />
      {renderRecentEvents(recentEvents, context)}
    </div>
  );
};

const renderRecentEvents = (recentEvents, context) => {
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

      <Table.Body>
        {recentEvents.map(ev => renderRecentEvent(ev, context))}
      </Table.Body>
    </Table>
  );
};

const renderRecentEvent = (event, context) => (
  <Table.Row key={event.id} className={css(styles.recentEvent)}>
    <Table.Cell>
      <Link
        to={`/ijust/contexts/${context.id}/events/${event.id}`}
        className={css(styles.eventLink)}
      >
        {event.name}
      </Link>
    </Table.Cell>
    <Table.Cell>
      <Link
        to={`/ijust/contexts/${context.id}/events/${event.id}`}
        className={css(styles.eventLink)}
      >
        {event.count}
      </Link>
    </Table.Cell>
    <Table.Cell>
      <Link
        to={`/ijust/contexts/${context.id}/events/${event.id}`}
        className={css(styles.eventLink)}
      >
        {distanceInWordsToNow(event.updatedAt)} ago
      </Link>
    </Table.Cell>
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
  (state: any, props: any) => ({
    recentEvents: extractRecentEvents(state, props.context.id),
    isLoading: state.ijust.get("isLoadingRecentEvents"),
    errors: state.ijust.get("loadRecentEventsErrors")
  }),
  dispatch => ({
    fetchEvents: contextId => dispatch(fetchRecentEvents(contextId))
  })
)(_IjustRecentEvents);
