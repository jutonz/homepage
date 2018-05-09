import * as React from "react";
import gql from "graphql-tag";
import { Header, Table } from "semantic-ui-react";

import { QueryLoader } from "@utils/QueryLoader";

const QUERY = gql`
  query GetIjustEventOccurrences($eventId: ID!) {
    getIjustEventOccurrences(eventId: $eventId) {
      id
      insertedAt
    }
  }
`;

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
    <Table.Cell>{occurrence.insertedAt}</Table.Cell>
  </Table.Row>
);
