import * as React from "react";
import gql from "graphql-tag";
import { Header } from "semantic-ui-react";

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
    <Header>Event occurrences</Header>
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

const renderOccurrences = occurrences => {
  console.log(occurrences);
  debugger;
};
