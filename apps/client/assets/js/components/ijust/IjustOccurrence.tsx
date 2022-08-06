import * as React from "react";
import { useState } from "react";
import { Button, Table } from "semantic-ui-react";
import { css, StyleSheet } from "aphrodite";
import { format, formatDistanceToNow, parseISO } from "date-fns";
import { useMutation } from "@apollo/react-hooks";
import { gql } from "urql";

import { Constants } from "./../../utils/Constants";
import { Confirm } from "./../Confirm";

const styles = StyleSheet.create({
  relativeDateSpacer: {
    marginLeft: "10px",
  },
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
export const IjustOccurrence = ({ occurrence }: Props) => {
  return (
    <Table.Row>
      <Table.Cell>
        {format(
          parseISO(occurrence.insertedAt + "Z"),
          Constants.dateTimeFormat
        )}
        <span className={css(styles.relativeDateSpacer)}>
          ({formatDistanceToNow(parseISO(occurrence.insertedAt + "Z"))} ago)
        </span>
      </Table.Cell>
      <Table.Cell>{renderDeleteButton(occurrence)}</Table.Cell>
    </Table.Row>
  );
};

const renderDeleteButton = (occurrence: any) => {
  const [_deleteOccurrence, deletionResult] = useMutation(DELETE_OCCURRENCE);
  const [showConfirm, setShowConfirm] = useState(false);

  const deleteOccurrence = () => {
    return _deleteOccurrence({
      variables: { occurrenceId: occurrence.id },
      update: updateCacheAfterDelete,
    });
  };

  return (
    <>
      <Button
        onClick={() => setShowConfirm(true)}
        loading={deletionResult.loading}
      >
        Delete
      </Button>
      <Confirm
        open={showConfirm}
        onCancel={() => setShowConfirm(false)}
        onConfirm={() => deleteOccurrence()}
        loading={deletionResult.loading}
      />
    </>
  );
};

const updateCacheAfterDelete = (cache: any, { data }) => {
  const deleted = {
    ...data.ijustDeleteOccurrence,
    isDeleted: true,
  };
  cache.writeQuery({
    query: GET_OCCURRENCE,
    variables: { occurrenceId: deleted.id },
    data: { getIjustEventOccurrence: deleted },
  });
};
