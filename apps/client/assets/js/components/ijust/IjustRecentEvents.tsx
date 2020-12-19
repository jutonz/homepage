import * as React from "react";
import { Table } from "semantic-ui-react";
import { Link } from "react-router-dom";
import gql from "graphql-tag";
import { formatDistanceToNow, parseISO } from "date-fns";

import { QueryLoader } from "@utils/QueryLoader";

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
    return <></>;
  }

  if (recentEvents.length < 1) {
    return renderEmptyState();
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
        {recentEvents.map((ev) => renderRecentEvent(ev, context))}
      </Table.Body>
    </Table>
  );
};

const renderRecentEvent = (event, context) => (
  <Table.Row key={event.id} className="cursor-pointer hover:text-primary">
    <Table.Cell>
      <Link
        to={`/ijust/contexts/${context.id}/events/${event.id}`}
        className="flex"
      >
        {event.name}
      </Link>
    </Table.Cell>
    <Table.Cell>
      <Link
        to={`/ijust/contexts/${context.id}/events/${event.id}`}
        className="flex"
      >
        {event.count}
      </Link>
    </Table.Cell>
    <Table.Cell>
      <Link
        to={`/ijust/contexts/${context.id}/events/${event.id}`}
        className="flex"
      >
        {formatDistanceToNow(parseISO(event.updatedAt + "Z"))} ago
      </Link>
    </Table.Cell>
  </Table.Row>
);

const renderEmptyState = () => (
  <div>You haven't added any events. Get to it!</div>
);
