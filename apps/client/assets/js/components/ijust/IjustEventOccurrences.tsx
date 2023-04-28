import React from "react";

import { QueryLoader } from "./../../utils/QueryLoader";
import { IjustAddOccurrenceToEventButton } from "./IjustAddOccurrenceToEventButton";
import { IjustOccurrence as IjustOccurrenceComponent } from "./IjustOccurrence";
import type { IjustOccurrence } from "@types";
import { graphql } from "../../gql";

export const GET_OCCURRENCES = graphql(`
  query GetIjustContextEvent($contextId: ID!, $eventId: ID!) {
    getIjustContextEvent(contextId: $contextId, eventId: $eventId) {
      id
      ijustContextId
      ijustOccurrences {
        id
        insertedAt
        updatedAt
        isDeleted
      }
    }
  }
`);

interface Props {
  contextId: string;
  eventId: string;
}

export function IjustEventOccurrences({ contextId, eventId }: Props) {
  return (
    <div className="mt-3">
      <h2>Occurrences</h2>
      <QueryLoader
        query={GET_OCCURRENCES}
        variables={{ contextId, eventId }}
        component={({ data }) => {
          const occurrences = data.getIjustContextEvent.ijustOccurrences;
          return (
            <div className="w-full">
              <IjustAddOccurrenceToEventButton eventId={eventId} />
              {occurrences && occurrences.map(renderOccurrence)}
            </div>
          );
        }}
      />
    </div>
  );
}

function renderOccurrence(occurrence: IjustOccurrence) {
  return (
    <IjustOccurrenceComponent occurrence={occurrence} key={occurrence.id} />
  );
}
