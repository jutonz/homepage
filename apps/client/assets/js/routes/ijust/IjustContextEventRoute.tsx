import React from "react";
import gql from "graphql-tag";
import { format, formatDistanceToNow, parseISO } from "date-fns";
import { useParams } from "react-router-dom";

import { MainNav } from "./../../components/MainNav";
import { IjustEventOccurrences } from "./../../components/ijust/IjustEventOccurrences";
import { Constants } from "./../../utils/Constants";
import { QueryLoader } from "./../../utils/QueryLoader";
import { IjustBreadcrumbs } from "./../../components/ijust/IjustBreadcrumbs";
import type { IjustEvent, IjustContext } from "@types";

const QUERY = gql`
  query GetIjustContextEvent($contextId: ID!, $eventId: ID!) {
    getIjustContextEvent(contextId: $contextId, eventId: $eventId) {
      id
      name
      count
      insertedAt
      updatedAt
      ijustContextId
      ijustContext {
        id
        name
      }
    }
  }
`;

interface GetEventQuery {
  getIjustContextEvent: IjustEvent;
}

export function IjustContextEventRoute() {
  const { contextId, eventId } = useParams();

  return (
    <div>
      <MainNav />
      <div className="m-4 max-w-3xl lg:mx-auto">
        <QueryLoader<GetEventQuery>
          query={QUERY}
          variables={{ contextId, eventId }}
          component={({ data }) => {
            const event = data.getIjustContextEvent;
            const context = data.getIjustContextEvent.ijustContext;
            return renderEvent(event, context);
          }}
        />
      </div>
    </div>
  );
}

const renderEvent = (event: IjustEvent, context: IjustContext) => (
  <div>
    <IjustBreadcrumbs context={context} event={event} viewing={event} />

    <table className="mt-3 w-full">
      <tbody>
        <tr>
          <td className="py-3">Count</td>
          <td className="py-3">{event.count}</td>
        </tr>
        <tr>
          <td className="py-3">First occurred</td>
          <td className="py-3">
            {format(parseISO(event.insertedAt + "Z"), Constants.dateTimeFormat)}
            <span className="ml-3">
              ({formatDistanceToNow(parseISO(event.insertedAt + "Z"))} ago)
            </span>
          </td>
        </tr>
        <tr>
          <td className="py-3">Last occurred</td>
          <td className="py-3">
            {format(parseISO(event.updatedAt + "Z"), Constants.dateTimeFormat)}
            <span className="ml-3">
              ({formatDistanceToNow(parseISO(event.updatedAt + "Z"))} ago)
            </span>
          </td>
        </tr>
      </tbody>
    </table>

    <IjustEventOccurrences contextId={context.id} eventId={event.id} />
  </div>
);
