import * as React from "react";
import gql from "graphql-tag";
import { Table } from "semantic-ui-react";
import { format, formatDistanceToNow, parseISO } from "date-fns";

import { MainNav } from "./../../components/MainNav";
import { IjustEventOccurrences } from "./../../components/ijust/IjustEventOccurrences";
import { Constants } from "./../../utils/Constants";
import { QueryLoader } from "./../../utils/QueryLoader";
import { IjustBreadcrumbs } from "./../../components/ijust/IjustBreadcrumbs";

const QUERY = gql`
  query GetIjustContextEvent($contextId: ID!, $eventId: ID!) {
    getIjustContextEvent(contextId: $contextId, eventId: $eventId) {
      id
      name
      count
      insertedAt
      updatedAt
      ijustContextId
    }
  }
`;

export const IjustContextEventRoute = ({ match }) => {
  const { contextId, eventId } = match.params;

  return (
    <div>
      <MainNav activeItem="ijust" />
      <div className="m-4 max-w-3xl lg:mx-auto">
        <QueryLoader
          query={QUERY}
          variables={{ contextId, eventId }}
          component={({ data }) => {
            const event = data.getIjustContextEvent;
            // TODO: hacky hack
            const context = { name: "default", id: contextId };
            return renderEvent(event, context);
          }}
        />
      </div>
    </div>
  );
};

const renderEvent = (event, context) => (
  <div>
    <IjustBreadcrumbs context={context} event={event} viewing={event} />
    <Table basic="very">
      <Table.Body>
        <Table.Row>
          <Table.Cell>Count</Table.Cell>
          <Table.Cell>{event.count}</Table.Cell>
        </Table.Row>
        <Table.Row>
          <Table.Cell>First occurred</Table.Cell>
          <Table.Cell>
            {format(parseISO(event.insertedAt + "Z"), Constants.dateTimeFormat)}
            <span className="ml-3">
              ({formatDistanceToNow(parseISO(event.insertedAt + "Z"))} ago)
            </span>
          </Table.Cell>
        </Table.Row>
        <Table.Row>
          <Table.Cell>Last occurred</Table.Cell>
          <Table.Cell>
            {format(parseISO(event.updatedAt + "Z"), Constants.dateTimeFormat)}
            <span className="ml-3">
              ({formatDistanceToNow(parseISO(event.updatedAt + "Z"))} ago)
            </span>
          </Table.Cell>
        </Table.Row>
      </Table.Body>
    </Table>

    <IjustEventOccurrences contextId={context.id} eventId={event.id} />
  </div>
);
