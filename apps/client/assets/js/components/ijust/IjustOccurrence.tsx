import * as React from "react";
import { Button, Table } from "semantic-ui-react";
import { css, StyleSheet } from "aphrodite";
import { format, formatDistanceToNow, parseISO } from "date-fns";
import { Mutation } from "react-apollo";
import gql from "graphql-tag";

import { Constants } from "@utils/Constants";

const styles = StyleSheet.create({
  relativeDateSpacer: {
    marginLeft: "10px"
  }
});

const DELETE_OCCURRENCE = gql`
  mutation IjustDeleteOccurrence($occurrenceId: ID!) {
    ijustDeleteOccurrence(ijustOccurrenceId: $occurrenceId) {
      id
    }
  }
`;

export const GET_OCCURRENCE = gql`
  query GetIjustEventOccurrence($occurrenceId: ID!) {
    getIjustEventOccurrence(occurrenceId: $occurrenceId) {
      id
      isDeleted
    }
  }
`;

interface Props {
  occurrence: any;
}
export const IjustOccurrence = ({ occurrence }: Props) => (
  <Table.Row>
    <Table.Cell>
      {format(parseISO(occurrence.insertedAt + "Z"), Constants.dateTimeFormat)}
      <span className={css(styles.relativeDateSpacer)}>
        ({formatDistanceToNow(parseISO(occurrence.insertedAt + "Z"))} ago)
      </span>
    </Table.Cell>
    <Table.Cell>{renderDeleteButton(occurrence)}</Table.Cell>
  </Table.Row>
);

const renderDeleteButton = (occurrence: any) => (
  <Mutation
    mutation={DELETE_OCCURRENCE}
    update={(cache, { data }) => {
      const deleted = {
        ...data.ijustDeleteOccurrence,
        isDeleted: true
      };
      cache.writeQuery({
        query: GET_OCCURRENCE,
        variables: { occurrenceId: deleted.id },
        data: { getIjustEventOccurrence: deleted }
      });
    }}
  >
    {(deleteMutation, { loading, error }) => (
      <Button
        onClick={() =>
          deleteMutation({ variables: { occurrenceId: occurrence.id } })
        }
        loading={loading}
      >
        Delete
      </Button>
    )}
  </Mutation>
);
