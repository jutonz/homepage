import * as React from "react";
import gql from "graphql-tag";
import { Button, Header, Table } from "semantic-ui-react";

import { QueryLoader } from "./../../utils/QueryLoader";
import { IjustAddOccurrenceToEventButton } from "./IjustAddOccurrenceToEventButton";
import { IjustOccurrence } from "./IjustOccurrence";

export const GET_OCCURRENCES = gql`
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
`;

interface Props {
  contextId: string;
  eventId: string;
}

export class IjustEventOccurrences extends React.Component<Props> {
  constructor(props: Props) {
    super(props);
  }

  render() {
    const { contextId, eventId } = this.props;
    return (
      <div>
        <Header>Occurrences</Header>
        <QueryLoader
          query={GET_OCCURRENCES}
          variables={{ contextId, eventId }}
          component={({ data }) => {
            const occurrences = data.getIjustContextEvent.ijustOccurrences;
            return (
              <div>
                <IjustAddOccurrenceToEventButton eventId={eventId} />
                <Table basic="very">
                  <Table.Body>
                    {occurrences && occurrences.map(this.renderOccurrence)}
                  </Table.Body>
                </Table>
              </div>
            );
          }}
        />
      </div>
    );
  }

  renderOccurrence(occurrence) {
    return <IjustOccurrence occurrence={occurrence} key={occurrence.id} />;
  }
}
