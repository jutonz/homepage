import * as React from "react";
import { Table } from "semantic-ui-react";
import { Link } from "react-router-dom";
import { StyleSheet, css } from "aphrodite";
import gql from "graphql-tag";
import { distanceInWordsToNow } from "date-fns";

import { StyleGlobals } from "@app/style-globals";
import { QueryLoader } from "@utils/QueryLoader";

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

const GET_RECENT_EVENTS = gql`
  query FetchIjustRecentEventsQuery($contextId: ID!) {
    getIjustRecentEvents(contextId: $contextId) {
      id
      name
      count
      insertedAt
      updatedAt
      ijustContextId
    }
  }
`;

interface Props {
  context: any;
}

export const IjustRecentEvents = ({ context }: Props) => (
  <div>
    <QueryLoader
      query={GET_RECENT_EVENTS}
      variables={{ contextId: context.id }}
      component={({ data }) => {
        const events = data.getIjustRecentEvents;
        return renderRecentEvents(events, context);
      }}
    />
  </div>
);

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
