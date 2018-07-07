import * as React from "react";
import gql from "graphql-tag";
import { Button, Header, Table } from "semantic-ui-react";

import { QueryLoader } from "@utils/QueryLoader";
import { IjustAddOccurrenceToEventButton } from "./IjustAddOccurrenceToEventButton";
import { IjustOccurrence } from "@components/ijust/IjustOccurrence";

export const GET_OCCURRENCES = gql`
  query GetIjustEventOccurrences($eventId: ID!, $offset: Int!) {
    getIjustEventOccurrences(eventId: $eventId, offset: $offset) {
      id
      insertedAt
    }
  }
`;

interface State {
  offset: number;
}

interface Props {
  eventId: string;
}

export class IjustEventOccurrences extends React.Component<Props, State> {
  constructor(props: Props) {
    super(props);
    this.state = { offset: 0 };
  }

  render() {
    const { offset } = this.state;
    const { eventId } = this.props;
    return (
      <div>
        <Header>Occurrences</Header>
        <QueryLoader
          query={GET_OCCURRENCES}
          variables={{ eventId, offset }}
          component={({ data, fetchMore }) => {
            const occurrences = data.getIjustEventOccurrences;
            return (
              <div>
                <IjustAddOccurrenceToEventButton
                  eventId={eventId}
                  updateQuery={GET_OCCURRENCES}
                />
                <Table basic="very">
                  <Table.Body>
                    {occurrences
                      .filter(o => !o.isDeleted)
                      .map(this.renderOccurrence)}
                  </Table.Body>
                </Table>
                <Button
                  onClick={() => {
                    fetchMore({
                      variables: { offset: occurrences.length },
                      updateQuery: (prev, { fetchMoreResult }) => {
                        if (!fetchMoreResult) {
                          return prev;
                        }
                        return Object.assign({}, prev, {
                          getIjustEventOccurrences: [
                            ...prev.getIjustEventOccurrences,
                            ...fetchMoreResult.getIjustEventOccurrences
                          ]
                        });
                      }
                    });
                  }}
                >
                  Load more
                </Button>
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
