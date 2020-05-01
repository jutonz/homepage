import * as React from "react";
import { Button } from "semantic-ui-react";
import gql from "graphql-tag";
import { Mutation } from "react-apollo";

import collectGraphqlErrors from "@utils/collectGraphqlErrors";

const ADD_OCCURRENCE = gql`
  mutation IjustAddOccurrenceToEvent($ijustEventId: ID!) {
    ijustAddOccurrenceToEvent(ijustEventId: $ijustEventId) {
      id
      insertedAt
      isDeleted
    }
  }
`;

interface Props {
  eventId: string;
  updateQuery: any;
}
export const IjustAddOccurrenceToEventButton = ({
  eventId,
  updateQuery,
}: Props) => (
  <div>
    <Mutation
      mutation={ADD_OCCURRENCE}
      update={(cache, { data }) => {
        const newOccurrence = data.ijustAddOccurrenceToEvent;
        const { getIjustEventOccurrences } = cache.readQuery({
          query: updateQuery,
          variables: { eventId, offset: 0 },
        });

        const newOccurrences = [newOccurrence, ...getIjustEventOccurrences];
        cache.writeQuery({
          query: updateQuery,
          variables: { eventId, offset: 0 },
          data: { getIjustEventOccurrences: newOccurrences },
        });
      }}
    >
      {(addOccurrence, { loading, error }) => {
        return (
          <div>
            {error && collectGraphqlErrors(error)}
            <Button
              loading={loading}
              onClick={() =>
                addOccurrence({
                  variables: { ijustEventId: eventId },
                })
              }
            >
              Add Occurrence
            </Button>
          </div>
        );
      }}
    </Mutation>
  </div>
);
