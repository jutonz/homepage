import * as React from "react";
import gql from "graphql-tag";
import { Header, Table } from "semantic-ui-react";
import { css, StyleSheet } from "aphrodite";
import { format, distanceInWordsToNow } from "date-fns";

import { MainNav } from "@components/MainNav";
import { QueryLoader } from "@utils/QueryLoader";
import { IjustEventOccurrences } from "@components/ijust/IjustEventOccurrences";
import { Constants } from "@utils/Constants";
import { IjustBreadcrumbs } from "@components/ijust/IjustBreadcrumbs";

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

const styles = StyleSheet.create({
  routeContainer: {
    margin: "30px auto",
    maxWidth: "700px"
  },
  relativeDateSpacer: {
    marginLeft: "10px"
  }
});

export const IjustContextEventRoute = ({ match }) => {
  const { contextId, eventId } = match.params;

  return (
    <div>
      <MainNav activeItem="ijust" />
      <div className={css(styles.routeContainer)}>
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
            {format(event.insertedAt, Constants.dateTimeFormat)}
            <span className={css(styles.relativeDateSpacer)}>
              ({distanceInWordsToNow(event.insertedAt)} ago)
            </span>
          </Table.Cell>
        </Table.Row>
        <Table.Row>
          <Table.Cell>Last occurred</Table.Cell>
          <Table.Cell>
            {format(event.updatedAt, Constants.dateTimeFormat)}
            <span className={css(styles.relativeDateSpacer)}>
              ({distanceInWordsToNow(event.updatedAt)} ago)
            </span>
          </Table.Cell>
        </Table.Row>
      </Table.Body>
    </Table>

    <IjustEventOccurrences eventId={event.id} />
  </div>
);
