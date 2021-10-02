import * as React from "react";
import { Link } from "react-router-dom";
import gql from "graphql-tag";
import { formatDistanceToNow, parseISO } from "date-fns";

import { QueryLoader } from "./../../utils/QueryLoader";

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

  return <div>{recentEvents.map((ev) => renderRecentEvent(ev, context))}</div>;
};

const renderRecentEvent = (event, context) => (
  <Link
    to={`/ijust/contexts/${context.id}/events/${event.id}`}
    className="flex flex-col px-2 py-5 border-b last:border-none"
    key={event.id}
  >
    <div className="flex text-lg">{event.name}</div>
    <div className="flex justify-between">
      <div className="pl-1">x {event.count}</div>
      <div>{formatDistanceToNow(parseISO(event.updatedAt + "Z"))} ago</div>
    </div>
  </Link>
);

const renderEmptyState = () => (
  <div>You haven't added any events. Get to it!</div>
);
