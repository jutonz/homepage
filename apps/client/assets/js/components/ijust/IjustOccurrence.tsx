import React from "react";
import { css, StyleSheet } from "aphrodite";
import { format, formatDistanceToNow, parseISO } from "date-fns";
import { useState } from "react";
import { Button } from "semantic-ui-react";
import { gql, useMutation } from "urql";

import type { IjustOccurrence as OccurrenceType } from "@types";
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
      ijustEventId
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
  occurrence: OccurrenceType;
}
export const IjustOccurrence = ({ occurrence }: Props) => {
  return (
    <div className="flex flex-row mt-5">
      <div className="flex flex-row flex-1">
        {format(
          parseISO(occurrence.insertedAt + "Z"),
          Constants.dateTimeFormat
        )}
        <span className={css(styles.relativeDateSpacer)}>
          ({formatDistanceToNow(parseISO(occurrence.insertedAt + "Z"))} ago)
        </span>
      </div>
      <div>{renderDeleteButton(occurrence)}</div>
    </div>
  );
};

const renderDeleteButton = (occurrence: OccurrenceType) => {
  const [showConfirm, setShowConfirm] = useState(false);
  const [result, deleteOccurrence] = useMutation(DELETE_OCCURRENCE);
  const variables = { occurrenceId: occurrence.id };

  return (
    <>
      <Button onClick={() => setShowConfirm(true)} loading={result.fetching}>
        Delete
      </Button>
      <Confirm
        open={showConfirm}
        onCancel={() => setShowConfirm(false)}
        onConfirm={() => deleteOccurrence(variables)}
        loading={result.fetching}
      />
    </>
  );
};
