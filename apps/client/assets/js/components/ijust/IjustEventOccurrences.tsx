import * as React from "react";
import gql from "graphql-tag";
import { Header, Table } from "semantic-ui-react";
import { css, StyleSheet } from "aphrodite";
import { format, distanceInWordsToNow } from "date-fns";

import { QueryLoader } from "@utils/QueryLoader";
import { Constants } from "@utils/Constants";

const QUERY = gql`
  query GetIjustEventOccurrences($eventId: ID!) {
    getIjustEventOccurrences(eventId: $eventId) {
      id
      insertedAt
    }
  }
`;

const styles = StyleSheet.create({
  relativeDateSpacer: {
    marginLeft: "10px"
  }
});

interface Props {
  eventId: string;
}
export const IjustEventOccurrences = ({ eventId }: Props) => (
  <div>
    <Header>Occurrences</Header>
    <QueryLoader
      query={QUERY}
      variables={{ eventId }}
      component={({ data }) => {
        const occurrences = data.getIjustEventOccurrences;
        return renderOccurrences(occurrences);
      }}
    />
  </div>
);

const renderOccurrences = occurrences => (
  <Table basic="very">
    <Table.Body>{occurrences.map(renderOccurrence)}</Table.Body>
  </Table>
);

const renderOccurrence = occurrence => (
  <Table.Row key={occurrence.id}>
    <Table.Cell>
      {format(occurrence.insertedAt, Constants.dateTimeFormat)}
      <span className={css(styles.relativeDateSpacer)}>
        ({distanceInWordsToNow(occurrence.insertedAt)} ago)
      </span>
    </Table.Cell>
  </Table.Row>
);
