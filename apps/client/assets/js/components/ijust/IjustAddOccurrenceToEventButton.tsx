import Button from "@mui/material/Button";
import React from "react";
import { useMutation } from "urql";

import { graphql } from "../../gql";

const ADD_OCCURRENCE = graphql(`
  mutation IjustAddOccurrenceToEvent($ijustEventId: ID!) {
    ijustAddOccurrenceToEvent(ijustEventId: $ijustEventId) {
      id
      insertedAt
      isDeleted
      ijustEvent {
        id
        ijustContextId
      }
    }
  }
`);

interface Props {
  eventId: string;
}

export function IjustAddOccurrenceToEventButton({ eventId }: Props) {
  const [result, addOccurrence] = useMutation(ADD_OCCURRENCE);
  const { fetching, error } = result;

  return (
    <div>
      {error && <div>{error.message}</div>}
      <Button
        disabled={fetching}
        onClick={() => addOccurrence({ ijustEventId: eventId })}
      >
        Add Occurrence
      </Button>
    </div>
  );
}
